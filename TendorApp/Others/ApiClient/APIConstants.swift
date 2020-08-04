//
//  APIConstants.swift
//  LastingVideoMemories
//
//  Created by on 05/10/18.
//  Copyright © 2018 iOS Dev. All rights reserved.
//

import Foundation

class APIConstants: NSObject {
    
    static let imgBaseURL = "https://mucapp.azurewebsites.net/"
    static let imgprescriptionBase = "https://mucapp.azurewebsites.net/content/labresults/"
    static let baseURL = "https://www.tendor.org/"
    static let loginURL = "app-api.php"
    static let dashboardURL = "app-api.php"
    
    static func logInApi() -> String {
        return baseURL + loginURL
    }
    static func dashboadApi() -> String {
        return baseURL + dashboardURL
    }
}
