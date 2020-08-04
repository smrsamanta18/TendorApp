//
//  MessageListModel.swift
//  TendorApp
//
//  Created by Samir Samanta on 23/03/20.
//  Copyright © 2020 Asif Dafadar. All rights reserved.
//

import ObjectMapper
import Alamofire
import AlamofireObjectMapper

class MessageListModel: Mappable {

    var messageList : [MessageListArray]?
    
    init() {}
    required init?(map: Map) {
        mapping(map: map)
        
    }
    func mapping(map: Map) {
        messageList <- map["message"]
    }
}

class MessageListArray: Mappable {

    var tid : String?
    var date : String?
    var title : String?
    var message : String?
    var logo : String?
    var name : String?
    
    init() {}
    required init?(map: Map) {
        mapping(map: map)
    }
    
    func mapping(map: Map) {
        tid <- map["tid"]
        date <- map["date"]
        title <- map["title"]
        message <- map["message"]
        logo <- map["logo"]
        name <- map["name"]
    }
}
