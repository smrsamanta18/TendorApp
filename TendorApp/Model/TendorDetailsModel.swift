//
//  TendorDetailsModel.swift
//  TendorApp
//
//  Created by Samir Samanta on 25/03/20.
//  Copyright © 2020 Asif Dafadar. All rights reserved.
//

import UIKit
import ObjectMapper
import Alamofire
import AlamofireObjectMapper

class TendorDetailsModel: Mappable {

    var company : String?
    var category : String?
    var tender_additional : String?
    var apply_button : String?
    var apply_msg : String?
    
    
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
       
    
    init() {}
    required init?(map: Map) {
        mapping(map: map)
        
    }
    func mapping(map: Map) {
        company <- map["company"]
        category <- map["category"]
        tender_additional <- map["tender_additional"]
        apply_button <- map["apply_button"]
        
        tid <- map["details.tid"]
        user_id <- map["details.user_id"]
        title <- map["details.title"]
        attachment <- map["details.attachment"]
        attachment_name <- map["details.attachment_name"]
        tender_type <- map["details.tender_type"]
        cat_id <- map["details.cat_id"]
        sub_cat_id <- map["details.sub_cat_id"]
        tender_description <- map["details.tender_description"]
        create_date <- map["details.create_date"]
        exp_date <- map["details.exp_date"]
        ip_address <- map["details.ip_address"]
        status <- map["details.status"]
        country_id <- map["details.country_id"]
        global <- map["details.global"]
        reference <- map["details.reference"]
        opening_date <- map["details.opening_date"]
    }
}
