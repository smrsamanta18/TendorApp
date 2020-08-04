//
//  DashboardVM.swift
//  TendorApp
//
//  Created by Samir Samanta on 25/10/19.
//  Copyright © 2019 Asif Dafadar. All rights reserved.
//

import Foundation
import Foundation
class DashboardVM {
    
    let apiService: DashboardServicesProtocol
    var refreshViewClosure: (() -> ())?
    var showAlertClosure: (()->())?
    var updateLoadingStatus: (()->())?
    
    var dashboardDetails = DashboardModel()
    var tendorDetails = TendorDetailsModel()
    
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
    
    init( apiService: DashboardServicesProtocol = DashboardServices()) {
        self.apiService = apiService
    }
    
    func getDashboardDetailsToAPIService(user: dashboardParam) {
        
        if !AppDelegate.appDelagate().isReachable() {
            self.alertMessage = internetConnectionWarningMessage
            return
        }
        if let params = self.validateUserInputs(user: user) {
            self.isLoading = true
            self.apiService.getDashboardDetails(params: params) { [weak self] (response) in
                self?.isLoading = false
                if response.responseStatus == .success {
                    let responseData = response.data as? DashboardModel
                    if  let getUserDetails = responseData {
                        self?.dashboardDetails = getUserDetails
                        self?.refreshViewClosure?()
                    } else {
                        self?.alertMessage = ""
                    }
                } else {
                    self?.alertMessage = response.message
                }
            }
        }
    }//UserTouch
    
    
    func validateUserInputs(user: dashboardParam) -> [String: Any]? {
        return user.toJSON()
    }
    
    func getTendorDetailsToAPIService(user: TendorDetailsParam) {
        
        if !AppDelegate.appDelagate().isReachable() {
            self.alertMessage = internetConnectionWarningMessage
            return
        }
        
        if let params = self.validateUserInputs(user: user) {
            self.isLoading = true
            self.apiService.getTendorDetails(params: params) { [weak self] (response) in
                self?.isLoading = false
                if response.responseStatus == .success {
                    let responseData = response.data as? TendorDetailsModel
                    if  let getUserDetails = responseData {
                        self?.tendorDetails = getUserDetails
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
    
    func validateUserInputs(user: TendorDetailsParam) -> [String: Any]? {
        return user.toJSON()
    }
}
