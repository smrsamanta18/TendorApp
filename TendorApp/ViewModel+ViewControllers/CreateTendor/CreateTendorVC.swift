//
//  CreateTendorVC.swift
//  TendorApp
//
//  Created by Raghav Beriwala on 30/08/19.
//  Copyright © 2019 Asif Dafadar. All rights reserved.
//

import UIKit
import Foundation
import Alamofire
import AlamofireObjectMapper

class CreateTendorVC: BaseViewController , headerMenuActionDelegate{
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var profileImg: UIImageView!
    
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var pickerMainView: UIView!
    var pickerType : String?
    var arrImg = NSArray()
    var arrName = [String]()
    lazy var viewModel: PublishTendorVM = {
        return PublishTendorVM()
    }()
    var countryList : [CountryListArray]?
    var publishObj = PublishTendorObject()
    let datePicker = UIDatePicker()
    let toolbar = UIToolbar()
    
    var imagePicker = UIImagePickerController()
    var userSelectedImage : UIImage?
    
    lazy var catViewModel: HomeVM = {
        return HomeVM()
    }()
    var CategoryDetails = CategoryModel()
    var categoryList : [CategoryList]?
    
    var serviceList : [ServiceList]?
    var productList : [ProductList]?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.imagePicker.delegate = self
        self.navigationController?.isNavigationBarHidden = true
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.setNeedsStatusBarAppearanceUpdate()
        if #available(iOS 13.0, *) {
            let statusBar = UIView(frame: UIApplication.shared.keyWindow?.windowScene?.statusBarManager?.statusBarFrame ?? CGRect.zero)
             statusBar.backgroundColor = UIColor.clear
             UIApplication.shared.keyWindow?.addSubview(statusBar)
        } else {
             UIApplication.shared.statusBarView?.backgroundColor = UIColor.clear
        }
        headerView.lblHeaderTitle.text = "Publish Tendor"
        headerView.imgProfileIcon.isHidden = true
        headerView.menuButtonOutlet.isHidden = true
        headerView.imgViewMenu.isHidden = true
        headerView.menuButtonOutlet.tag = 1
        headerView.imgViewMenu.image = UIImage(named:"whiteback")
        tabBarView.addTenderImg.image = UIImage(named: "TenderCreateSelect")
        
        arrName = ["Tendor Title", "Tendor Type", "Select Category", "Select Country", "Tendor Description", "Tendor Closing Date"," "]
        
//        profileImg.layer.masksToBounds = false
//        profileImg.layer.cornerRadius = profileImg.frame.height/2
//        profileImg.clipsToBounds = true
        
