//
//  ChatModel.swift
//  TendorApp
//
//  Created by Samir Samanta on 23/03/20.
//  Copyright © 2020 Asif Dafadar. All rights reserved.
//

import UIKit
import ObjectMapper
import Alamofire
import AlamofireObjectMapper

class ChatModel: Mappable {

    var user_id : String?
    var message : String?
    
    init() {}
    required init?(map: Map) {
        mapping(map: map)
        
    }
    func mapping(map: Map) {
        user_id <- map["user_id"]
        message <- map["message"]
    }
    
}
