//
//  LatestTendorModel.swift
//  TendorApp
//
//  Created by Samir Samanta on 15/03/20.
//  Copyright © 2020 Asif Dafadar. All rights reserved.
//

import ObjectMapper
import Alamofire
import AlamofireObjectMapper

class LatestTendorModel: Mappable {
    var latestList : [LatestTendorList]?    
    init() {}
    required init?(map: Map) {
        mapping(map: map)
    }
    
    func mapping(map: Map) {
        latestList <- map["latest"]
    }
}
class LatestTendorList: Mappable {
    
   var tid : String?
   var user_id : String?
   var title : String?
   var attachment : String?
   var attachment_name : String?
   var tender_type : String?
   var cat_id : String?
   var sub_cat_id : String?
   var tender_description : String?
   var create_date : String?
   var opening_date : String?
   var exp_date : String?
   var ip_address : String?
   var status : String?
   var country_id : String?
   var global : String?
   var reference : String?
   var cat_name : String?
    
    
    
    
    init() {}
    required init?(map: Map) {
        mapping(map: map)
    }
    
    func mapping(map: Map) {
        tid <- map["tid"]
        user_id <- map["user_id"]
        title <- map["title"]
        attachment <- map["attachment"]
        attachment_name <- map["attachment_name"]
        tender_type <- map["tender_type"]
        cat_id <- map["cat_id"]
        sub_cat_id <- map["sub_cat_id"]
        status <- map["status"]
        tender_description <- map["tender_description"]
        
        create_date <- map["create_date"]
        opening_date <- map["opening_date"]
        exp_date <- map["exp_date"]
        ip_address <- map["ip_address"]
        status <- map["status"]
        country_id <- map["country_id"]
        global <- map["global"]
        reference <- map["reference"]
        cat_name <- map["cat_name"]
    }
}
class PublishTendorModel: Mappable {
    
    var isSuccess : Bool?
    var message : String?
    
    init() {}
    required init?(map: Map) {
        mapping(map: map)
    }
    
    func mapping(map: Map) {
        isSuccess <- map["isSuccess"]
        message <- map["message"]
    }
}
