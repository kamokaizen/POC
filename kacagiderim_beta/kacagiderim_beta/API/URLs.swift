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
    case createUser
    case getAllCountries

    private static var baseURLPath: String {
        return isDev ? APIConstants.baseURLDev : APIConstants.baseURLProd
    }
    
    func urlString() -> String {
        switch self {
            case .createUser: return URLs.baseURLPath / .uaa / .users / .create
            case .getAllCountries: return URLs.baseURLPath / .nations / .api / .country / .all
        }
    }
    
    func asURL() throws -> URL {
        guard let url = URL(string: urlString()) else {
            throw URLsError.incompatible
        }
        
        return url
    }
}

