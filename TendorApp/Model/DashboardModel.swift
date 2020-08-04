//
//  DashboardModel.swift
//  TendorApp
//
//  Created by Samir Samanta on 25/10/19.
//  Copyright © 2019 Asif Dafadar. All rights reserved.
//

import ObjectMapper
import Alamofire
import AlamofireObjectMapper

class DashboardModel: Mappable {

    
    var user_id : Int?
    var user_type : Int?
    var profile_data : Int?
    var total_tender : Int?
    var total_tender_open : Int?
    var total_tender_close : Int?
    
    
    init() {}
    required init?(map: Map) {
        mapping(map: map)
    }
    
    func mapping(map: Map) {
        user_id <- map["user_id"]
        user_type <- map["user_type"]
        profile_data <- map["profile_data"]
        
        total_tender <- map["total_tender"]
        total_tender_open <- map["total_tender_open"]
        total_tender_close <- map["total_tender_close"]
        
    }
}
