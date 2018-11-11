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
    let vehicle: Detail?
    
    init(accountVehicleId: String?, vehicleDetailId:String?, userId: String?, vehiclePlate: String?,
    customVehicle: Bool,
    customVehicleName: String?,
    customConsumption: Bool,
    customConsumptionType: String?,
    averageCustomConsumptionLocal: Double, averageCustomConsumptionOut: Double,
    vehicle: Detail?){
        self.accountVehicleId = accountVehicleId
        self.vehicleDetailId = vehicleDetailId
        self.userId = userId
        self.vehiclePlate = vehiclePlate
        self.customVehicle = customVehicle
        self.customVehicleName = customVehicleName
        self.customConsumption = customConsumption
        self.customConsumptionType = customConsumptionType
        self.averageCustomConsumptionOut = averageCustomConsumptionOut
        self.averageCustomConsumptionLocal = averageCustomConsumptionLocal
        self.vehicle = vehicle
    }
}
