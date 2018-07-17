//
//  RestApiError.swift
//  kacagiderim_beta
//
//  Created by Comodo on 17.07.2018.
//  Copyright © 2018 kacagiderim. All rights reserved.
//

import Foundation

enum RestApiError: Error {
    case emptyResult
    case emptyUUID
    case emptyDeviceId
    
    var localizedDescription: String {
        switch self {
        case .emptyResult: return L10n.apiEmptyResult
        case .emptyUUID: return L10n.apiEmptyUuid
        case .emptyDeviceId: return L10n.apiEmptyDeviceId
        }
    }
    
    var userInfo: [NSError.UserInfoKey: Any] {
        return [NSLocalizedDescriptionKey as NSString: localizedDescription]
    }
    
    var domain: String {
        switch self {
        case .emptyResult,
             .emptyUUID,
             .emptyDeviceId:
            return "com.Comodo.cdome"
        }
    }
    
    var code: Int {
        switch self {
        case .emptyResult,
             .emptyUUID,
             .emptyDeviceId:
            return -100
        }
    }
}

extension Error {
    var localizedDescription: String {
        if let error = self as? RestApiError {
            return error.localizedDescription
        } else {
            return (self as NSError).localizedDescription
        }
    }
}

