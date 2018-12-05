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
    
    init(detailId: String? = nil,
    versionId: String? = nil,
    brandName: String? = nil,
    brandImageName: String? = nil,
    modelImageName: String? = nil,
    modelDescription: String? = nil,
    longModelDescription: String? = nil,
    width: Int = 0,
    height: Int = 0,
    body: String? = nil,
    endYear: String? = nil,
    fuelType: String? = nil,
    doors: Int = 0,
    acceleration: String? = nil,
    hp: Int = 0,
    udc: String? = nil,
    eudc: String? = nil,
    vehicleType: Int = 0,
    newVehicleType: String? = nil,
    categoryId: Int = 0,
    newBody: String? = nil,
    autoClass: String? = nil,
    startYear: String? = nil,
    seats: Int = 0,
    cylinders: Int = 0,
    ccm: Int = 0,
    kw: Int = 0,
    rpm1: Int = 0,
    torque: Int = 0,
    rpm2: Int = 0,
    loadedWeight: Int = 0,
    unloadedWeight: Int = 0,
    nedc: String? = nil,
    tyresFront: String? = nil,
    topSpeed: Int = 0,
    luggageCapacity: Int = 0,
    octane: Int = 0,
    fuelcap: Int = 0,
    brandGearType: String? = nil,
    transmission: String? = nil,
    drive: String? = nil,
    emission: String? = nil,
    catalisor: String? = nil,
    totalWeight: Int = 0,
    wheelBase: Int = 0,
    engineType: String? = nil,
    cycleArrangement: String? = nil,
    tyresBack: String? = nil,
    ece90: String? = nil,
    ece120: String? = nil,
    eceCity: String? = nil,
    approvedAngle: String? = nil,
    departureAngle: String? = nil,
    brakeAngle: String? = nil,
    wadeDepth: String? = nil,
    groClear: String? = nil,
    gripAngle: String? = nil,
    angulOff: String? = nil,
    impStart: Int = 0,
    impEnd: Int = 0,
    modelType: String? = nil,
    subModelName: String? = nil,
    subModelStartYear: Int = 0,
    subModelEndYear: Int = 0,
    equipmentType: String? = nil,
    ps: Int = 0,
    co2: Int = 0,
    techGearType: String? = nil,
    rampAngle: String? = nil,
    length: Int = 0,
    electricalSpecRange: Int = 0,
    electricalSpecHp: Int = 0,
    electricalSpecKw: Int = 0,
    electricalSpecTorque: Int = 0,
    electricalSpecAccumulatorOutput: String? = nil,
    electricalSpecAccumulatorType: String? = nil,
    electricalSpecChargeTime: String? = nil,
    electricalSpecFastChargeTime: String? = nil){
        self.detailId = detailId
        self.versionId = versionId
        self.brandName = brandName
        self.brandImageName = brandImageName
        self.modelImageName = modelImageName
        self.modelDescription = modelDescription
        self.longModelDescription = longModelDescription
        self.width = width
        self.height = height
        self.body = body
        self.endYear = endYear
        self.fuelType = fuelType
        self.doors = doors
        self.acceleration = acceleration
        self.hp = hp
        self.udc = udc
        self.eudc = eudc
        self.vehicleType = vehicleType
        self.newVehicleType = newVehicleType
        self.categoryId = categoryId
        self.newBody = newBody
        self.autoClass = autoClass
        self.startYear = startYear
        self.seats = seats
        self.cylinders = cylinders
        self.ccm = ccm
        self.kw = kw
        self.rpm1 = rpm1
        self.torque = torque
        self.rpm2 = rpm2
        self.loadedWeight = loadedWeight
        self.unloadedWeight = unloadedWeight
        self.nedc = nedc
        self.tyresFront = tyresFront
        self.topSpeed = topSpeed
        self.luggageCapacity = luggageCapacity
        self.octane = octane
        self.fuelcap = fuelcap
        self.brandGearType = brandGearType
        self.transmission = transmission
        self.drive = drive
        self.emission = emission
        self.catalisor = catalisor
        self.totalWeight = totalWeight
        self.wheelBase = wheelBase
        self.engineType = engineType
        self.cycleArrangement = cycleArrangement
        self.tyresBack = tyresBack
        self.ece90 = ece90
        self.ece120 = ece120
        self.eceCity = eceCity
        self.approvedAngle = approvedAngle
        self.departureAngle = departureAngle
        self.brakeAngle = brakeAngle
        self.wadeDepth = wadeDepth
        self.groClear = groClear
        self.gripAngle = gripAngle
        self.angulOff = angulOff
        self.impStart = impStart
        self.impEnd = impEnd
        self.modelType = modelType
        self.subModelName = subModelName
        self.subModelStartYear = subModelStartYear
        self.subModelEndYear = subModelEndYear
        self.equipmentType = equipmentType
        self.ps = ps
        self.co2 = co2
        self.techGearType = techGearType
        self.rampAngle = rampAngle
        self.length = length
        self.electricalSpecRange = electricalSpecRange
        self.electricalSpecHp = electricalSpecHp
        self.electricalSpecKw = electricalSpecKw
        self.electricalSpecTorque = electricalSpecTorque
        self.electricalSpecAccumulatorOutput = electricalSpecAccumulatorOutput
        self.electricalSpecAccumulatorType = electricalSpecAccumulatorType
        self.electricalSpecChargeTime = electricalSpecChargeTime
        self.electricalSpecFastChargeTime = electricalSpecChargeTime
    }
    
    func getId() -> String {
        return self.detailId ?? ""
    }
    
    func getName() -> String {
        return "\(self.longModelDescription ?? "")"
    }
    
    func getDetail() -> String {
        return "\(self.endYear ?? "0") - \(self.startYear ?? "0")"
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
