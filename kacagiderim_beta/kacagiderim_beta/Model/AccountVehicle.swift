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
    let vehicleUsage: Int?
    let vehicleBrand: String?
    let vehicleModel: String?
    let vehicleDescription: String?
    let customVehicle: Bool
    let customVehicleName: String?
    let customConsumption: Bool
    let customConsumptionType: Int?
    let averageCustomConsumptionLocal, averageCustomConsumptionOut: Double
        
    init(accountVehicleId: String? = nil, vehicleDetailId:String? = nil, userId: String? = nil, vehiclePlate: String? = nil,
    vehicleUsage: Int? = 0,
    vehicleBrand: String? = nil,
    vehicleModel: String? = nil,
    vehicleDescription: String? = nil,
    customVehicle: Bool,
    customVehicleName: String? = nil,
    customConsumption: Bool,
    customConsumptionType: Int? = nil,
    averageCustomConsumptionLocal: Double, averageCustomConsumptionOut: Double){
        self.accountVehicleId = accountVehicleId
        self.vehicleDetailId = vehicleDetailId
        self.userId = userId
        self.vehiclePlate = vehiclePlate
        self.vehicleBrand = vehicleBrand
        self.vehicleModel = vehicleModel
        self.vehicleUsage = vehicleUsage
        self.vehicleDescription = vehicleDescription
        self.customVehicle = customVehicle
        self.customVehicleName = customVehicleName
        self.customConsumption = customConsumption
        self.customConsumptionType = customConsumptionType
        self.averageCustomConsumptionOut = averageCustomConsumptionOut
        self.averageCustomConsumptionLocal = averageCustomConsumptionLocal
    }
}
