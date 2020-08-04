//
//  ForgotPasswordVC.swift
//  TendorApp
//
//  Created by Asif Dafadar on 23/08/19.
//  Copyright © 2019 Asif Dafadar. All rights reserved.
//

import UIKit

class ForgotPasswordVC: UIViewController
{
    @IBOutlet weak var txtForgotPassword: UITextField!
    lazy var viewModel: SignUpVM = {
        return SignUpVM()
    }()
    override func viewDidLoad(){
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        initializeViewModel()
    }
    
    @IBAction func btnSignInTapped(_ sender: Any){
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnForgotPassword(_ sender: Any) {
        let param = ForgotParam()
        param.action = "forgot-password"
        param.email = txtForgotPassword.text
        viewModel.sendForgotCredentialsToAPIService(user: param)
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
        /*
        viewModel.refreshViewClosure = {[weak self]() in
            DispatchQueue.main.async {
                
                if  (self?.viewModel.forgotDetails.status) == 200 {
                    if self?.viewModel.forgotDetails.message != nil {
                        self?.showAlertWithSingleButton(title: commonAlertTitle, message: (self?.viewModel.forgotDetails.message)!, okButtonText: okText, completion: {
                        
                            self!.navigationController?.popViewController(animated: true)
                        })
                    }
                    
                }else{
                    self?.showAlertWithSingleButton(title: commonAlertTitle, message: (self?.viewModel.forgotDetails.message)!, okButtonText: okText, completion: nil)
                }
            }
        }
        */
    }
}
