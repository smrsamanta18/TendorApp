//
//  DashboardServices.swift
//  TendorApp
//
//  Created by Samir Samanta on 25/10/19.
//  Copyright © 2019 Asif Dafadar. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireObjectMapper

protocol DashboardServicesProtocol {
    func getDashboardDetails(params: [String: Any], completion: RequestCompletionHandler?)
    func getTendorDetails(params: [String: Any], completion: RequestCompletionHandler?)
}
class DashboardServices: DashboardServicesProtocol {
    
    func getDashboardDetails(params: [String : Any], completion: RequestCompletionHandler?) {
        let loginApi = APIConstants.dashboadApi()
        print("params==>\(params)")
        //let header = ["Content-Type" : "application/json"]
        Alamofire.request(loginApi, method: .post, parameters: params, headers: nil).responseObject {(response: DataResponse<DashboardModel>) in
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
    
    func getTendorDetails(params: [String : Any], completion: RequestCompletionHandler?) {
        let loginApi = APIConstants.dashboadApi()
        print("params==>\(params)")
        //let header = ["Content-Type" : "application/json"]
        Alamofire.request(loginApi, method: .post, parameters: params, headers: nil).responseObject {(response: DataResponse<TendorDetailsModel>) in
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
