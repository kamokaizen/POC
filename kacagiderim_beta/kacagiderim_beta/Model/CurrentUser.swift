//
//  CurrentUser.swift
//  kacagiderim_beta
//
//  Created by kamilinal on 7/30/18.
//  Copyright © 2018 kacagiderim. All rights reserved.
//

// To parse the JSON, add this file to your project and do:
//
//   let currentUser = try? JSONDecoder().decode(CurrentUser.self, from: jsonData)

import Foundation

struct CurrentUser: Codable {
    let principal: Principal
    let name: String
}

struct Principal: Codable {
    let password: JSONNull?
    let username: String
    let authorities: [Authority]
    let accountNonExpired, accountNonLocked, credentialsNonExpired, enabled: Bool
    let userDto: User
}

struct Authority: Codable {
    let authority: String
}

// MARK: Encode/decode helpers

class JSONNull: Codable {
    public init() {}
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encodeNil()
    }
}
