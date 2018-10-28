//
//  Vehicle.swift
//  kacagiderim_beta
//
//  Created by kamilinal on 10/28/18.
//  Copyright © 2018 kacagiderim. All rights reserved.
//

import Foundation

struct Vehicle: Codable {
    let name: String?
    
    init(name: String) {
        self.name = name
    }
}
