//
//  SignUpVC.swift
//  TendorApp
//
//  Created by Asif Dafadar on 23/08/19.
//  Copyright © 2019 Asif Dafadar. All rights reserved.
//

import UIKit
import Foundation
import Alamofire
import AlamofireObjectMapper
import Photos
import FBSDKCoreKit
import FBSDKLoginKit


class SignUpVC: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var arrImg = NSArray()
    var arrName = [String]()
    var signUpModel = SignUpModel()
    lazy var viewModel: SignUpVM = {
        return SignUpVM()
    }()
    var userDetails = UserResponse()
    var imagePicker = UIImagePickerController()
    var userSelectedImage : UIImage?
    var fbdataDict = [String:Any]()
    
    override func viewDidLoad(){
        super.viewDidLoad()
        
        self.imagePicker.delegate = self
        self.navigationController?.isNavigationBarHidden = true
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UINib(nibName: "ProfileCell", bundle: Bundle.main), forCellReuseIdentifier: "ProfileCell")
        
        arrImg = [UIImage(named: "name-icon")!, UIImage(named: "telephone-icon")!,  UIImage(named: "email")!,  UIImage(named: "password-icon")!,  UIImage(named: "confirm-password")!,  UIImage(named: "upload-logo")!]
        arrName = ["Name","Telephone", "Email", "Password", "Confirm Password","Upload Your Logo"]
        initializeViewModel()
    }
    
    @IBAction func btnRegisterTapped(_ sender: Any) {
        
        signUpModel.action = "register"
        signUpModel.work_title = ""
        signUpModel.company_name = ""
        signUpModel.address = ""
        signUpModel.company_desc = ""
        signUpModel.country_id = "104"
        signUpModel.website = ""
        if let params = self.validateUserInputs(user: signUpModel) {
            if let img = userSelectedImage {
                let data = img.jpegData(compressionQuality: 0)
                self.requestWith(endUrl: "https://www.tendor.org/app-api.php", imageData: data, parameters: params)
            }
        }
    }
    
    func validateUserInputs(user: SignUpModel) -> [String: Any]? {
       
       guard let fname = user.fname, !fname.isEmpty else {
        self.showAlertWithSingleButton(title: commonAlertTitle, message: alertNameMessage, okButtonText: okText, completion: nil)
           return nil
       }
       guard let phone = user.phone, !phone.isEmpty else {
        self.showAlertWithSingleButton(title: commonAlertTitle, message: alertPhoneMessage, okButtonText: okText, completion: nil)
           return nil
       }
        guard let email = user.email, !email.isEmpty else {
            self.showAlertWithSingleButton(title: commonAlertTitle, message: shouldEnterTheEmailName, okButtonText: okText, completion: nil)
            return nil
        }
        return user.toJSON()
    }

    
    @IBAction func btnSignTapped(_ sender: Any){
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "SignInVC") as? SignInVC
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    @IBAction func btnActionFacebook(_ sender: Any) {
        self.showAlertWithSingleButton(title: commonAlertTitle, message: emailIsMandatory, okButtonText: okText) {
            
            let loginManager = LoginManager()//LoginManager()
            //  loginManager.loginBehavior = .browser
            loginManager.logOut()
            
            
            loginManager.logIn(permissions:  ["public_profile", "email"], from: self) { (loginResult, error) in
                
                if (loginResult?.isCancelled ?? false){
                    print("user canceled")
                    return
                }
                if error == nil{
                    self.getFBUserData(manager: loginManager)
                }
                else{
                    DispatchQueue.main.asyncAfter(deadline: .now()+1, execute: {
                        // AppDelegate.rootController?.presentAlertWith(message: "AlertMessage.FBnotLogin.rawValue")
                    })
                }
            }
        }
    }
    
    func getFBUserData(manager:LoginManager){
        GraphRequest(graphPath: "me?fields", parameters: ["fields": "id, name, first_name, last_name, email"]).start(completionHandler: { (connection, result, error) -> Void in
            if (error == nil){
                let fbDetails = result as! NSDictionary
                //                self.fbdataDict = fbDetails as! [String : Any]
                print("fbdataDict==>\(fbDetails)")
                self.parseFB_Data(jsonData: result)
                self.deleteFbPermission(manager: manager)
            }
            else{
                print(error?.localizedDescription ?? "Not found")
            }
        })
    }
    
    func enterEmailInCaseDonotGetFromFacebook(_ FBDetails: [String: Any]) {
        let alertController = UIAlertController(title: commonAlertTitle, message: "", preferredStyle: .alert)
        alertController.addTextField { textField in
            textField.placeholder = "enter email"
        }
        let confirmAction = UIAlertAction(title: "OK", style: .default) { [weak alertController] _ in
            guard let alertController = alertController, let textField = alertController.textFields?.first else { return }
            print("Current password \(String(describing: textField.text))")
            //compare the current password and do action here
            
            let fbLoginModel = FacebookLoginModel()
            fbLoginModel.action = "facebook-login"
            fbLoginModel.fname = (FBDetails["first_name"] as! String)
            fbLoginModel.lname = (FBDetails["last_name"] as! String)
            fbLoginModel.email = (textField.text)
            fbLoginModel.device_token = AppPreferenceService.getDeviceToken()
//            fbLoginModel.facebookID = (FBDetails["id"] as! String)
            fbLoginModel.facebookID = "3191409677589580"
            self.FBLoginrequestWith(endUrl: "https://www.tendor.org/app-api.php", parameters: fbLoginModel.toJSON())
        }
        alertController.addAction(confirmAction)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }

    private func deleteFbPermission(manager:LoginManager){
        manager.logOut()
        let deletepermission = GraphRequest(graphPath: "me/permissions/", parameters: ["public_profile": "email"], httpMethod:.delete)
        
        deletepermission.start(completionHandler: {(connection,result,error)-> Void in
            print("the delete permission is \(String(describing: result))")
        })
    }
    
    func parseFB_Data(jsonData: Any?) {
        guard let data = jsonData as? [String:Any] else {return}
        
        var email=""
        if let eml = data["email"] as? String
        {
            email=eml
        }
        guard let id = data["id"] as? String else{return}
        
        var fname=""
        if let first_name = data["first_name"] as? String
        {
            fname=first_name
        }
        
        var lname=""
        if let last_name = data["last_name"] as? String
        {
            lname=last_name
        }
        
        if email == "" {
            let alertController = UIAlertController(title: commonAlertTitle, message: shouldAllowFacebookEmail, preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: okText, style: .default) { (action) in
                
            }
            alertController.addAction(cancelAction)
            
            let okAction = UIAlertAction(title: enterEmail, style: .default) { (action) in
                self.enterEmailInCaseDonotGetFromFacebook(data)
            }
            alertController.addAction(okAction)
            
            self.present(alertController, animated: true, completion: nil)
            return
        }
        
        let fbLoginModel = FacebookLoginModel()
        fbLoginModel.action = "facebook-login"
        fbLoginModel.fname = fname
        fbLoginModel.lname = lname
        fbLoginModel.email = email
        fbLoginModel.device_token = AppPreferenceService.getDeviceToken()
//        fbLoginModel.facebookID = id
        fbLoginModel.facebookID = "3191409677589580"
        self.FBLoginrequestWith(endUrl: "https://www.tendor.org/app-api.php", parameters: fbLoginModel.toJSON())
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
                
                if  (self?.viewModel.userDetails.status) == 200 {
                    
                    self!.userDetails = (self?.viewModel.userDetails)!
                    AppPreferenceService.setInteger(IS_LOGGED_IN, key: PreferencesKeys.loggedInStatus)
                    //AppPreferenceService.setString(String((self?.viewModel.userDetails.userId!)!), key: PreferencesKeys.userID)
                    AppPreferenceService.setString(String((self?.viewModel.userDetails.email!)!), key: PreferencesKeys.userName)
                    AppPreferenceService.setString(String((self?.viewModel.userDetails.authorizationToke!)!), key: PreferencesKeys.userToken)
                    AppPreferenceService.setString(String((self?.viewModel.userDetails.userName!)!), key: PreferencesKeys.userFirstName)
                    AppPreferenceService.setString(String((self?.viewModel.userDetails.name!)!), key: PreferencesKeys.userLastName)
                    
                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                    appDelegate.openHomeViewController()
                    
                }else{
                    self?.showAlertWithSingleButton(title: commonAlertTitle, message: (self?.viewModel.userDetails.message)!, okButtonText: okText, completion: nil)
                }
            }
        }
    }
    
    func captureImage(){
        selectUserImageAction()
    }
}

