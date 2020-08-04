//
//  NotificationVM.swift
//  TendorApp
//
//  Created by Samir Samanta on 15/03/20.
//  Copyright © 2020 Asif Dafadar. All rights reserved.
//

import Foundation
import Foundation
class NotificationVM {
    
    let apiService: NotificationServicesProtocol
    var refreshViewClosure: (() -> ())?
    var showAlertClosure: (()->())?
    var updateLoadingStatus: (()->())?
    
    var NotificationDetails = NotificationModel()
    
    
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
    
    init( apiService: NotificationServicesProtocol = NotificationServices()) {
        self.apiService = apiService
    }
    
    func getNotificationToAPIService(token: String) {
        
        if !AppDelegate.appDelagate().isReachable() {
            self.alertMessage = internetConnectionWarningMessage
            return
        }
        self.isLoading = true
        self.apiService.getNotificationDetails(token: token) { [weak self] (response) in
            self?.isLoading = false
            if response.responseStatus == .success {
                let responseData = response.data as? NotificationModel
                if  let getUserDetails = responseData {
                    self?.NotificationDetails = getUserDetails
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
