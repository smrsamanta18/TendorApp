//
//  CountryListModel.swift
//  TendorApp
//
//  Created by Samir Samanta on 25/03/20.
//  Copyright © 2020 Asif Dafadar. All rights reserved.
//

import UIKit
import ObjectMapper
import Alamofire
import AlamofireObjectMapper

class CountryListModel: Mappable {

    var countryList : [CountryListArray]?
    
    init() {}
    required init?(map: Map) {
        mapping(map: map)
        
    }
    func mapping(map: Map) {
        countryList <- map["countries"]
    }
}

class CountryListArray: Mappable {
    
    var id : String?
    var name : String?
    var code : String?
    var status : String?
    var pic : String?
    var total : String?
    
    init() {}
    required init?(map: Map) {
        mapping(map: map)
        
    }
    func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        code <- map["code"]
        status <- map["status"]
        pic <- map["pic"]
        total <- map["total"]
    }
}
