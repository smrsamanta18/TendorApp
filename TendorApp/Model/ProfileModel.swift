//
//  ProfileModel.swift
//  TendorApp
//
//  Created by Samir Samanta on 15/03/20.
//  Copyright © 2020 Asif Dafadar. All rights reserved.
//

import ObjectMapper
import Alamofire
import AlamofireObjectMapper

class ProfileModel: Mappable {

    var user_id : String?
    var user_type : String?
    
    var id : String?
    var fname : String?
    var lname : String?
    var work_title : String?
    var company_name : String?
    var address : String?
    var company_desc : String?
    var purchase_req : String?
    var country_id : String?
    var about : String?
    var website : String?
    var phone : String?
    var logo : String?
    var announcement : String?
    var newsletter : String?
    var email : String?
    var reg_date : String?
    
    init() {}
    required init?(map: Map) {
        mapping(map: map)
    }
    
    func mapping(map: Map) {
        user_id <- map["user_id"]
        user_type <- map["user_type"]
        
        id <- map["data.id"]
        fname <- map["data.fname"]
        lname <- map["data.lname"]
        work_title <- map["data.work_title"]
        company_name <- map["data.company_name"]
        address <- map["data.address"]
        company_desc <- map["data.company_desc"]
        purchase_req <- map["data.purchase_req"]
        country_id <- map["data.country_id"]
        about <- map["data.about"]
        website <- map["data.website"]
        phone <- map["data.phone"]
        logo <- map["data.logo"]
        announcement <- map["data.announcement"]
        newsletter <- map["data.newsletter"]
        email <- map["data.email"]
        reg_date <- map["data.reg_date"]
        
        
    }
}
class UpdateProfileModel: Mappable {

    var user_id : String?
    var user_type : String?
    var status : String?
    var message : String?
    init() {}
    required init?(map: Map) {
        mapping(map: map)
    }
    
    func mapping(map: Map) {
        user_id <- map["user_id"]
        user_type <- map["user_type"]
        status <- map["status"]
        message <- map["message"]
    }
}


class UpdateProfileParam: Mappable {
    var action : String?
    var authorizationToken : String?
    var fname : String?
    var lname : String?
    var work_title : String?
    var company_name : String?
    var address : String?
    var company_desc : String?
    var country_id : String?
    var website : String?
    var phone : String?
    
    init() {}
    required init?(map: Map) {
        mapping(map: map)
    }
    
    func mapping(map: Map) {
        action <- map["action"]
        authorizationToken <- map["authorizationToken"]
        fname <- map["fname"]
        lname <- map["lname"]
        work_title <- map["work_title"]
        company_name <- map["company_name"]
        address <- map["address"]
        company_desc <- map["company_desc"]
        country_id <- map["country_id"]
        website <- map["website"]
        phone <- map["phone"]
    }
}


class ChangeParam: Mappable {
    var action : String?
    var authorizationToken : String?
    var old_password : String?
    var new_password : String?
    var conf_password : String?
    
    init() {}
    required init?(map: Map) {
        mapping(map: map)
    }
    
    func mapping(map: Map) {
        action <- map["action"]
        authorizationToken <- map["authorizationToken"]
        old_password <- map["old_password"]
        new_password <- map["new_password"]
        conf_password <- map["conf_password"]
    }
}
