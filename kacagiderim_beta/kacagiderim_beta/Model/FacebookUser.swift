//
//  FacebookUser.swift
//  kacagiderim_beta
//
//  Created by Comodo on 9.10.2018.
//  Copyright © 2018 kacagiderim. All rights reserved.
//

import Foundation

struct FacebookUser: Codable {
    let userId: String?
    let name: String?
    let surname: String?
    let email: String?
    let imageURL: String?
    let authenticationToken: String?
    let expirationDate: Int
    
    init(userId: String? = nil,
         name: String? = nil,
         surname: String? = nil,
         email: String? = nil,
         imageURL: String? = nil,
         authenticationToken: String? = nil,
         expirationDate: Int) {
        self.userId = userId
        self.name = name
        self.surname = surname
        self.email = email
        self.authenticationToken = authenticationToken
        self.expirationDate = expirationDate
        self.imageURL = imageURL
    }
}
