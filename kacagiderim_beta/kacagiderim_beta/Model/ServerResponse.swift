//
//  ServerResponse.swift
//  kacagiderim_beta
//
//  Created by Comodo on 17.07.2018.
//  Copyright © 2018 kacagiderim. All rights reserved.
//

import UIKit
import ObjectMapper

class ServerResponse<T: Mappable>: NSObject {
    var status: Bool?
    var statusCode: Int?
    var result: T?
    var message: String?
    
    required init?(map: Map) {}
    
    var error: Error? {
        let code = statusCode ?? 0
        guard status == false else { return nil }
        return NSError(domain: "com.kacagiderim", code: code, userInfo: [NSLocalizedDescriptionKey: message ?? L10n.mvcTimeOut])
    }
}

extension ServerResponse: Mappable {
    func mapping(map: Map) {
        status <- map[.status]
        statusCode <- map[.statusCode]
        result <- map[.result]
        message <- map[.message]
    }
}
