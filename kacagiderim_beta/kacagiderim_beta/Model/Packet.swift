//
//  Packet.swift
//  kacagiderim_beta
//
//  Created by kamilinal on 12/1/18.
//  Copyright © 2018 kacagiderim. All rights reserved.
//

import Foundation

struct Packet: Codable, CommonVehicleProtocol {
    
    let packetId: String?
    let versionId: String?
    let name: String?
    let versionName: String?
    let hasChild: Bool
    
    init(name: String, packetId: String, versionId: String, versionName: String, hasChild:Bool) {
        self.name = name
        self.versionId = versionId
        self.packetId = packetId
        self.versionName = versionName
        self.hasChild = hasChild
    }
    
    func getId() -> String {
        return self.packetId ?? ""
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
