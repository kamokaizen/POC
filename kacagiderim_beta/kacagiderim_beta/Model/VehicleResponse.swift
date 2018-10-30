//
//  VehicleResponse.swift
//  kacagiderim_beta
//
//  Created by Comodo on 30.10.2018.
//  Copyright © 2018 kacagiderim. All rights reserved.
//

import Foundation

class VehicleResponse: Codable {
    let accountVehicles: [AccountVehicle]
    
    init(accountVehicles: [AccountVehicle]) {
        self.accountVehicles = accountVehicles
    }
}
