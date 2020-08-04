//
//  OfferListVM.swift
//  TendorApp
//
//  Created by Samir Samanta on 26/03/20.
//  Copyright © 2020 Asif Dafadar. All rights reserved.
//

import Foundation
import Foundation
class OfferListVM {
    
    let apiService: OfferListService
    var refreshViewClosure: (() -> ())?
    var refreshSelectOfferViewClosure: (() -> ())?
    var showAlertClosure: (()->())?
    var updateLoadingStatus: (()->())?
    
    var offerListModel = OfferListModel()
    var offerDetailsModel = ViewOfferDetailsModel()
    var additionalInfoModel = AdditonalInfoModel()
    
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
    
    init( apiService: OfferListService = OfferListService()) {
        self.apiService = apiService
    }
    
    func getOfferListDetailsToAPIService(user: OfferParam) {
        
        if !AppDelegate.appDelagate().isReachable() {
            self.alertMessage = internetConnectionWarningMessage
            return
        }
        
        if let params = self.validateUserInputs(user: user) {
            self.isLoading = true
            self.apiService.getOfferListDetails(params: params) { [weak self] (response) in
                self?.isLoading = false
                if response.responseStatus == .success {
                    let responseData = response.data as? OfferListModel
                    if  let getUserDetails = responseData {
                        self?.offerListModel = getUserDetails
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
    
    func getOfferDetailsToAPIService(user: OfferParam) {
        
        if !AppDelegate.appDelagate().isReachable() {
            self.alertMessage = internetConnectionWarningMessage
            return
        }
        
        if let params = self.validateUserInputs(user: user) {
            self.isLoading = true
            self.apiService.getOfferDetailsDetails(params: params) { [weak self] (response) in
                self?.isLoading = false
                if response.responseStatus == .success {
                    let responseData = response.data as? ViewOfferDetailsModel
                    if  let getUserDetails = responseData {
                        self?.offerDetailsModel = getUserDetails
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
    
    
    
    func validateUserInputs(user: OfferParam) -> [String: Any]? {
        return user.toJSON()
    }
    
    
    func postAdditionalInfoToAPIService(user: AdditionalInfoParam) {
        if !AppDelegate.appDelagate().isReachable() {
            self.alertMessage = internetConnectionWarningMessage
            return
        }
        if let params = self.validateUserInputs(user: user) {
            self.isLoading = true
            self.apiService.postAdditionalInfoDetailsDetails(params: params) { [weak self] (response) in
                self?.isLoading = false
                if response.responseStatus == .success {
                    let responseData = response.data as? AdditonalInfoModel
                    if  let getUserDetails = responseData {
                        self?.additionalInfoModel = getUserDetails
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
    func validateUserInputs(user: AdditionalInfoParam) -> [String: Any]? {
        return user.toJSON()
    }
    
    
    func postSelectOfferToAPIService(user: SelectOfferParam) {
        if !AppDelegate.appDelagate().isReachable() {
            self.alertMessage = internetConnectionWarningMessage
            return
        }
        if let params = self.validateUserInputs(user: user) {
            self.isLoading = true
            self.apiService.postSelectOfferDetailsDetails(params: params) { [weak self] (response) in
                self?.isLoading = false
                if response.responseStatus == .success {
                    let responseData = response.data as? AdditonalInfoModel
                    if  let getUserDetails = responseData {
                        self?.additionalInfoModel = getUserDetails
                        self?.refreshSelectOfferViewClosure?()
                    } else {
                        self?.alertMessage = ""
                    }
                } else {
                    self?.alertMessage = response.message
                }
            }
        }
    }
    func validateUserInputs(user: SelectOfferParam) -> [String: Any]? {
        return user.toJSON()
    }
    
    
}
