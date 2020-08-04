//
//  EditViewProfileVC.swift
//  TendorApp
//
//  Created by Samir Samanta on 29/01/20.
//  Copyright © 2020 Asif Dafadar. All rights reserved.
//

import UIKit
import Foundation
import Alamofire
import AlamofireObjectMapper

class EditViewProfileVC: BaseViewController,headerMenuActionDelegate {

    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    var arrImg = NSArray()
    var arrName = [String]()
    lazy var viewModel: ProfileVM = {
        return ProfileVM()
    }()
    var ProfileDetails = ProfileModel()
    lazy var catViewModel: HomeVM = {
        return HomeVM()
    }()
    lazy var viewCountryModel: PublishTendorVM = {
        return PublishTendorVM()
    }()
    var countryList : [CountryListArray]?
    
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var pickerMainView: UIView!
    
    var imagePicker = UIImagePickerController()
    var userSelectedImage : UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        profileImg.layer.masksToBounds = false
        profileImg.layer.cornerRadius = profileImg.frame.height/2
        profileImg.clipsToBounds = true
        
        headerView.homeDelegate = self
        if #available(iOS 13.0, *) {
            let statusBar = UIView(frame: UIApplication.shared.keyWindow?.windowScene?.statusBarManager?.statusBarFrame ?? CGRect.zero)
             statusBar.backgroundColor = UIColor.clear
             UIApplication.shared.keyWindow?.addSubview(statusBar)
        } else {
             UIApplication.shared.statusBarView?.backgroundColor = UIColor.clear
        }
        self.imagePicker.delegate = self
        headerView.lblHeaderTitle.text = "Edit Profile"
        headerView.imgProfileIcon.isHidden = true
        headerView.menuButtonOutlet.isHidden = false
        headerView.imgViewMenu.isHidden = false
        headerView.menuButtonOutlet.tag = 1
        headerView.imgViewMenu.image = UIImage(named:"BackBtn")
        tabBarView.moreImg.image = UIImage(named: "MoreSelect")
        
        initializeCountryViewModel()
        arrName = ["Name","Email", "Country", "Phone", "Address","Telephone","Company","Company Description"]
        initializeViewModel()
        getDashboardDetails()
        pickerMainView.isHidden = true

        // Do any additional setup after loading the view.
    }
    
    func getDashboardDetails(){
        let obj = ProfileParam()
        obj.action = "view-profile"
        obj.authorizationToken = AppPreferenceService.getString(PreferencesKeys.userToken)
        viewModel.getProfileDetailsToAPIService(user: obj)
    }
    
    func homeMneu(){
        let vc = UIStoryboard.init(name: "Buyer", bundle: Bundle.main).instantiateViewController(withIdentifier: "BuyerMenuVC") as? BuyerMenuVC
        self.navigationController?.pushViewController(vc!, animated: true)
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
                
                self!.ProfileDetails = (self?.viewModel.ProfileDetails)!
                if let url = self!.ProfileDetails.logo {
                    let fullUrl = "https://www.tendor.org/" + url
                    self!.profileImg.sd_setImage(with: URL(string: fullUrl))
                    AppPreferenceService.setString(fullUrl, key :"logo")
                    self!.userSelectedImage = self!.profileImg.image
                }
                self!.tableView.reloadData()
                //self!.categoryCollectionview.reloadData()
            }
        }
        viewModel.refreshUpdateViewClosure = {[weak self]() in
            DispatchQueue.main.async {
                
                if self?.viewModel.updateProfile.status != nil {
                   if self?.viewModel.updateProfile.status != "error" {
                        self?.showAlertWithSingleButton(title: commonAlertTitle, message: (self?.viewModel.updateProfile.message)!, okButtonText: okText, completion: {
                            self!.getDashboardDetails()
                        })
                    
                    }else{
                        self?.showAlertWithSingleButton(title: commonAlertTitle, message: "Something went to wrong, please try again.", okButtonText: okText, completion: nil)
                    }
                }
            }
        }
    }
    
    func initializeCountryViewModel() {
        
        viewCountryModel.showAlertClosure = {[weak self]() in
            DispatchQueue.main.async {
                if let message = self?.viewCountryModel.alertMessage {
                    self?.showAlertWithSingleButton(title: commonAlertTitle, message: message, okButtonText: okText, completion: nil)
                }
            }
        }
        
        viewCountryModel.updateLoadingStatus = {[weak self]() in
            DispatchQueue.main.async {
                
                let isLoading = self?.viewCountryModel.isLoading ?? false
                if isLoading {
                    self?.addLoaderView()
                } else {
                    self?.removeLoaderView()
                }
            }
        }
    
        viewCountryModel.refreshCountryViewClosure = {[weak self]() in
            DispatchQueue.main.async {
                if self!.viewCountryModel.countryModel.countryList != nil {
                    self!.pickerMainView.isHidden = false
                    self!.countryList = self!.viewCountryModel.countryModel.countryList
                    self!.pickerView.delegate = self
                    self!.pickerView.dataSource = self
                    self!.pickerView.reloadAllComponents()
                }
            }
        }
    }
    
    func getCountryDetails(){
        let obj = MyTendorParam()
        obj.action = "country-list"
        viewCountryModel.getCountryListDetailsToAPIService(user: obj)
    }
    
    func selectCountryList(){
        getCountryDetails()
    }
    
    @IBAction func pickerDoneBtnAction(_ sender: Any) {
        pickerMainView.isHidden = true
    }
    
    @IBAction func pickerCancelBtnAction(_ sender: Any) {
        pickerMainView.isHidden = true
    }
    
    @IBAction func btnSubmitAction(_ sender: Any) {
        
        let obj = UpdateProfileParam()
        obj.action = "update-profile"
        obj.authorizationToken = AppPreferenceService.getString(PreferencesKeys.userToken)
        obj.fname = ProfileDetails.fname
        obj.country_id = ProfileDetails.country_id
        obj.phone = ProfileDetails.phone
        obj.address = ProfileDetails.address
        obj.company_name = ProfileDetails.company_name
//        viewModel.postUpdateProfileDetailsToAPIService(user: obj)
        
        if let params = self.validateUserInputs(user: obj) {
            if let img = userSelectedImage {
                let data = img.jpegData(compressionQuality: 0)
                self.requestWith(endUrl: "https://www.tendor.org/app-api.php", imageData: data, parameters: params)
            }
        }
    }
    func validateUserInputs(user: UpdateProfileParam) -> [String: Any]? {
        return user.toJSON()
    }
    
    
    @IBAction func btnProfileImageCapttureAction(_ sender: Any) {
        selectUserImageAction()
    }
}

