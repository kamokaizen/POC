//
//  Vehicle.swift
//  kacagiderim_beta
//
//  Created by kamilinal on 10/28/18.
//  Copyright © 2018 kacagiderim. All rights reserved.
//

import Foundation

struct Detail: Codable, CommonVehicleProtocol {
    let detailId: String?
    let versionId: String?
    let brandName: String?
    let brandImageName: String?
    let modelImageName: String?
    let modelDescription: String?
    let longModelDescription: String?
    let width: Int
    let height: Int
    let body: String?
    let endYear: String?
    let fuelType: String?
    let doors: Int
    let acceleration: String?
    let hp: Int
    let udc: String?
    let eudc: String?
    let vehicleType: Int
    let newVehicleType: String?
    let categoryId: Int
    let newBody: String?
    let autoClass: String?
    let startYear: String?
    let seats: Int
    let cylinders: Int
    let ccm: Int
    let kw: Int
    let rpm1: Int
    let torque: Int
    let rpm2: Int
    let loadedWeight: Int
    let unloadedWeight: Int
    let nedc: String?
    let tyresFront: String?
    let topSpeed: Int
    let luggageCapacity: Int
    let octane: Int
    let fuelcap: Int
    let brandGearType: String?
    let transmission: String?
    let drive: String?
    let emission: String?
    let catalisor: String?
    let totalWeight: Int
    let wheelBase: Int
    let engineType: String?
    let cycleArrangement: String?
    let tyresBack: String?
    let ece90: String?
    let ece120: String?
    let eceCity: String?
    let approvedAngle: String?
    let departureAngle: String?
    let brakeAngle: String?
    let wadeDepth: String?
    let groClear: String?
    let gripAngle: String?
    let angulOff: String?
    let impStart: Int
    let impEnd: Int
    let modelType: String?
    let subModelName: String?
    let subModelStartYear: Int
    let subModelEndYear: Int
    let equipmentType: String?
    let ps: Int
    let co2: Int
    let techGearType: String?
    let rampAngle: String?
    let length: Int
    let electricalSpecRange: Int
    let electricalSpecHp: Int
    let electricalSpecKw: Int
    let electricalSpecTorque: Int
    let electricalSpecAccumulatorOutput: String?
    let electricalSpecAccumulatorType: String?
    let electricalSpecChargeTime: String?
    let electricalSpecFastChargeTime: String?
    
    func getId() -> String {
        return self.detailId ?? ""
    }
    
    func getName() -> String {
        return self.modelDescription ?? ""
    }
    
    func getImagePath() -> String {
        return "engine.png"
    }
    
    func hasAnyChild() -> Bool {
        return false
    }
    
    func getFuelType() -> FuelType {
        switch self.fuelType {
        case "D":
            return FuelType.DIZEL
        case "O":
            return FuelType.BENZIN
        case "E":
            return FuelType.HIBRIT
        default:
            return FuelType.BENZIN
        }
    }
    
    func getFuelTypeString() -> String {
        switch self.fuelType {
        case "D":
            return FuelTypeString.DIZEL.rawValue
        case "O":
            return FuelTypeString.BENZIN.rawValue
        case "E":
            return FuelTypeString.HIBRIT.rawValue
        default:
            return FuelTypeString.BENZIN.rawValue
        }
    }
}
