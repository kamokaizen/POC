//
//  Brand.swift
//  kacagiderim_beta
//
//  Created by kamilinal on 10/27/18.
//  Copyright © 2018 kacagiderim. All rights reserved.
//

import Foundation

struct Brand: Codable {
    let name: String?
    let imageName: String?
    let brandId: String?
    let type: Int
    
    init(name: String, imageName: String, brandId: String, type: Int) {
        self.name = name
        self.imageName = imageName
        self.brandId = brandId
        self.type = type
    }
}
