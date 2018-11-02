//
//  Model.swift
//  kacagiderim_beta
//
//  Created by Comodo on 2.11.2018.
//  Copyright © 2018 kacagiderim. All rights reserved.
//

import Foundation

struct Model: Codable {
    let brandId: String?
    let modelId: String?
    let name: String?
    
    init(name: String, modelId: String, brandId: String) {
        self.name = name
        self.modelId = modelId
        self.brandId = brandId
    }
}
