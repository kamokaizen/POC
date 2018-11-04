//
//  Brand.swift
//  kacagiderim_beta
//
//  Created by kamilinal on 10/27/18.
//  Copyright © 2018 kacagiderim. All rights reserved.
//

import Foundation

protocol CommonVehicleProtocol {
    func getId() -> String;
    func getName() -> String;
    
}

struct Brand: Codable, CommonVehicleProtocol {
    
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
    
    func getId() -> String {
        return self.brandId ?? ""
    }
    
    func getName() -> String {
        return self.name ?? ""
    }
}
