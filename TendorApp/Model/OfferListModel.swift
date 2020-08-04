//
//  OfferListModel.swift
//  TendorApp
//
//  Created by Samir Samanta on 26/03/20.
//  Copyright © 2020 Asif Dafadar. All rights reserved.
//

import UIKit
import ObjectMapper
import Alamofire
import AlamofireObjectMapper
class OfferListModel: Mappable {

    var total : Int?
    var offerList : [OfferList]?
        
     
     init() {}
     required init?(map: Map) {
         mapping(map: map)
     }
    
     func mapping(map: Map) {
         total <- map["total"]
         offerList <- map["bids"]
    }
}

class OfferList: Mappable {

   var id : String?
   var tid : String?
   var user_id : String?
   var currency : String?
   var amount : String?
   var attachment : String?
   var description : String?
   var completion_days : String?
   var date : String?
   var name : String?
        
     
     init() {}
     required init?(map: Map) {
         mapping(map: map)
     }
    
     func mapping(map: Map) {
        id <- map["id"]
        tid <- map["tid"]
        user_id <- map["user_id"]
        currency <- map["currency"]
        amount <- map["amount"]
        attachment <- map["attachment"]
        description <- map["description"]
        completion_days <- map["completion_days"]
        date <- map["date"]
        name <- map["name"]
    }
}