//        pickerView.delegate = self
//        pickerView.dataSource = self
        pickerMainView.isHidden = true
        pickerView.delegate = self
        pickerView.dataSource = self
        //publishObj.tender_description = "Tendor Description"
        headerView.homeDelegate = self
        headerView.lblHeaderTitle.text = "Publish Tendor"
        headerView.imgProfileIcon.isHidden = true
        headerView.menuButtonOutlet.isHidden = false
        headerView.imgViewMenu.isHidden = false
        headerView.menuButtonOutlet.tag = 1
        headerView.imgViewMenu.image = UIImage(named:"BackBtn")
        tabBarView.lblAddTendor.textColor = UIColor(red: 74/255, green: 174/255, blue: 177/255, alpha: 1.0)
        initializeViewModel()
        showDatePicker()
        getCategoryDetails()
        initializeCateViewModel()
        getCountryDetails()
    }
    
    func getCategoryDetails(){
        let obj = dashboardParam()
        obj.action = "category"
        catViewModel.getCategoryDetailsToAPIService(user: obj)
    }
    
    func initializeCateViewModel() {
        
        catViewModel.showAlertClosure = {[weak self]() in
            DispatchQueue.main.async {
                if let message = self?.catViewModel.alertMessage {
                    self?.showAlertWithSingleButton(title: commonAlertTitle, message: message, okButtonText: okText, completion: nil)
                }
            }
        }
        
        catViewModel.updateLoadingStatus = {[weak self]() in
            DispatchQueue.main.async {
                
                let isLoading = self?.catViewModel.isLoading ?? false
                if isLoading {
                    self?.addLoaderView()
                } else {
                    self?.removeLoaderView()
                }
            }
        }
        
        catViewModel.refreshViewClosure = {[weak self]() in
            DispatchQueue.main.async {
                self!.categoryList = (self?.catViewModel.CategoryDetails.categoryList)!
                
                self!.serviceList = (self?.catViewModel.CategoryDetails.serviceList)!
                self!.productList = (self?.catViewModel.CategoryDetails.productList)!
            }
        }
    }
    
    func postPublishTendorDetails(){
        let obj = PublishTendorParam()
        obj.action = "publish-tender"
        obj.authorizationToken = AppPreferenceService.getString(PreferencesKeys.userToken)
        obj.title = publishObj.title
        obj.cat_id = publishObj.cat_id
        obj.sub_cat_id = "22"
        obj.tender_description = publishObj.tender_description
        obj.opening_date = publishObj.opening_date
        obj.exp_date = publishObj.exp_date
       // viewModel.postTendorPublishDetailsToAPIService(user: obj)
        
        
        if let params = self.validateUserInputs(user: obj) {
            if let img = userSelectedImage {
                let data = img.jpegData(compressionQuality: 0)
                self.requestWith(endUrl: "https://www.tendor.org/app-api.php", imageData: data, parameters: params)
            }
        }
        
    }
    
    func validateUserInputs(user: PublishTendorParam) -> [String: Any]? {
        guard let title = user.title, !title.isEmpty else {
            
            self.showAlertWithSingleButton(title: commonAlertTitle, message: "Please enter title", okButtonText: okText, completion: nil)
            return nil
        }
        guard let cat_id = user.cat_id, !cat_id.isEmpty else {
            self.showAlertWithSingleButton(title: commonAlertTitle, message: "Please select type", okButtonText: okText, completion: nil)
            return nil
        }
        guard let tender_description = user.tender_description, !tender_description.isEmpty else {
            self.showAlertWithSingleButton(title: commonAlertTitle, message: "Please tendor description", okButtonText: okText, completion: nil)
            return nil
        }
        guard let exp_date = user.exp_date, !exp_date.isEmpty else {
            self.showAlertWithSingleButton(title: commonAlertTitle, message: "Please select closing date", okButtonText: okText, completion: nil)
            return nil
        }
        return user.toJSON()
    }
    
    func getCountryDetails(){
        let obj = MyTendorParam()
        obj.action = "country-list"
        viewModel.getCountryListDetailsToAPIService(user: obj)
    }
    
    func initializeViewModel() {
        
        viewModel.showAlertClosure = {[weak self]() in
            DispatchQueue.main.async {
                if let message = self?.viewModel.alertMessage {
                    self?.showAlertWithSingleButton(title: commonAlertTitle, message: message, okButtonText: okText, completion: nil)
                }
            }
        }
        
        viewModel.updateLoadingStatus = {[weak self]() in
            DispatchQueue.main.async {
                
                let isLoading = self?.viewModel.isLoading ?? false
                if isLoading {
                    self?.addLoaderView()
                } else {
                    self?.removeLoaderView()
                }
            }
        }
        
        viewModel.refreshViewClosure = {[weak self]() in
            DispatchQueue.main.async {
                
                if self!.viewModel.PublishTendor.isSuccess == true {
                    self?.showAlertWithSingleButton(title: commonAlertTitle, message: self!.viewModel.PublishTendor.message!, okButtonText: okText, completion: {
                        self!.publishObj = PublishTendorObject()
                        self!.tableView.reloadData()
                    })
                }
            }
        }
        
        viewModel.refreshCountryViewClosure = {[weak self]() in
            DispatchQueue.main.async {
                
                if self!.viewModel.countryModel.countryList != nil {
                    self!.countryList = self!.viewModel.countryModel.countryList
                }
            }
        }
    }
    
    
    func homeMneu(){
        let vc = UIStoryboard.init(name: "Buyer", bundle: Bundle.main).instantiateViewController(withIdentifier: "BuyerMenuVC") as? BuyerMenuVC
        self.navigationController?.pushViewController(vc!, animated: true)
        
        
    }
    
    
    @IBAction func btnSubmitTapped(_ sender: Any){
        self.postPublishTendorDetails()
    }
    
    @IBAction func btnCancelTapped(_ sender: Any){
        self.navigationController?.popViewController(animated: true)
    }
    
    func showDatePicker(){
        datePicker.datePickerMode = .date
        datePicker.minimumDate =  Date()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(CreateTendorVC.donedatePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(CreateTendorVC.cancelDatePicker))
        toolbar.setItems([cancelButton, spaceButton,doneButton], animated: false)
    }
    
    @objc func donedatePicker(){
      //For date formate
        
       let formatter = DateFormatter()
       formatter.dateFormat = "yyyy-MM-dd"
       publishObj.exp_date = formatter.string(from: datePicker.date)
       publishObj.opening_date = formatter.string(from: Date())
       self.view.endEditing(true)
       tableView.reloadData()
    }
    
    @IBAction func btnPickerSubmitAction(_ sender: Any) {
        pickerMainView.isHidden = true
    }
    
    @objc func cancelDatePicker(){
      self.view.endEditing(true)
    }
    
    func selectCountry(){
        pickerType = "Country"
        pickerMainView.isHidden = false
        pickerView.reloadAllComponents()
    }
    
    func selectType(){
        
        pickerType = "Type"
        pickerMainView.isHidden = false
        pickerView.reloadAllComponents()
    }
    
    
    func selectCategory(){
        
        if publishObj.cat_Type != nil {
            pickerType = "Category"
            pickerMainView.isHidden = false
            pickerView.reloadAllComponents()
        }else{
            self.showAlertWithSingleButton(title: commonAlertTitle, message: "Please select Type", okButtonText: okText, completion: nil)
        }
    }
    
    func selectClosingDate(){
        pickerType = "ClosingDate"
        pickerMainView.isHidden = true
        pickerView.reloadAllComponents()
    }
    
    func selectDocumentDate(){
        selectUserImageAction()
    }
}

