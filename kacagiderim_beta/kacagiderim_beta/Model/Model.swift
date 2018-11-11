//
//  Model.swift
//  kacagiderim_beta
//
//  Created by Comodo on 2.11.2018.
//  Copyright © 2018 kacagiderim. All rights reserved.
//

import Foundation

struct Model: Codable, CommonVehicleProtocol {

    let brandId: String?
    let modelId: String?
    let name: String?
    let brandName: String?
    let hasChild: Bool
    
    init(name: String, modelId: String, brandId: String, brandName: String, hasChild: Bool) {
        self.name = name
        self.modelId = modelId
        self.brandId = brandId
        self.brandName = brandName
        self.hasChild = hasChild
    }
    
    func getId() -> String {
        return self.modelId ?? ""
    }
    
    func getName() -> String {
        return self.name ?? ""
    }
    
    func getImagePath() -> String {
        return K.Constants.cloudinaryCarPath + (self.brandName ?? "") + "/thumb/" + (self.name ?? "")
    }
    
    func hasAnyChild() -> Bool {
        return self.hasChild
    }
}
