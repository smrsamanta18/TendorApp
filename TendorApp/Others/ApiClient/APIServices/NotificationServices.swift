//
//  NotificationServices.swift
//  TendorApp
//
//  Created by Samir Samanta on 15/03/20.
//  Copyright © 2020 Asif Dafadar. All rights reserved.
//

import Foundation
import Foundation
import Alamofire
import AlamofireObjectMapper

protocol NotificationServicesProtocol {
    func getNotificationDetails(token : String, completion: RequestCompletionHandler?)
}

class NotificationServices: NotificationServicesProtocol {
    
    func getNotificationDetails(token: String, completion: RequestCompletionHandler?) {
        let loginApi = "https://www.tendor.org/app-api.php"
        let param = ["action" : "notification","authorizationToken" : token]
        Alamofire.request(loginApi, method: .post, parameters: param, headers: nil).responseObject {(response: DataResponse<NotificationModel>) in
            print("loginApi==>\(loginApi)")
            let loginApiResponse : Response!
            
            var responseStausCode: Int = 1
            var failureMessage: String = ""
            
            if let message = response.error?.localizedDescription {
                failureMessage = message
            }
            if let statusCode = response.response?.statusCode {
                responseStausCode = statusCode
            }
            if let JSON = response.result.value {
                print("JSON: \(JSON)")
            }
            switch(response.result) {
            case .success(let data):
                loginApiResponse = Response.init(code: .success, responseStatusCode: responseStausCode, message: failureMessage, data: data)
            case .failure( _):
                loginApiResponse = Response.init(code: .failure, responseStatusCode: responseStausCode, message: failureMessage, data: nil)
            }
            completion?(loginApiResponse)
        }
    }
}
