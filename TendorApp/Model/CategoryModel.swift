//
//  CategoryModel.swift
//  TendorApp
//
//  Created by Samir Samanta on 25/10/19.
//  Copyright © 2019 Asif Dafadar. All rights reserved.
//

import ObjectMapper
import Alamofire
import AlamofireObjectMapper

class CategoryModel: Mappable {

    
    var categoryList : [CategoryList]?
    var serviceList : [ServiceList]?
    var productList : [ProductList]?
    
    
    init() {}
    required init?(map: Map) {
        mapping(map: map)
    }
    
    func mapping(map: Map) {
        categoryList <- map["categories"]
        productList <- map["Products"]
        serviceList <- map["Services"]
        
    }
}
class CategoryList: Mappable {
    
    
    var cat_id : String?
    var cat_name : String?
    var meta_title : String?
    var seo_url : String?
    var meta_keys : String?
    var meta_desc : String?
    var total : String?
    var parent_id : String?
    var status : String?
    var icon : String?
    
    
    init() {}
    required init?(map: Map) {
        mapping(map: map)
    }
    
    func mapping(map: Map) {
        cat_id <- map["cat_id"]
        cat_name <- map["cat_name"]
        meta_title <- map["meta_title"]
        seo_url <- map["seo_url"]
        meta_keys <- map["meta_keys"]
        meta_desc <- map["meta_desc"]
        total <- map["total"]
        parent_id <- map["parent_id"]
        status <- map["status"]
        icon <- map["icon"]
    }
}
class ProductList: Mappable {
    
    
    var cat_id : String?
    var cat_name : String?
    var meta_title : String?
    var seo_url : String?
    var meta_keys : String?
    var meta_desc : String?
    var total : String?
    var parent_id : String?
    var status : String?
    var icon : String?
    
    
    init() {}
    required init?(map: Map) {
        mapping(map: map)
    }
    
    func mapping(map: Map) {
        cat_id <- map["cat_id"]
        cat_name <- map["cat_name"]
        meta_title <- map["meta_title"]
        seo_url <- map["seo_url"]
        meta_keys <- map["meta_keys"]
        meta_desc <- map["meta_desc"]
        total <- map["total"]
        parent_id <- map["parent_id"]
        status <- map["status"]
        icon <- map["icon"]
    }
}
class ServiceList: Mappable {
    
    
    var cat_id : String?
    var cat_name : String?
    var meta_title : String?
    var seo_url : String?
    var meta_keys : String?
    var meta_desc : String?
    var total : String?
    var parent_id : String?
    var status : String?
    var icon : String?
    
    
    init() {}
    required init?(map: Map) {
        mapping(map: map)
    }
    
    func mapping(map: Map) {
        cat_id <- map["cat_id"]
        cat_name <- map["cat_name"]
        meta_title <- map["meta_title"]
        seo_url <- map["seo_url"]
        meta_keys <- map["meta_keys"]
        meta_desc <- map["meta_desc"]
        total <- map["total"]
        parent_id <- map["parent_id"]
        status <- map["status"]
        icon <- map["icon"]
    }
}