extension SignUpVC : UITableViewDelegate, UITableViewDataSource , profileImageCaptureDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrName.count
    }
    //"leftmenu-icon-messages.png"
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let Cell = tableView.dequeueReusableCell(withIdentifier: "ProfileCell") as! ProfileCell
        Cell.lblName.placeholder = arrName[indexPath.row]
        Cell.imgView.image =  arrImg[(indexPath as NSIndexPath).row] as? UIImage
        Cell.lblName.tag = indexPath.row
        Cell.lblName.delegate = self
        Cell.delegate = self
        switch indexPath.row {
        case 0:
            Cell.profileBtnOutlet.isHidden = true
            Cell.lblName.text = signUpModel.fname
            Cell.lblName.keyboardType = .default
            Cell.lblName.isSecureTextEntry = false
            Cell.profileImgView.isHidden = true
            Cell.lblImgName.isHidden = true
            Cell.profileIconImg.isHidden = true
            Cell.backroundView.backgroundColor = UIColor(red: 248/255, green: 248/255, blue: 248/255, alpha: 1.0)
        case 1:
            Cell.profileBtnOutlet.isHidden = true
            Cell.lblName.isSecureTextEntry = false
            Cell.lblName.keyboardType = .phonePad
            Cell.lblName.text = signUpModel.phone
            Cell.profileImgView.isHidden = true
            Cell.lblImgName.isHidden = true
            Cell.profileIconImg.isHidden = true
            Cell.backroundView.backgroundColor = UIColor(red: 248/255, green: 248/255, blue: 248/255, alpha: 1.0)
        case 2:
            Cell.profileBtnOutlet.isHidden = true
            Cell.lblName.isSecureTextEntry = false
            Cell.lblName.keyboardType = .emailAddress
            Cell.lblName.text = signUpModel.email
            Cell.profileImgView.isHidden = true
            Cell.lblImgName.isHidden = true
            Cell.profileIconImg.isHidden = true
            Cell.backroundView.backgroundColor = UIColor(red: 248/255, green: 248/255, blue: 248/255, alpha: 1.0)
        case 3:
            Cell.profileBtnOutlet.isHidden = true
            Cell.lblName.isSecureTextEntry = true
            Cell.lblName.keyboardType = .default
            Cell.lblName.text = signUpModel.password
            Cell.profileImgView.isHidden = true
            Cell.lblImgName.isHidden = true
            Cell.profileIconImg.isHidden = true
            Cell.backroundView.backgroundColor = UIColor(red: 248/255, green: 248/255, blue: 248/255, alpha: 1.0)
        case 4:
            Cell.profileBtnOutlet.isHidden = true
            Cell.lblName.isSecureTextEntry = true
            Cell.lblName.keyboardType = .default
            Cell.lblName.text = signUpModel.conpassword
            Cell.profileImgView.isHidden = true
            Cell.lblImgName.isHidden = true
            Cell.profileIconImg.isHidden = true
            Cell.backroundView.backgroundColor = UIColor(red: 248/255, green: 248/255, blue: 248/255, alpha: 1.0)
        case 5:
            Cell.profileBtnOutlet.isHidden = false
            Cell.lblName.isSecureTextEntry = true
            Cell.lblName.keyboardType = .default
            Cell.profileImgView.isHidden = false
            Cell.backroundView.backgroundColor = UIColor.clear
            if let data = signUpModel.profileImg {
                Cell.lblImgName.isHidden = false
                Cell.profileIconImg.isHidden = true
                Cell.lblImgName.text = signUpModel.imgName
                Cell.profileImgView.image = data
            }else{
                Cell.profileIconImg.isHidden = false
            }
        default:
            return UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "Cell")
        }
        return Cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.row == 5 {
            return 85
        }else{
            return 70
        }
    }
}

