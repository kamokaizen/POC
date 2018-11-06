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
    
    init(name: String, versionId: String, engineId: String, engineName: String) {
        self.name = name
        self.versionId = versionId
        self.engineId = engineId
        self.engineName = engineName
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
}