extension CreateTendorVC : UITableViewDelegate, UITableViewDataSource,signUpDelegates {
        func numberOfSections(in tableView: UITableView) -> Int {
            return 1
        }
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return arrName.count
        }
        //"leftmenu-icon-messages.png"
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let Cell = tableView.dequeueReusableCell(withIdentifier: "PublishTendorCell") as! PublishTendorCell
            Cell.txtFieldVAlue.placeholder = arrName[indexPath.row]
            switch indexPath.row {
            case 0:
                Cell.txtFieldVAlue.text = publishObj.title
                Cell.imgView.isHidden =  true
                Cell.dropDownBtnOutlet.isHidden = true
                Cell.descriptionTxtView.isHidden = true
                Cell.txtFieldVAlue.isHidden = false
                Cell.productImgView.isHidden = true
                Cell.lblImgName.isHidden = true
                Cell.imgUploadIcon.isHidden = true
                
            case 1:
                Cell.txtFieldVAlue.text = publishObj.cat_Type
                Cell.imgView.isHidden =  false
                Cell.dropDownBtnOutlet.isHidden = false
                Cell.dropDownBtnOutlet.tag = indexPath.row
                Cell.descriptionTxtView.isHidden = true
                Cell.txtFieldVAlue.isHidden = false
                Cell.productImgView.isHidden = true
                Cell.lblImgName.isHidden = true
                Cell.imgUploadIcon.isHidden = true
            case 2:
                Cell.txtFieldVAlue.text = publishObj.cat_Name
                Cell.imgView.isHidden =  false
                Cell.dropDownBtnOutlet.isHidden = false
                Cell.dropDownBtnOutlet.tag = indexPath.row
                Cell.descriptionTxtView.isHidden = true
                Cell.txtFieldVAlue.isHidden = false
                Cell.productImgView.isHidden = true
                Cell.lblImgName.isHidden = true
                Cell.imgUploadIcon.isHidden = true
            case 3:
                Cell.txtFieldVAlue.text = publishObj.country
                Cell.imgView.isHidden =  false
                Cell.dropDownBtnOutlet.isHidden = false
                Cell.dropDownBtnOutlet.tag = indexPath.row
                Cell.descriptionTxtView.isHidden = true
                Cell.txtFieldVAlue.isHidden = false
                Cell.productImgView.isHidden = true
                Cell.lblImgName.isHidden = true
                Cell.imgUploadIcon.isHidden = true
            case 4:
                Cell.descriptionTxtView.isHidden = false
                Cell.descriptionTxtView.text = publishObj.tender_description
                Cell.imgView.isHidden =  true
                Cell.dropDownBtnOutlet.isHidden = true
                Cell.dropDownBtnOutlet.tag = indexPath.row
                Cell.txtFieldVAlue.isHidden = false
                Cell.productImgView.isHidden = true
                Cell.lblImgName.isHidden = true
                Cell.imgUploadIcon.isHidden = true
            case 5:
                Cell.descriptionTxtView.isHidden = true
                Cell.txtFieldVAlue.text = publishObj.exp_date
                Cell.imgView.isHidden =  false
                Cell.dropDownBtnOutlet.isHidden = true
                Cell.dropDownBtnOutlet.tag = indexPath.row
                Cell.txtFieldVAlue.inputAccessoryView = toolbar
                Cell.txtFieldVAlue.inputView = datePicker
                Cell.txtFieldVAlue.isHidden = false
                Cell.productImgView.isHidden = true
                Cell.lblImgName.isHidden = true
                Cell.imgUploadIcon.isHidden = true
            case 6:
                Cell.descriptionTxtView.isHidden = true
                Cell.txtFieldVAlue.text = ""
                Cell.imgView.isHidden =  false
                Cell.dropDownBtnOutlet.isHidden = false
                Cell.dropDownBtnOutlet.tag = indexPath.row
                Cell.txtFieldVAlue.isHidden = false
                Cell.productImgView.isHidden = false
                Cell.lblImgName.isHidden = false
                Cell.imgUploadIcon.isHidden = false
                if let data = publishObj.attacheImg {
                    Cell.lblImgName.isHidden = false
                    Cell.lblImgName.text = publishObj.attachment
                    Cell.productImgView.image = data
                }
            default:
               return UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "Cell")
            }
            Cell.descriptionTxtView.delegate = self
            Cell.dobDelegates = self
            Cell.txtFieldVAlue.tag = indexPath.row
            Cell.txtFieldVAlue.delegate = self
            return Cell
        }
        
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            
            if indexPath.row == 4 {
                return 110
            }else if indexPath.row == 6 {
                return 110
            }else{
                return 58
            }
        }
}

