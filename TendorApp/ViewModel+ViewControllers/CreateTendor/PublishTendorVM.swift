//
//  PublishTendorVM.swift
//  TendorApp
//
//  Created by Samir Samanta on 23/03/20.
//  Copyright © 2020 Asif Dafadar. All rights reserved.
//

import Foundation
class PublishTendorVM {
    
    let apiService: PublishTendorServicesProtocol
    var refreshViewClosure: (() -> ())?
    var refreshCountryViewClosure: (() -> ())?
    var showAlertClosure: (()->())?
    var updateLoadingStatus: (()->())?
    
    var PublishTendor = PublishTendorModel()
    var countryModel = CountryListModel()
    
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
    
    init( apiService: PublishTendorServicesProtocol = PublishTendorServices()) {
        self.apiService = apiService
    }
    
    func postTendorPublishDetailsToAPIService(user: PublishTendorParam) {
        
        if !AppDelegate.appDelagate().isReachable() {
            self.alertMessage = internetConnectionWarningMessage
            return
        }
        
        if let params = self.validateUserInputs(user: user) {
            self.isLoading = true
            self.apiService.postPublishTendorDetails(params: params) { [weak self] (response) in
                self?.isLoading = false
                if response.responseStatus == .success {
                    let responseData = response.data as? PublishTendorModel
                    if  let getUserDetails = responseData {
                        self?.PublishTendor = getUserDetails
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
    
    
    func validateUserInputs(user: PublishTendorParam) -> [String: Any]? {
        guard let title = user.title, !title.isEmpty else {
            self.alertMessage = "Please enter title"
            return nil
        }
        guard let cat_id = user.cat_id, !cat_id.isEmpty else {
            self.alertMessage = "Please select type"
            return nil
        }
        guard let tender_description = user.tender_description, !tender_description.isEmpty else {
            self.alertMessage = "Please tendor description"
            return nil
        }
        guard let exp_date = user.exp_date, !exp_date.isEmpty else {
            self.alertMessage = "Please select closing date"
            return nil
        }
        return user.toJSON()
    }
    
    func getCountryListDetailsToAPIService(user: MyTendorParam) {
        
        if !AppDelegate.appDelagate().isReachable() {
            self.alertMessage = internetConnectionWarningMessage
            return
        }
        
        if let params = self.validateUserInputs(user: user) {
            self.isLoading = true
            self.apiService.getCountryListDetails(params: params) { [weak self] (response) in
                self?.isLoading = false
                if response.responseStatus == .success {
                    let responseData = response.data as? CountryListModel
                    if  let getUserDetails = responseData {
                        self?.countryModel = getUserDetails
                        self?.refreshCountryViewClosure?()
                    } else {
                        self?.alertMessage = ""
                    }
                } else {
                    self?.alertMessage = response.message
                }
            }
        }
    }//UserTouchMyTendorParam
    
    func validateUserInputs(user: MyTendorParam) -> [String: Any]? {
        return user.toJSON()
    }
}
