//
//  HomeVM.swift
//  TendorApp
//
//  Created by Samir Samanta on 25/10/19.
//  Copyright © 2019 Asif Dafadar. All rights reserved.
//

import Foundation
class HomeVM {
    
    let apiService: TopCategoryServiceProtocol
    var refreshViewClosure: (() -> ())?
    var showAlertClosure: (()->())?
    var updateLoadingStatus: (()->())?
    
    var CategoryDetails = CategoryModel()
    var LatestTendor = LatestTendorModel()
    var SearchResult = SearchResultModel()
    
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
    
    init( apiService: TopCategoryServiceProtocol = TopCategoryService()) {
        self.apiService = apiService
    }
    
    func getCategoryDetailsToAPIService(user: dashboardParam) {
        
        if !AppDelegate.appDelagate().isReachable() {
            self.alertMessage = internetConnectionWarningMessage
            return
        }
        
        if let params = self.validateUserInputs(user: user) {
            self.isLoading = true
            self.apiService.getTopCategoryDetails(params: params) { [weak self] (response) in
                self?.isLoading = false
                if response.responseStatus == .success {
                    let responseData = response.data as? CategoryModel
                    if  let getUserDetails = responseData {
                        self?.CategoryDetails = getUserDetails
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
    
    
    func validateUserInputs(user: dashboardParam) -> [String: Any]? {
        
        return user.toJSON()
    }
    
    func getLatestDetailsToAPIService() {
        
        if !AppDelegate.appDelagate().isReachable() {
            self.alertMessage = internetConnectionWarningMessage
            return
        }
        self.isLoading = true
        self.apiService.getLatestTendorDetails() { [weak self] (response) in
            self?.isLoading = false
            if response.responseStatus == .success {
                let responseData = response.data as? LatestTendorModel
                if  let getUserDetails = responseData {
                    self?.LatestTendor = getUserDetails
                    self?.refreshViewClosure?()
                } else {
                    self?.alertMessage = ""
                }
            } else {
                self?.alertMessage = response.message
            }
        }
    }
    
    func getSearchResultDetailsToAPIService(user: SearchParam) {
        
        if !AppDelegate.appDelagate().isReachable() {
            self.alertMessage = internetConnectionWarningMessage
            return
        }
        
        if let params = self.validateUserInputs(user: user) {
            self.isLoading = true
            self.apiService.getSearchResultDetails(params: params) { [weak self] (response) in
                self?.isLoading = false
                if response.responseStatus == .success {
                    let responseData = response.data as? SearchResultModel
                    if  let getUserDetails = responseData {
                        self?.SearchResult = getUserDetails
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
    func validateUserInputs(user: SearchParam) -> [String: Any]? {
        
        return user.toJSON()
    }
}
