//
//  SearchResultModel.swift
//  TendorApp
//
//  Created by Samir Samanta on 15/03/20.
//  Copyright © 2020 Asif Dafadar. All rights reserved.
//

import ObjectMapper
import Alamofire
import AlamofireObjectMapper

class SearchResultModel: Mappable {

    var resultList : [LatestTendorList]?
    init() {}
    required init?(map: Map) {
        mapping(map: map)
    }
    
    func mapping(map: Map) {
        resultList <- map["result"]
    }
}
