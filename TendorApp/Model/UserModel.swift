//
//  UserModel.swift
//  Phoenix Errands
//
//  Created by Raghav Beriwala on 27/08/19.
//  Copyright © 2019 Shyam Future Tech. All rights reserved.
//

import UIKit
import ObjectMapper
import Alamofire
import AlamofireObjectMapper

class UserModel: Mappable {

    
    var action : String?
    var userName : String?
    var userpassword : String?
    var device_token : String?
    
    
    init() {}
    required init?(map: Map) {
        mapping(map: map)
    }
    
    func mapping(map: Map) {
        action <- map["action"]
        userName <- map["userName"]
        userpassword <- map["userpassword"]
        device_token <- map["device_token"]
    }
}

class dashboardParam: Mappable {
    
    
    var action : String?
    var authorizationToken : String?
    
    init() {}
    required init?(map: Map) {
        mapping(map: map)
    }
    
    func mapping(map: Map) {
        action <- map["action"]
        authorizationToken <- map["authorizationToken"]
    }
}

class TendorDetailsParam: Mappable {
    
    
    var action : String?
    var authorizationToken : String?
    var tid : String?
    
    init() {}
    required init?(map: Map) {
        mapping(map: map)
    }
    
    func mapping(map: Map) {
        action <- map["action"]
        authorizationToken <- map["authorizationToken"]
        tid <- map["tid"]
    }
}
class MessageDetailsParam: Mappable {
    
    
    var action : String?
    var authorizationToken : String?
    var tid : String?
    init() {}
    required init?(map: Map) {
        mapping(map: map)
    }
    
    func mapping(map: Map) {
        action <- map["action"]
        authorizationToken <- map["authorizationToken"]
        tid <- map["tid"]
    }
}

class ChatParam: Mappable {
    
    var action : String?
    var authorizationToken : String?
    var tid : String?
    var message : String?
    var receiver : String?
    
    init() {}
    required init?(map: Map) {
        mapping(map: map)
    }
    
    func mapping(map: Map) {
        action <- map["action"]
        authorizationToken <- map["authorizationToken"]
        tid <- map["tid"]
        message <- map["message"]
        receiver <- map["receiver"]
    }
}


class BidParams: Mappable {
    
    var servicerequestid : Int?
    var proposalamount: Int?
    
    init() {}
    required init?(map: Map) {
        mapping(map: map)
    }
    
    func mapping(map: Map) {
        servicerequestid <- map["servicerequestid"]
        proposalamount <- map["proposalamount"]
        
    }
}

class ContactParams: Mappable {
    
    var contactID : Int?
    
    init() {}
    required init?(map: Map) {
        mapping(map: map)
    }
    
    func mapping(map: Map) {
        contactID <- map["contactID"]
    }
}
class SubCatagorySearchParams: Mappable
{
    var searchText : String?
    var subCategoryID : Int?
    
    init() {}
    required init?(map: Map) {
        mapping(map: map)
    }
    
    func mapping(map: Map) {
        searchText <- map["searchText"]
        subCategoryID <- map["subCategoryID"]
    }
}

class ReviewParam: Mappable
{
    var order_id : Int?
    var review : String?
    var rating : Int?
    
    init() {}
    required init?(map: Map) {
        mapping(map: map)
    }
    
    func mapping(map: Map) {
        order_id <- map["order_id"]
        review <- map["review"]
        rating <- map["rating"]
    }
}


class UserProfile: Mappable {
    
    var userFirstName : String?
    var userLastName : String?
    var userEmail : String?
    var phone : String?
    
    init() {}
    required init?(map: Map) {
        mapping(map: map)
    }
    
    func mapping(map: Map) {
        userFirstName <- map["userFirstName"]
        userLastName <- map["userLastName"]
        userEmail <- map["userEmail"]
        phone <- map["phone"]
    }
}

class SearchParam: Mappable
{
    var action : String?
    var type : String?
    //country_id:111
    var cat_id : String?
    var search : String?
    
    init() {}
    required init?(map: Map) {
        mapping(map: map)
    }
    
    func mapping(map: Map) {
        action <- map["action"]
        type <- map["type"]
        cat_id <- map["cat_id"]
        search <- map["search"]
    }
}
class ProfileParam: Mappable {
    
    var action : String?
    var authorizationToken : String?
    
    init() {}
    required init?(map: Map) {
        mapping(map: map)
    }
    
    func mapping(map: Map) {
        action <- map["action"]
        authorizationToken <- map["authorizationToken"]
    }
}

class OfferParam: Mappable {
    var action : String?
    var tid : String?
    var id : String?
    
    init() {}
    required init?(map: Map) {
        mapping(map: map)
    }
    
    func mapping(map: Map) {
        action <- map["action"]
        tid <- map["tid"]
        id <- map["id"]
    }
}


class AdditionalInfoParam: Mappable {

    var action : String?
    var authorizationToken : String?
    var tid : String?
    var tender_description : String?
    var attachment : String?
    init() {}
    required init?(map: Map) {
        mapping(map: map)
    }
    
    func mapping(map: Map) {
        action <- map["action"]
        authorizationToken <- map["authorizationToken"]
        tid <- map["tid"]
        tender_description <- map["tender_description"]
        attachment <- map["attachment"]
    }
}


class SelectOfferParam: Mappable {

    var action : String?
    var authorizationToken : String?
    var tid : String?
    var supplier_id : String?
    var message : String?
    var bid_id : String?
    
    
    init() {}
    required init?(map: Map) {
        mapping(map: map)
    }
    
    func mapping(map: Map) {
        action <- map["action"]
        authorizationToken <- map["authorizationToken"]
        tid <- map["tid"]
        supplier_id <- map["supplier_id"]
        message <- map["message"]
        bid_id <- map["bid_id"]
    }
}



class MyTendorParam: Mappable {
    
    var action : String?
    var authorizationToken : String?
    
    init() {}
    required init?(map: Map) {
        mapping(map: map)
    }
    
    func mapping(map: Map) {
        action <- map["action"]
        authorizationToken <- map["authorizationToken"]
    }
}

class PublishTendorParam: Mappable {
    var action : String?
    var authorizationToken : String?

    var title : String?
    var cat_id : String?
    var sub_cat_id : String?
    var tender_description : String?
    var opening_date : String?
    var exp_date : String?
    
    init() {}
    required init?(map: Map) {
        mapping(map: map)
    }
    
    func mapping(map: Map) {
        action <- map["action"]
        authorizationToken <- map["authorizationToken"]
        
        title <- map["title"]
        cat_id <- map["cat_id"]
        sub_cat_id <- map["sub_cat_id"]
        tender_description <- map["tender_description"]
        opening_date <- map["opening_date"]
        exp_date <- map["exp_date"]
    }
}

class PublishTendorObject: Mappable {
    
    var title : String?
    var cat_Type : String?
    var cat_id : String?
    var cat_Name : String?
    var sub_cat_id : String?
    var country : String?
    var tender_description : String?
    var opening_date : String?
    var exp_date : String?
    var attachment : String?
    var attacheImg : UIImage?
    
    init() {}
    required init?(map: Map) {
        mapping(map: map)
    }
    
    func mapping(map: Map) {
        
        title <- map["title"]
        cat_id <- map["cat_id"]
        sub_cat_id <- map["sub_cat_id"]
        tender_description <- map["tender_description"]
        opening_date <- map["opening_date"]
        exp_date <- map["exp_date"]
        attachment <- map["attachment"]
        country <- map["country"]
        attacheImg <- map["attacheImg"]
    }
}
