//
//  TendorAdditionalInfoVC.swift
//  TendorApp
//
//  Created by Asif Dafadar on 30/08/19.
//  Copyright © 2019 Asif Dafadar. All rights reserved.
//

import UIKit
import UIKit
import Foundation
import Alamofire
import AlamofireObjectMapper

class TendorAdditionalInfoVC: BaseViewController, headerMenuActionDelegate{
    @IBOutlet weak var chooseFileBtnOutlet: UIButton!
    @IBOutlet weak var docImgView: UIImageView!
    @IBOutlet weak var lblDocNAme: UILabel!
    @IBOutlet weak var btnCancelOutlet: UIButton!
    @IBOutlet weak var closingDateBtn: UIButton!
    @IBOutlet weak var descriptionTxtView: UITextView!
    var tid : String?
    lazy var viewModel: OfferListVM = {
        return OfferListVM()
    }()
    var imagePicker = UIImagePickerController()
    var userSelectedImage : UIImage?
    override func viewDidLoad(){
        super.viewDidLoad()
        
        docImgView.layer.masksToBounds = false
        docImgView.layer.cornerRadius = 5
        docImgView.clipsToBounds = true
        
        self.imagePicker.delegate = self
        headerSetup()
        initializeViewModel()
    }
    func headerSetup(){
        if #available(iOS 13.0, *) {
            let statusBar = UIView(frame: UIApplication.shared.keyWindow?.windowScene?.statusBarManager?.statusBarFrame ?? CGRect.zero)
             statusBar.backgroundColor = UIColor.clear
             UIApplication.shared.keyWindow?.addSubview(statusBar)
        } else {
             UIApplication.shared.statusBarView?.backgroundColor = UIColor.clear
        }
        headerView.lblHeaderTitle.text = "Add Additional Info"
        headerView.imgProfileIcon.isHidden = false
        headerView.menuButtonOutlet.isHidden = false
        headerView.imgViewMenu.isHidden = false
        headerView.menuButtonOutlet.tag = 1
        headerView.imgViewMenu.image = UIImage(named:"BackBtn")
        headerView.homeDelegate = self
        
        descriptionTxtView.delegate = self
        descriptionTxtView.text = "Additional Description"
        btnCancelOutlet.backgroundColor = .black
        btnCancelOutlet.layer.cornerRadius = 15
        btnCancelOutlet.layer.borderWidth = 0
        
        closingDateBtn.backgroundColor = .black
        closingDateBtn.layer.cornerRadius = 15
        closingDateBtn.layer.borderWidth = 0
    }
    
    func postAdditonalInfoDetails(){
        let obj = AdditionalInfoParam()
        obj.action = "edit-tendor-additional-info"
        obj.authorizationToken = AppPreferenceService.getString(PreferencesKeys.userToken)
        obj.tid = tid
        obj.tender_description = descriptionTxtView.text
       // viewModel.postAdditionalInfoToAPIService(user: obj)
        if let params = self.validateUserInputs(user: obj) {
            if let img = userSelectedImage {
                let data = img.jpegData(compressionQuality: 0)
                self.requestWith(endUrl: "https://www.tendor.org/app-api.php", imageData: data, parameters: params)
            }
        }
    }
    
    func validateUserInputs(user: AdditionalInfoParam) -> [String: Any]? {
        return user.toJSON()
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
                if self?.viewModel.additionalInfoModel.status != nil {
                    self?.showAlertWithSingleButton(title: commonAlertTitle, message: (self?.viewModel.additionalInfoModel.message)!, okButtonText: okText, completion: {
                        self?.navigationController?.popViewController(animated: true)
                    })
                }
            }
        }
    }
    
    @IBAction func choseFileButtonAction(_ sender: Any) {
        selectUserImageAction()
    }
    
    func homeMneu() {
        let vc = UIStoryboard.init(name: "Buyer", bundle: Bundle.main).instantiateViewController(withIdentifier: "BuyerMenuVC") as? BuyerMenuVC
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    @IBAction func cancelBtnAction(_ sender: Any) {
        
    }
    
    @IBAction func updateBtnAction(_ sender: Any) {
        if descriptionTxtView.text == "Additional Description" {
            self.showAlertWithSingleButton(title: commonAlertTitle, message: "Please enter description", okButtonText: okText, completion: nil)
        }else{
            postAdditonalInfoDetails()
        }
    }
}

extension TendorAdditionalInfoVC : UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if descriptionTxtView.text == "Additional Description" {
            descriptionTxtView.text = ""
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
    }
}
extension TendorAdditionalInfoVC : UINavigationControllerDelegate,UIImagePickerControllerDelegate {
    
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
            lblDocNAme.text = url.lastPathComponent
        }
        chooseFileBtnOutlet.setTitle("", for: .normal)
        userSelectedImage = selectedImage
        docImgView.image = selectedImage
        dismiss(animated:true, completion: nil)
    }
    
    //MARK: PickerView Delegate Methods
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController){
        print("picker cancel.")
        dismiss(animated: true, completion: nil)
    }
}

extension TendorAdditionalInfoVC {
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
                            self.showAlertWithSingleButton(title: commonAlertTitle, message: "You are successfully registered with us. Please check your mail to activate your account.", okButtonText: okText, completion: {
                                self.navigationController?.popViewController(animated: true)
                            })
                        }else{
                            self.showAlertWithSingleButton(title: commonAlertTitle, message: "Register faild", okButtonText: okText, completion: nil)
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
