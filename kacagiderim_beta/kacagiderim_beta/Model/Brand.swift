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
    func getDetail() -> String;
    func getImagePath() -> String;
    func hasAnyChild() -> Bool;
}

struct Brand: Codable, CommonVehicleProtocol {
    
    let name: String?
    let imageName: String?
    let brandId: String?
    let type: Int
    let hasChild: Bool
    
    init(name: String, imageName: String, brandId: String, type: Int, hasChild: Bool) {
        self.name = name
        self.imageName = imageName
        self.brandId = brandId
        self.type = type
        self.hasChild = hasChild
    }
    
    func getId() -> String {
        return self.brandId ?? ""
    }
    
    func getName() -> String {
        return self.name ?? ""
    }
    
    func getDetail() -> String {
        return ""
    }
    
    func getImagePath() -> String {
        return K.Constants.cloudinaryLogoPath + (self.imageName ?? "")
    }
    
    func hasAnyChild() -> Bool {
        return self.hasChild
    }
}
