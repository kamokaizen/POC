//
//  ServerResponse.swift
//  kacagiderim_beta
//
//  Created by Comodo on 20.07.2018.
//  Copyright © 2018 kacagiderim. All rights reserved.
//

import Foundation


struct ServerResponse: Codable {
    let status: Bool
    let statusCode: Int
    let reason: String
}
