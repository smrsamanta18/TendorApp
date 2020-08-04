//
//  ViewOfferDetailsModel.swift
//  TendorApp
//
//  Created by Samir Samanta on 26/03/20.
//  Copyright © 2020 Asif Dafadar. All rights reserved.
//

import UIKit
import ObjectMapper
import Alamofire
import AlamofireObjectMapper

class ViewOfferDetailsModel: Mappable {

    var id : String?
    var tid : String?
    var user_id : String?
    var currency : String?
    var amount : String?
    var attachment : String?
    var description : String?
    var completion_days : String?
    var date : String?
      
      init() {}
      required init?(map: Map) {
          mapping(map: map)
      }
     
      func mapping(map: Map) {
         id <- map["view-bid.id"]
         tid <- map["view-bid.tid"]
         user_id <- map["view-bid.user_id"]
         currency <- map["view-bid.currency"]
         amount <- map["view-bid.amount"]
         attachment <- map["view-bid.attachment"]
         description <- map["view-bid.description"]
         completion_days <- map["view-bid.completion_days"]
         date <- map["view-bid.date"]
     }
}
class AdditonalInfoModel: Mappable {

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