extension CreateTendorVC : UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range:NSRange, replacementString string: String) -> Bool {
        let txtAfterUpdate = textField.text! as NSString
        let updateText = txtAfterUpdate.replacingCharacters(in: range, with: string) as NSString
        print("Updated TextField:: \(updateText)")
        switch textField.tag {
            case 0:
                publishObj.title = updateText as String
            case 4:
                publishObj.tender_description = updateText as String
            default:
                break
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField){
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
}

extension CreateTendorVC : UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "Tendor Description" {
            textView.text = ""
        }
        let indexPath = IndexPath(row: 4, section: 0)
        let cell: PublishTendorCell = self.tableView.cellForRow(at: indexPath) as! PublishTendorCell
        cell.txtFieldVAlue.isHidden = true
        self.tableView.reloadRows(at: [indexPath], with: .none)
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool{
        publishObj.tender_description = textView.text
        return true
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        print("print2")
    }
}

extension CreateTendorVC : UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerType {
        case "Country":
            return countryList!.count
        case "Type":
            return categoryList!.count
        case "Category":
            if publishObj.cat_Type == "Products" {
                return productList!.count
            }else{
                return serviceList!.count
            }
            
        default:
            return 0
        }
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        switch pickerType {
        case "Country":
            return  countryList![row].name
        case "Type":
            return categoryList![row].cat_name
        case "Category":
            if publishObj.cat_Type == "Products" {
                return productList![row].cat_name
            }else{
                return serviceList![row].cat_name
            }
        default:
            return ""
        }
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        switch pickerType {
        case "Type":
            publishObj.cat_Type = categoryList![row].cat_name
        case "Category":
            
            if publishObj.cat_Type == "Products" {
                publishObj.cat_id = productList![row].cat_id
                publishObj.cat_Name = productList![row].cat_name
            }else{
                publishObj.cat_id = serviceList![row].cat_id
                publishObj.cat_Name = serviceList![row].cat_name
            }
        case "Country":
            publishObj.country = countryList![row].name
        default:
            break
        }
        tableView.reloadData()
    }
}
extension CreateTendorVC : UINavigationControllerDelegate,UIImagePickerControllerDelegate {
    
