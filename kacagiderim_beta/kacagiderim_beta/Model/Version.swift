//
//  Version.swift
//  kacagiderim_beta
//
//  Created by kamilinal on 11/6/18.
//  Copyright © 2018 kacagiderim. All rights reserved.
//

import Foundation

struct Version: Codable, CommonVehicleProtocol {
    
    let engineId: String?
    let versionId: String?
    let name: String?
    let engineName: String?
    let hasChild: Bool
    
    init(name: String, versionId: String, engineId: String, engineName: String, hasChild:Bool) {
        self.name = name
        self.versionId = versionId
        self.engineId = engineId
        self.engineName = engineName
        self.hasChild = hasChild
    }
    
    func getId() -> String {
        return self.versionId ?? ""
    }
    
    func getName() -> String {
        return self.name ?? ""
    }
    
    func getImagePath() -> String {
        return "engine.png"
    }
    
    func hasAnyChild() -> Bool {
        return self.hasChild
    }
}
