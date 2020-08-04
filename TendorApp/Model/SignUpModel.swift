//
//  SignUpModel.swift
//  TendorApp
//
//  Created by Samir Samanta on 16/03/20.
//  Copyright © 2020 Asif Dafadar. All rights reserved.
//

import ObjectMapper
import Alamofire
import AlamofireObjectMapper

class SignUpModel: Mappable {
    
    var action : String?
    var fname : String?
    var lname : String?
    var email : String?
    var work_title : String?
    var company_name : String?
    var address : String?
    var company_desc : String?
    var country_id : String?
    var website : String?
    var phone : String?
    var password : String?
    var conpassword : String?
    var profileImg : UIImage?
    var imgName : String?
    
    
    init() {}
    required init?(map: Map) {
        mapping(map: map)
    }
    
    func mapping(map: Map) {
        action <- map["action"]
        fname <- map["fname"]
        lname <- map["lname"]
        email <- map["email"]
        work_title <- map["work_title"]
        company_name <- map["company_name"]
        address <- map["address"]
        company_desc <- map["company_desc"]
        country_id <- map["country_id"]
        website <- map["website"]
        phone <- map["phone"]
        password <- map["password"]
        profileImg <- map["profileImg"]
        imgName <- map["imgName"]
    }
}

class ForgotParam: Mappable {
    
    var action : String?
    var email : String?
    
    
    init() {}
    required init?(map: Map) {
        mapping(map: map)
    }
    
    func mapping(map: Map) {
        action <- map["action"]
        email <- map["email"]
       
    }
}
class ForgotResponse: Mappable {
    
    var status : Int?
    var isSuccess : Bool?
    var message : String?
    
    
    init() {}
    required init?(map: Map) {
        mapping(map: map)
    }
    
    func mapping(map: Map) {
        status <- map["status"]
        isSuccess <- map["isSuccess"]
        message <- map["message"]
    }
}

class FacebookLoginModel: Mappable {
    
    var action : String?
    var fname : String?
    var lname : String?
    var email : String?
    var facebookID: String?
    var profileImg : UIImage?
    var imgName : String?
    var device_token : String?
    
    
    init() {}
    required init?(map: Map) {
        mapping(map: map)
    }
    
    func mapping(map: Map) {
        action <- map["action"]
        fname <- map["fname"]
        lname <- map["lname"]
        email <- map["email"]
        facebookID <- map["facebookID"]
        profileImg <- map["profileImg"]
        imgName <- map["imgName"]
        device_token <- map["device_token"]
    }
}

