//
//  Engine.swift
//  kacagiderim_beta
//
//  Created by kamilinal on 11/6/18.
//  Copyright © 2018 kacagiderim. All rights reserved.
//

import Foundation

struct Engine: Codable, CommonVehicleProtocol {
    
    let engineId: String?
    let modelId: String?
    let name: String?
    let modelName: String?
    let hasChild: Bool
    
    init(name: String, modelId: String, engineId: String, modelName: String, hasChild: Bool) {
        self.name = name
        self.modelId = modelId
        self.engineId = engineId
        self.modelName = modelName
        self.hasChild = hasChild
    }
    
    func getId() -> String {
        return self.engineId ?? ""
    }
    
    func getName() -> String {
        return self.name ?? ""
    }
    
    func getDetail() -> String {
        return ""
    }
    
    func getImagePath() -> String {
        return "engine.png"
    }
    
    func hasAnyChild() -> Bool {
        return self.hasChild
    }
}
