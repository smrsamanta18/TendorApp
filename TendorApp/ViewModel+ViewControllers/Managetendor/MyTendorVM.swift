//
//  MyTendorVM.swift
//  TendorApp
//
//  Created by Samir Samanta on 16/03/20.
//  Copyright © 2020 Asif Dafadar. All rights reserved.
//

import Foundation
class MyTendorVM {
    
    let apiService: MyTendorServiceProtocol
    var refreshViewClosure: (() -> ())?
    var showAlertClosure: (()->())?
    var updateLoadingStatus: (()->())?
    
    var MyTendorDetails = MyTendorModel()
    
    
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
    
    init( apiService: MyTendorServiceProtocol = MyTendorService()) {
        self.apiService = apiService
    }
    
    func getMyTendorToAPIService(user: MyTendorParam) {
        
        if !AppDelegate.appDelagate().isReachable() {
            self.alertMessage = internetConnectionWarningMessage
            return
        }
        
        if let params = self.validateUserInputs(user: user) {
            self.isLoading = true
            self.apiService.getMyTendorDetailsDetails(params: params) { [weak self] (response) in
                self?.isLoading = false
                if response.responseStatus == .success {
                    let responseData = response.data as? MyTendorModel
                    if  let getUserDetails = responseData {
                        self?.MyTendorDetails = getUserDetails
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
    
    
    func validateUserInputs(user: MyTendorParam) -> [String: Any]? {
        
        return user.toJSON()
    }
}
