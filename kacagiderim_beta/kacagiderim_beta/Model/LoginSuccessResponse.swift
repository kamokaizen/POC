//
//  LoginResponse.swift
//  kacagiderim_beta
//
//  Created by Comodo on 20.07.2018.
//  Copyright © 2018 kacagiderim. All rights reserved.
//

import Foundation

struct LoginSuccessResponse: Codable {
    let access_token: String
    let token_type: String
    let refresh_token: String
    let expires_in: Int
    let scope: String
    
    init(accessToken: String,
         tokenType: String,
         refreshToken: String,
         expiresIn: Int,
         scope:String) {
        self.access_token = accessToken
        self.refresh_token = refreshToken
        self.token_type = tokenType
        self.expires_in = expiresIn
        self.scope = scope
    }
}
