//
//  UserResponse.swift
//  Phoenix Errands
//
//  Created by Shyam Future Tech on 28/08/19.
//  Copyright © 2019 Shyam Future Tech. All rights reserved.
//

import UIKit
import ObjectMapper
import Alamofire
import AlamofireObjectMapper

class UserResponse: Mappable {
    
    var status : Int?
    var isSuccess : String?
    var message : String?
    
    var userId : String?
    var authorizationToke : String?
    var userName : String?
    var name : String?
    var email : String?
    
    
    init() {}
    required init?(map: Map) {
        mapping(map: map)
    }
    
    func mapping(map: Map) {
        status <- map["status"]
        isSuccess <- map["isSuccess"]
        message <- map["message"]
        
        userId <- map["userDetails.userId"]
        authorizationToke <- map["userDetails.authorizationToken"]
        userName <- map["userDetails.userName"]
        name <- map["userDetails.name"]
        email <- map["userDetails.email"]
    }
}
