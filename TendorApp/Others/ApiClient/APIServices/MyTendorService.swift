//
//  MyTendorService.swift
//  TendorApp
//
//  Created by Samir Samanta on 16/03/20.
//  Copyright © 2020 Asif Dafadar. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireObjectMapper

protocol MyTendorServiceProtocol {
    func getMyTendorDetailsDetails(params: [String: Any], completion: RequestCompletionHandler?)
}
class MyTendorService: MyTendorServiceProtocol {
    
    func getMyTendorDetailsDetails(params: [String : Any], completion: RequestCompletionHandler?) {
        let loginApi = APIConstants.dashboadApi()
        print("params==>\(params)")
        //let header = ["Content-Type" : "application/json"]
        Alamofire.request(loginApi, method: .post, parameters: params, headers: nil).responseObject {(response: DataResponse<MyTendorModel>) in
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