extension SignUpVC : UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.tag == 5 {
            print("Image")
        }else{
            
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range:NSRange, replacementString string: String) -> Bool {
        let txtAfterUpdate = textField.text! as NSString
        let updateText = txtAfterUpdate.replacingCharacters(in: range, with: string) as NSString
        print("Updated TextField:: \(updateText)")
        switch textField.tag {
            case 0:
                signUpModel.fname = updateText as String
            case 1:
                signUpModel.phone = updateText as String
            case 2:
                signUpModel.email = updateText as String
            case 3:
                signUpModel.password = updateText as String
            case 4:
                signUpModel.conpassword = updateText as String
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

extension SignUpVC : UINavigationControllerDelegate,UIImagePickerControllerDelegate {
    
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
            self.present(imagePicker, animated: true, completion: nil)
            
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
            signUpModel.imgName = ""//url.lastPathComponent
        }
        
        arrName[5] = ""
        userSelectedImage = selectedImage
        //imgProfile.image = selectedImage
        signUpModel.profileImg = selectedImage
        tableView.reloadData()
        dismiss(animated:true, completion: nil)
    }
    
    //MARK: PickerView Delegate Methods
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController){
        print("picker cancel.")
        dismiss(animated: true, completion: nil)
    }
}

extension SignUpVC {
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
    
    func FBLoginrequestWith(endUrl: String, parameters: [String : Any], onCompletion: ((Any?) -> Void)? = nil, onError: ((Error?) -> Void)? = nil){
        let url = "https://www.tendor.org/app-api.php"
        self.addLoaderView()
        print(parameters)
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            for (key, value) in parameters {
                multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
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
                        let responseData = UserResponse(JSON: resultDic)
                        if let _ = responseData?.status, let getUserDetails = responseData {
                            AppPreferenceService.setInteger(IS_LOGGED_IN, key: PreferencesKeys.loggedInStatus)
                            
                            if let userID = getUserDetails.userId {
                                AppPreferenceService.setString(userID, key: PreferencesKeys.userID)
                            }
                            if let email = getUserDetails.email {
                                AppPreferenceService.setString(email, key: PreferencesKeys.userName)
                            }
                            if let token = getUserDetails.authorizationToke {
                                AppPreferenceService.setString(token, key: PreferencesKeys.userToken)
                            }
                            if let username = getUserDetails.userName {
                                AppPreferenceService.setString(username, key: PreferencesKeys.userFirstName)
                            }
                            if let name = getUserDetails.name {
                                AppPreferenceService.setString(name, key: PreferencesKeys.userLastName)
                            }
                            
                            let appDelegate = UIApplication.shared.delegate as! AppDelegate
                            appDelegate.openHomeViewController()
                            
                        } else {
                            self.showAlertWithSingleButton(title: commonAlertTitle, message: (responseData?.message)!, okButtonText: okText, completion: nil)
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
