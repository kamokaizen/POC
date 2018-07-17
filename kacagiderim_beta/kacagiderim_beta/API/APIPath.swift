//
//  APIPath.swift
//  kacagiderim_beta
//
//  Created by Comodo on 17.07.2018.
//  Copyright © 2018 kacagiderim. All rights reserved.
//

import Foundation

var isDev: Bool {
    #if DEBUG
    return true
    #else
    return false
    #endif
}

enum URLsError: Error {
    case incompatible
}

enum APIPath: String {
    case report
    case vpn
    case servicelist
    case data
    case v1
    case mobile
    case profile
    case register
    case device
    case list
    case summary
}

extension String {
    func appending(_ path: APIPath) -> String {
        return self.appending(path.rawValue)
    }
    
    static func / (left: String, right: String) -> String {
        return left + "/" + right
    }
    
    static func / (left: String, right: APIPath) -> String {
        return left + "/" + right.rawValue
    }
}

