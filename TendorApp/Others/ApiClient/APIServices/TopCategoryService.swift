//
//  TopCategoryService.swift
//  TendorApp
//
//  Created by Samir Samanta on 25/10/19.
//  Copyright © 2019 Asif Dafadar. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireObjectMapper

protocol TopCategoryServiceProtocol {
    func getTopCategoryDetails(params: [String: Any], completion: RequestCompletionHandler?)
    func getLatestTendorDetails(completion: RequestCompletionHandler?)
    func getSearchResultDetails(params: [String: Any], completion: RequestCompletionHandler?)
}
//
class TopCategoryService: TopCategoryServiceProtocol {
    
    func getTopCategoryDetails(params: [String : Any], completion: RequestCompletionHandler?) {
        let loginApi = APIConstants.dashboadApi()
        print("params==>\(params)")
        //let header = ["Content-Type" : "application/json"]
        Alamofire.request(loginApi, method: .post, parameters: params, headers: nil).responseObject {(response: DataResponse<CategoryModel>) in
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
    
    
    func getLatestTendorDetails(completion: RequestCompletionHandler?) {
        let loginApi = "https://www.tendor.org/app-api.php?action=latest-tendors"//APIConstants.dashboadApi()
        //let header = ["Content-Type" : "application/json"]
        Alamofire.request(loginApi, method: .get, parameters: nil, headers: nil).responseObject {(response: DataResponse<LatestTendorModel>) in
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
    
    
    func getSearchResultDetails(params: [String : Any], completion: RequestCompletionHandler?) {
        let loginApi = APIConstants.dashboadApi()
        print("params==>\(params)")
        //let header = ["Content-Type" : "application/json"]
        Alamofire.request(loginApi, method: .post, parameters: params, headers: nil).responseObject {(response: DataResponse<SearchResultModel>) in
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
