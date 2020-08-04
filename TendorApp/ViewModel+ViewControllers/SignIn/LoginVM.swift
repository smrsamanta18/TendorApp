//
//  LoginVM.swift
//  Phoenix Errands
//
//  Created by Shyam Future Tech on 28/08/19.
//  Copyright © 2019 Shyam Future Tech. All rights reserved.
//

import Foundation
class LoginVM {
    
    let apiService: SignInServiceProtocol
    var refreshViewClosure: (() -> ())?
    var refreshForgotpasswordViewClosure: (() -> ())?
    var showAlertClosure: (()->())?
    var updateLoadingStatus: (()->())?
    
    var userDetails = UserResponse()
    
    var isLoading: Bool = false {
        didSet {
            self.updateLoadingStatus?()
        }
    }
    
    var alertMessage: String? {
        didSet {
            self.showAlertClosure?()
        }
    }
    
    init( apiService: SignInServiceProtocol = SignInService()) {
        self.apiService = apiService
    }
    
    func sendLoginCredentialsToAPIService(user: UserModel) {
        
        if !AppDelegate.appDelagate().isReachable() {
            self.alertMessage = internetConnectionWarningMessage
            return
        }
        
        if let params = self.validateUserInputs(user: user) {
            self.isLoading = true
            self.apiService.sendLoginDetails(params: params) { [weak self] (response) in
                self?.isLoading = false
                if response.responseStatus == .success {
                    let responseData = response.data as? UserResponse
                    if let _ = responseData?.status, let getUserDetails = responseData {
                        self?.userDetails = getUserDetails
                        self?.refreshViewClosure?()
                    } else {
                        self?.alertMessage = responseData?.message
                    }
                } else {
                    self?.alertMessage = response.message
                }
            }
        }
    }//UserTouch
   
    
    func validateUserInputs(user: UserModel) -> [String: Any]? {
        guard let email = user.userName, !email.isEmpty else {
            self.alertMessage = shouldEnterTheEmailName
            return nil
        }
        guard let password = user.userpassword, !password.isEmpty else {
            self.alertMessage = enterPasswordString
            return nil
        }
        return user.toJSON()
    }
}
