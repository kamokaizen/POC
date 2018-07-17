//
//  URLs.swift
//  kacagiderim_beta
//
//  Created by Comodo on 17.07.2018.
//  Copyright © 2018 kacagiderim. All rights reserved.
//

import Foundation
import Alamofire

enum URLs: URLConvertible {
    case register
    case deviceList
    case vpnProfile
    case reportList
    case reportData
    case deviceSummary
    
    private static var baseURLPath: String {
        return isDev ? APIConstants.baseURLDev : APIConstants.baseURLProd
    }
    
    func urlString() -> String {
        switch self {
        case .register: return URLs.baseURLPath / .v1 / .mobile / .register
        case .deviceList: return URLs.baseURLPath / .v1 / .mobile / .device / .list
        case .vpnProfile: return URLs.baseURLPath / .v1 / .mobile / .vpn / .profile
        case .reportList: return URLs.baseURLPath / .v1 / .mobile / .report / .list
        case .reportData: return URLs.baseURLPath / .v1 / .mobile / .report / .data
        case .deviceSummary: return URLs.baseURLPath / .v1 / .mobile / .device / .summary
        }
    }
    
    func asURL() throws -> URL {
        guard let url = URL(string: urlString()) else {
            throw URLsError.incompatible
        }
        
        return url
    }
}

