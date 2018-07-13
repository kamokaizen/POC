//
//  GithubProfile.swift
//  testlogin
//
//  Created by Comodo on 13.07.2018.
//  Copyright © 2018 comodo. All rights reserved.
//

import Foundation
import UIKit

struct GithubProfile: Codable {
    let name: String?
    let login: String?
    let location: String?
    let type: String?
    let company: String?
    let email: String?
    let avatarUrl: URL?
    
    enum CodingKeys: String, CodingKey {
        case name
        case login
        case location
        case type
        case company
        case email
        case avatarUrl = "avatar_url"
    }
}