extension EditViewProfileVC : UITableViewDelegate, UITableViewDataSource , selectCountryListForEdit {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrName.count
    }
    //"leftmenu-icon-messages.png"
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let Cell = tableView.dequeueReusableCell(withIdentifier: "EditViewCell") as! EditViewCell
        Cell.txtFieldValue.tag = indexPath.row
        Cell.txtFieldValue.delegate = self
        Cell.delegate = self
        Cell.lblFieldName.text = arrName[indexPath.row]
        if indexPath.row == 2 {
            Cell.imgView.isHidden = false
        }else{
            Cell.imgView.isHidden = true
        }
        switch indexPath.row {
        case 0:
            if let fname = ProfileDetails.fname {
                Cell.txtFieldValue.text = fname + " " + ProfileDetails.fname!
            }
            Cell.editTxtBtnView.isHidden = true
            Cell.txtFieldValue.keyboardType = .default
        case 1:
            if let email = ProfileDetails.email {
                Cell.txtFieldValue.text = email
            }
            Cell.editTxtBtnView.isHidden = true
            Cell.txtFieldValue.keyboardType = .emailAddress
        case 2:
            if let country_id = ProfileDetails.country_id {
                Cell.txtFieldValue.text = country_id
            }
            Cell.editTxtBtnView.isHidden = false
            Cell.txtFieldValue.keyboardType = .default
        case 3:
            if let phone = ProfileDetails.phone {
                Cell.txtFieldValue.text = phone
            }
            Cell.editTxtBtnView.isHidden = true
            Cell.txtFieldValue.keyboardType = .phonePad
        case 4:
            if let address = ProfileDetails.address {
                Cell.txtFieldValue.text = address
            }
            Cell.editTxtBtnView.isHidden = true
            Cell.txtFieldValue.keyboardType = .default
        case 5:
            if let company_name = ProfileDetails.phone {
                Cell.txtFieldValue.text = company_name
            }
            Cell.txtFieldValue.keyboardType = .default
            Cell.editTxtBtnView.isHidden = true
        case 6:
            if let company_desc = ProfileDetails.company_name {
                Cell.txtFieldValue.text = company_desc
            }
            Cell.editTxtBtnView.isHidden = true
            Cell.txtFieldValue.keyboardType = .default
        case 7:
            if let company_desc = ProfileDetails.company_desc {
                Cell.txtFieldValue.text = company_desc
//                Cell.editTxtBtnView.isHidden = true
            }
            Cell.editTxtBtnView.isHidden = true
            Cell.txtFieldValue.keyboardType = .default
        default:
            return UITableViewCell(style: .value1, reuseIdentifier: "Cell")
        }
        return Cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 48
    }
}

