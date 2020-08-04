//
//  ProfileVM.swift
//  TendorApp
//
//  Created by Samir Samanta on 15/03/20.
//  Copyright © 2020 Asif Dafadar. All rights reserved.
//

import Foundation
import Foundation
class ProfileVM {
    
    let apiService: ProfileServicesProtocol
    var refreshViewClosure: (() -> ())?
    var refreshUpdateViewClosure: (() -> ())?
    var showAlertClosure: (()->())?
    var updateLoadingStatus: (()->())?
    
    var ProfileDetails = ProfileModel()
    var updateProfile = UpdateProfileModel()
    
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
    
    init( apiService: ProfileServicesProtocol = ProfileServices()) {
        self.apiService = apiService
    }
    
    func getProfileDetailsToAPIService(user: ProfileParam) {
           
           if !AppDelegate.appDelagate().isReachable() {
               self.alertMessage = internetConnectionWarningMessage
               return
           }
           
           if let params = self.validateUserInputs(user: user) {
               self.isLoading = true
               self.apiService.getProfileDetails(params: params) { [weak self] (response) in
                   self?.isLoading = false
                   if response.responseStatus == .success {
                       let responseData = response.data as? ProfileModel
                       if  let getUserDetails = responseData {
                           self?.ProfileDetails = getUserDetails
                           self?.refreshViewClosure?()
                       } else {
                           self?.alertMessage = ""
                       }
                   } else {
                       self?.alertMessage = response.message
                   }
               }
           }
       }
       
       
       func validateUserInputs(user: ProfileParam) -> [String: Any]? {
           
           return user.toJSON()
       }
    
    
    func postUpdateProfileDetailsToAPIService(user: UpdateProfileParam) {
        
        if !AppDelegate.appDelagate().isReachable() {
            self.alertMessage = internetConnectionWarningMessage
            return
        }
        
        if let params = self.validateUserInputs(user: user) {
            self.isLoading = true
            self.apiService.postUpdateProfileDetails(params: params) { [weak self] (response) in
                self?.isLoading = false
                if response.responseStatus == .success {
                    let responseData = response.data as? UpdateProfileModel
                    if  let getUserDetails = responseData {
                        self?.updateProfile = getUserDetails
                        self?.refreshUpdateViewClosure?()
                    } else {
                        self?.alertMessage = ""
                    }
                } else {
                    self?.alertMessage = response.message
                }
            }
        }
    }
    
    
    func validateUserInputs(user: UpdateProfileParam) -> [String: Any]? {
        
        return user.toJSON()
    }
    
    
    func postChangePasswordToAPIService(user: ChangeParam) {
        
        if !AppDelegate.appDelagate().isReachable() {
            self.alertMessage = internetConnectionWarningMessage
            return
        }
        
        if let params = self.validateUserInputs(user: user) {
            self.isLoading = true
            self.apiService.postChangePasswordDetails(params: params) { [weak self] (response) in
                self?.isLoading = false
                if response.responseStatus == .success {
                    let responseData = response.data as? UpdateProfileModel
                    if  let getUserDetails = responseData {
                        self?.updateProfile = getUserDetails
                        self?.refreshUpdateViewClosure?()
                    } else {
                        self?.alertMessage = ""
                    }
                } else {
                    self?.alertMessage = response.message
                }
            }
        }
    }
    
    
    func validateUserInputs(user: ChangeParam) -> [String: Any]? {
        guard let old_password = user.old_password, !old_password.isEmpty else {
            self.alertMessage = "Please enter old password"
            return nil
        }
        guard let new_password = user.new_password, !new_password.isEmpty else {
            self.alertMessage = "Please enter new password"
            return nil
        }
        guard let conf_password = user.conf_password, !conf_password.isEmpty else {
            self.alertMessage = "Please enter confirn password"
            return nil
        }
        guard user.conf_password == user.new_password else {
            self.alertMessage = "Password does not match"
            return nil
        }
        return user.toJSON()
    }
}
