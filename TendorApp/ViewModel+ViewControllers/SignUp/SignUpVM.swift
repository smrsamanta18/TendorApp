//
//  SignUpModel.swift
//  TendorApp
//
//  Created by Samir Samanta on 16/03/20.
//  Copyright © 2020 Asif Dafadar. All rights reserved.
//

import Foundation
class SignUpVM {
    
    let apiService: SignUpServicesProtocol
    var refreshViewClosure: (() -> ())?
    var refreshForgotpasswordViewClosure: (() -> ())?
    var showAlertClosure: (()->())?
    var updateLoadingStatus: (()->())?
    
    var userDetails = UserResponse()
    var forgotDetails = ForgotResponse()
    
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
    
    init( apiService: SignUpServicesProtocol = SignUpServices()) {
        self.apiService = apiService
    }
    func sendRegisterCredentialsToAPIService(user: SignUpModel) {
         
         if !AppDelegate.appDelagate().isReachable() {
             self.alertMessage = internetConnectionWarningMessage
             return
         }
         
         if let params = self.validateUserInputs(user: user) {
             self.isLoading = true
             self.apiService.sendRegisterDetails(params: params) { [weak self] (response) in
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
    
     
     func validateUserInputs(user: SignUpModel) -> [String: Any]? {
        
        guard let fname = user.fname, !fname.isEmpty else {
            self.alertMessage = alertNameMessage
            return nil
        }
        guard let phone = user.phone, !phone.isEmpty else {
            self.alertMessage = alertPhoneMessage
            return nil
        }
        
         guard let email = user.email, !email.isEmpty else {
             self.alertMessage = shouldEnterTheEmailName
             return nil
         }
         return user.toJSON()
     }
    
    func sendForgotCredentialsToAPIService(user: ForgotParam) {
         
         if !AppDelegate.appDelagate().isReachable() {
             self.alertMessage = internetConnectionWarningMessage
             return
         }
         
         if let params = self.validateUserInputs(user: user) {
             self.isLoading = true
             self.apiService.sendForgotPasswordDetails(params: params) { [weak self] (response) in
                 self?.isLoading = false
                print(response)
                 if response.responseStatus == .success {
                     let responseData = response.data as? ForgotResponse
                     if let _ = responseData?.status, let getUserDetails = responseData {
                         self?.forgotDetails = getUserDetails
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
    
     
     func validateUserInputs(user: ForgotParam) -> [String: Any]? {
        guard let email = user.email, !email.isEmpty else {
             self.alertMessage = shouldEnterTheEmailName
             return nil
         }
         return user.toJSON()
     }
}