extension EditViewProfileVC : UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return countryList!.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return  countryList![row].name
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        ProfileDetails.country_id = countryList![row].name
        tableView.reloadData()
    }
}
extension EditViewProfileVC : UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range:NSRange, replacementString string: String) -> Bool {
        let txtAfterUpdate = textField.text! as NSString
        let updateText = txtAfterUpdate.replacingCharacters(in: range, with: string) as NSString
        print("Updated TextField:: \(updateText)")
        
        
        switch textField.tag {
        case 0:
            ProfileDetails.fname = updateText as String
        case 1:
            ProfileDetails.email = updateText as String
        case 3:
            ProfileDetails.phone = updateText as String
        case 4:
            ProfileDetails.address = updateText as String
        case 5:
            ProfileDetails.phone = updateText as String
        case 6:
            ProfileDetails.company_name = updateText as String
        case 7:
            ProfileDetails.company_desc = updateText as String
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

extension EditViewProfileVC : UINavigationControllerDelegate,UIImagePickerControllerDelegate {
    
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
//            publishObj.attachment = url.lastPathComponent
        }
        
        userSelectedImage = selectedImage
        profileImg.image = selectedImage
        dismiss(animated:true, completion: nil)
    }
    
    //MARK: PickerView Delegate Methods
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController){
        print("picker cancel.")
        dismiss(animated: true, completion: nil)
    }
}

extension EditViewProfileVC {
    func requestWith(endUrl: String, imageData: Data?, parameters: [String : Any], onCompletion: ((Any?) -> Void)? = nil, onError: ((Error?) -> Void)? = nil){
        let url = "https://www.tendor.org/app-api.php"
        self.addLoaderView()
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            for (key, value) in parameters {
                multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
            }
            if let data = imageData{
                multipartFormData.append(data, withName: "logo", fileName: "logo.jpg" , mimeType: "")
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
                        let status = resultDic["status"] as! String
                        if status != nil {
                            self.showAlertWithSingleButton(title: commonAlertTitle, message: "Profile update successfull", okButtonText: okText, completion: {
                                self.navigationController?.popViewController(animated: true)
                            })
                        }else{
                            self.showAlertWithSingleButton(title: commonAlertTitle, message: "Profile update faild", okButtonText: okText, completion: nil)
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