    func selectUserImageAction() {
        
        let alert:UIAlertController=UIAlertController(title: nil , message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        let cameraAction = UIAlertAction(title: "Camera", style: UIAlertAction.Style.default)
        {
            UIAlertAction in
            self.openCamera()
        }
        
        let gallaryAction = UIAlertAction(title: "Gallery", style: UIAlertAction.Style.default)
        {
            UIAlertAction in
            self.openGallary()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.destructive)
        {
            UIAlertAction in
        }
        
        
        alert.addAction(cameraAction)
        alert.addAction(gallaryAction)
        alert.addAction(cancelAction)
        if let popoverPresentationController = alert.popoverPresentationController {
            popoverPresentationController.sourceView = self.view
            popoverPresentationController.sourceRect = CGRect(x:view.frame.size.width / 2, y: view.frame.size.height,width: 200,height : 200)
        }
        self.present(alert, animated: true, completion: nil)
    }
    // MARK: open camera method
    func openCamera(){
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerController.SourceType.camera)){
            
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            self .present(imagePicker, animated: true, completion: nil)
            
        }else{
            
            let alertController = UIAlertController(title: commonAlertTitle, message: "Device has no camera", preferredStyle: UIAlertController.Style.alert)
            let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
                (result : UIAlertAction) -> Void in
            }
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    // MARK: open gallary method
    func openGallary()
    {
        imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    //MARK: PickerView Delegate Methods
    public func imagePickerController(_ picker: UIImagePickerController,
                                      didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any])
    {
        guard let selectedImage = info[.originalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        
        if let url = info[UIImagePickerController.InfoKey.imageURL] as? URL {
            
            print(url.lastPathComponent)
            print(url.pathExtension)
            publishObj.attachment = url.lastPathComponent
        }
        publishObj.attacheImg = selectedImage
        userSelectedImage = selectedImage
        //imgProfile.image = selectedImage
        dismiss(animated:true, completion: nil)
        tableView.reloadData()
    }
    
    //MARK: PickerView Delegate Methods
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController){
        print("picker cancel.")
        dismiss(animated: true, completion: nil)
    }
}

extension CreateTendorVC {
    func requestWith(endUrl: String, imageData: Data?, parameters: [String : Any], onCompletion: ((Any?) -> Void)? = nil, onError: ((Error?) -> Void)? = nil){
        let url = "https://www.tendor.org/app-api.php"
        self.addLoaderView()
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            for (key, value) in parameters {
                multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
            }
            if let data = imageData{
                multipartFormData.append(data, withName: "attachment", fileName: "attachment.jpg" , mimeType: "")
            }
        }, usingThreshold: UInt64.init(), to: url, method: .post, headers: nil) { (result) in
            switch result{
            case .success(let upload, _, _):
                upload.uploadProgress(closure: { (Progress) in
                    print("Upload Progress: \(Progress.fractionCompleted * 100)")
                })
                upload.responseJSON { response in
                    upload.responseJSON { response in
                        guard let result = response.result.value else { return }
                        print("\(result)")
                        self.removeLoaderView()
                        let resultDic = result as! Dictionary<String,Any>
                        let status = resultDic["status"] as! Int
                        if status == 200 {
                            self.showAlertWithSingleButton(title: commonAlertTitle, message: "Tendor publish successfull", okButtonText: okText, completion: {
                                self.navigationController?.popViewController(animated: true)
                            })
                        }else{
                            self.showAlertWithSingleButton(title: commonAlertTitle, message: "Tendor publish faild", okButtonText: okText, completion: nil)
                        }
                    }
                    if let err = response.error{
                        onError?(err)
                        return
                    }
                    onCompletion?(nil)
                }
            case .failure(let error):
                print("Error in upload: \(error.localizedDescription)")
                onError?(error)
            }
        }
    }
}
