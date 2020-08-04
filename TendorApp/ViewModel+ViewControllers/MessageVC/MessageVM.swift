//
//  MessageVM.swift
//  TendorApp
//
//  Created by Samir Samanta on 23/03/20.
//  Copyright © 2020 Asif Dafadar. All rights reserved.
//

import Foundation
class MessageVM {
    
    let apiService: MessageServiceProtocol
    var refreshViewClosure: (() -> ())?
    var refreshChatViewClosure: (() -> ())?
    var showAlertClosure: (()->())?
    var updateLoadingStatus: (()->())?
    
    var MessageListDetails = MessageListModel()
    var MessageDetails = MessageDetailsModel()
    var chatDetails = ChatModel()
    
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
    
    init( apiService: MessageServiceProtocol = MessageService()) {
        self.apiService = apiService
    }
    
    func getMessageListToAPIService(user: dashboardParam) {
        
        if !AppDelegate.appDelagate().isReachable() {
            self.alertMessage = internetConnectionWarningMessage
            return
        }
        
        if let params = self.validateUserInputs(user: user) {
            self.isLoading = true
            self.apiService.getMessageListDetails(params: params) { [weak self] (response) in
                self?.isLoading = false
                if response.responseStatus == .success {
                    let responseData = response.data as? MessageListModel
                    if  let getUserDetails = responseData {
                        self?.MessageListDetails = getUserDetails
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
    
    func getMessageDetailsToAPIService(user: MessageDetailsParam) {
        
        if !AppDelegate.appDelagate().isReachable() {
            self.alertMessage = internetConnectionWarningMessage
            return
        }
        
        if let params = self.validateUserInputs(user: user) {
            //self.isLoading = true
            self.apiService.getMessageDetails(params: params) { [weak self] (response) in
                //self?.isLoading = false
                if response.responseStatus == .success {
                    let responseData = response.data as? MessageDetailsModel
                    if  let getUserDetails = responseData {
                        self?.MessageDetails = getUserDetails
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
    func validateUserInputs(user: MessageDetailsParam) -> [String: Any]? {
        return user.toJSON()
    }
    
    func postMessageDetailsToAPIService(user: ChatParam) {
        
        if !AppDelegate.appDelagate().isReachable() {
            self.alertMessage = internetConnectionWarningMessage
            return
        }
        
        if let params = self.validateUserInputs(user: user) {
            //self.isLoading = true
            self.apiService.postMessageToPersonal(params: params) { [weak self] (response) in
                //self?.isLoading = false
                if response.responseStatus == .success {
                    let responseData = response.data as? ChatModel
                    if  let getUserDetails = responseData {
                        self?.chatDetails = getUserDetails
                        self?.refreshChatViewClosure?()
                    } else {
                        self?.alertMessage = ""
                    }
                } else {
                    self?.alertMessage = response.message
                }
            }
        }
    }//UserTouch
    func validateUserInputs(user: ChatParam) -> [String: Any]? {
        
        guard let message = user.message, !message.isEmpty else {
            self.alertMessage = shouldEnterTheMessageName
            return nil
        }
        return user.toJSON()
    }
}
