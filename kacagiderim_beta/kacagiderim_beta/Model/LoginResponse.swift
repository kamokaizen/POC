//
//  LoginResponse.swift
//  kacagiderim_beta
//
//  Created by Comodo on 20.07.2018.
//  Copyright © 2018 kacagiderim. All rights reserved.
//

import Foundation

struct LoginResponse: Codable {
    let access_token: String
    let token_type: String
    let refresh_token: String
    let expires_in: Int
    let scope: String
}
