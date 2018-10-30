//
//  AccountVehicle.swift
//  kacagiderim_beta
//
//  Created by Comodo on 30.10.2018.
//  Copyright © 2018 kacagiderim. All rights reserved.
//

import Foundation

struct AccountVehicle: Codable {
    let accountVehicleId, vehicleDetailId, userId, vehiclePlate: String?
    let customVehicle: Bool
    let customVehicleName: String?
    let customConsumption: Bool
    let customConsumptionType: String?
    let averageCustomConsumptionLocal, averageCustomConsumptionOut: Double
    let vehicle: Vehicle
}
