//
//  NotificationModel.swift
//  TendorApp
//
//  Created by Samir Samanta on 15/03/20.
//  Copyright © 2020 Asif Dafadar. All rights reserved.
//

import ObjectMapper
import Alamofire
import AlamofireObjectMapper

class NotificationModel: Mappable {

    var user_id : String?
    var total : Int?
    var notificationList : [NotificationList]?
    init() {}
    required init?(map: Map) {
        mapping(map: map)
    }
    
    func mapping(map: Map) {
        user_id <- map["user_id"]
        total <- map["total"]
        notificationList <- map["notification"]
    }
}

class NotificationList: Mappable {

    var id : String?
    var user_id : String?
    var message : String?
    var date : String?
    var flag : String?
    
    
    
    init() {}
    required init?(map: Map) {
        mapping(map: map)
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        user_id <- map["user_id"]
        message <- map["message"]
        date <- map["totdateal"]
        flag <- map["flag"]
    }
}
