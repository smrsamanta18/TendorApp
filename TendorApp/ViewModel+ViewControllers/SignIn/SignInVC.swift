//
//  SignInVC.swift
//  TendorApp
//
//  Created by Asif Dafadar on 23/08/19.
//  Copyright © 2019 Asif Dafadar. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import Alamofire
import AlamofireObjectMapper
import AuthenticationServices

class SignInVC: UIViewController{
    
    @IBOutlet weak var appleSignInView: UIStackView!
    @IBOutlet weak var userPassword: UITextField!
    
    @IBOutlet weak var userName: UITextField!
    lazy var viewModel: LoginVM = {
        return LoginVM()
    }()
    lazy var viewFBModel: SignUpVM = {
        return SignUpVM()
    }()
    
    var fbdataDict = [String:Any]()
    var userDetails = UserResponse()
    var userObject = UserModel()
    override func viewDidLoad(){
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        
        if #available(iOS 13.0, *) {
            let authorizationButton = ASAuthorizationAppleIDButton()
            authorizationButton.addTarget(self, action: #selector(handleAuthorizationAppleIDButtonPress), for: .touchUpInside)
            self.appleSignInView.addArrangedSubview(authorizationButton)
            
        } else {
            // Fallback on earlier versions
        }
        
        self.initializeViewModel()
    }
    
    @IBAction func btnForgotPasswordTapped(_ sender: Any){
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ForgotPasswordVC") as? ForgotPasswordVC
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    @IBAction func btnSignUpTapped(_ sender: Any){
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "SignUpVC") as? SignUpVC
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    @IBAction func btnFacebookTapped(_ sender: Any){
//        let vc = UIStoryboard.init(name: "Buyer", bundle: Bundle.main).instantiateViewController(withIdentifier: "BuyerDashboardVC") as? BuyerDashboardVC
//        self.navigationController?.pushViewController(vc!, animated: true)
        logInWithFaceBookAction()
    }
    
    @IBAction func btnSignInTapped(_ sender: Any){
        userObject.action = "login"
        userObject.userName = "holmscara@gmail.com" //"holmscara@gmail.com"// self.userName.text // //"ritesh@scriptgiant.com" //"smrsamanta18@gmail.com"//holmscara@gmail.com"//self.userName.text //
        userObject.userpassword = "123456789"// self.userPassword.text //  "JbWzvk7s"//12345678
        
        //userObject.userName = self.userName.text
        //userObject.userpassword = self.userPassword.text
        userObject.device_token = AppPreferenceService.getDeviceToken()
        viewModel.sendLoginCredentialsToAPIService(user: userObject)
    }
    
    @objc func handleAuthorizationAppleIDButtonPress() {
        
        if #available(iOS 13.0, *) {
           let appleIDProvider = ASAuthorizationAppleIDProvider()
            let request = appleIDProvider.createRequest()
            request.requestedScopes = [.fullName, .email]
              
            let authorizationController = ASAuthorizationController(authorizationRequests: [request])
            authorizationController.presentationContextProvider = self
            authorizationController.delegate = self
            authorizationController.performRequests()
        } else {
            // Fallback on earlier versions
        }
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
                    AppPreferenceService.setString(String((self?.viewModel.userDetails.userId!)!), key: PreferencesKeys.userID)
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
    
    
    
    func logInWithFaceBookAction(){
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
}

extension SignInVC {
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
extension SignInVC: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    @available(iOS 13.0, *)
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
    guard let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential else { return }
    
    let id:String = appleIDCredential.user
    let email:String = appleIDCredential.email ?? ""
    let lname:String = appleIDCredential.fullName?.familyName ?? ""
    let fname:String = appleIDCredential.fullName?.givenName ?? ""
    let name:String = fname + lname
    let appleId:String = appleIDCredential.identityToken?.base64EncodedString() ?? ""
    print(appleIDCredential.email)
    let result =  String("ID:\(id),\n Email:\(email),\n  Name:\(name),\n  IdentityToken:\(appleId)")
    print(result)
        
        let fbLoginModel = FacebookLoginModel()
        fbLoginModel.action = "facebook-login"
        fbLoginModel.fname = fname
        fbLoginModel.lname = lname
        fbLoginModel.email = email
        fbLoginModel.device_token = AppPreferenceService.getDeviceToken()
        fbLoginModel.facebookID = id
        self.FBLoginrequestWith(endUrl: "https://www.tendor.org/app-api.php", parameters: fbLoginModel.toJSON())
  }

    @available(iOS 13.0, *)
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
    return self.view.window!
  }
}
