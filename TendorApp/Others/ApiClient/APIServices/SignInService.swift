//
//  SignInService.swift
//  Phoenix Errands
//
//  Created by Shyam Future Tech on 28/08/19.
//  Copyright © 2019 Shyam Future Tech. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireObjectMapper

protocol SignInServiceProtocol {
    func sendLoginDetails(params: [String: Any], completion: RequestCompletionHandler?)
}

class SignInService: SignInServiceProtocol {
    
    func sendLoginDetails(params: [String : Any], completion: RequestCompletionHandler?) {
        let loginApi = APIConstants.logInApi()
        print("params==>\(params)")
        let header = ["Content-Type" : "application/json"]
        Alamofire.request(loginApi, method: .post, parameters: params, headers: nil).responseObject {(response: DataResponse<UserResponse>) in
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
