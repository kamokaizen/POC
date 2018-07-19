//
//  Constants.swift
//  kacagiderim_beta
//
//  Created by Comodo on 19.07.2018.
//  Copyright © 2018 kacagiderim. All rights reserved.
//

import Foundation

struct K {
    struct ProductionServer {
        static let baseURL = "https://kacagiderim.com"
    }
    
    struct APIParameterKey {
        static let password = "password"
        static let email = "email"
        static let scope = "mobile"
        static let grantType = "grant_type"
    }
    
    struct Constants {
        static let loginAuthorizationValue = "Basic bW9iaWxlOg=="
    }
}

enum HTTPHeaderField: String {
    case authentication = "Authorization"
    case contentType = "Content-Type"
    case acceptType = "Accept"
    case acceptEncoding = "Accept-Encoding"
}

enum ContentType: String {
    case json = "application/json"
    case urlencoded = "application/x-www-form-urlencoded"
}
