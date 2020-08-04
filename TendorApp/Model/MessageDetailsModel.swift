//
//  MessageDetailsModel.swift
//  TendorApp
//
//  Created by Samir Samanta on 23/03/20.
//  Copyright © 2020 Asif Dafadar. All rights reserved.
//

import ObjectMapper
import Alamofire
import AlamofireObjectMapper

class MessageDetailsModel: Mappable {

    var messageDetailsList : [MessageDetailsArray]?
    
    init() {}
    required init?(map: Map) {
        mapping(map: map)
        
    }
    func mapping(map: Map) {
        messageDetailsList <- map["message"]
    }
}
class MessageDetailsArray: Mappable {
    
    var msgid : String?
    var tid : String?
    var receiver : String?
    var receiver_name : String?
    var receiver_logo : String?
    var sender : String?
    var sender_name : String?
    var sender_logo : String?
    var message : String?
    var msg_date : String?
    var attachment : String?
    
    init() {}
    required init?(map: Map) {
        mapping(map: map)
        
    }
    func mapping(map: Map) {
        msgid <- map["msgid"]
        tid <- map["tid"]
        receiver <- map["receiver"]
        receiver_name <- map["receiver_name"]
        receiver_logo <- map["receiver_logo"]
        sender <- map["sender"]
        sender_name <- map["sender_name"]
        sender_logo <- map["sender_logo"]
        message <- map["message"]
        msg_date <- map["msg_date"]
        attachment <- map["attachment"]
    }
}
