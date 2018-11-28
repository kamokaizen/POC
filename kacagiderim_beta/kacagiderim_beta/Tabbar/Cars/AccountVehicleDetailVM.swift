//
//  AccountVehicleDetailVM.swift
//  kacagiderim_beta
//
//  Created by kamilinal on 11/20/18.
//  Copyright © 2018 kacagiderim. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class AccountVehicleDetailVM {
    var accountVehicle : AccountVehicle
    var detail : Detail
    var plate: BehaviorRelay<String> = BehaviorRelay(value: "")
    var customVehicle: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    var customVehicleSelectedIndex: BehaviorRelay<Int> = BehaviorRelay(value: -1)
    var customConsumption: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    var customConsumptionIndex: BehaviorRelay<Int> = BehaviorRelay(value: -1)
    var averageCustomConsumptionLocal: BehaviorRelay<String> = BehaviorRelay(value: "")
    var averageCustomConsumptionOut: BehaviorRelay<String> = BehaviorRelay(value: "")
    var customVehicleName: BehaviorRelay<String> = BehaviorRelay(value: "")
    var customConsumptionTypeIndex: BehaviorRelay<Int> = BehaviorRelay(value: -1)
    
    // detail properties
    var fuelType: BehaviorRelay<String> = BehaviorRelay(value: "")
    var udc: BehaviorRelay<String> = BehaviorRelay(value: "")
    var eudc: BehaviorRelay<String> = BehaviorRelay(value: "")
    var nedc: BehaviorRelay<String> = BehaviorRelay(value: "")
    var fuelCap: BehaviorRelay<String> = BehaviorRelay(value: "")
    var seats: BehaviorRelay<String> = BehaviorRelay(value: "")
    var length: BehaviorRelay<String> = BehaviorRelay(value: "")
    var width: BehaviorRelay<String> = BehaviorRelay(value: "")
    var height: BehaviorRelay<String> = BehaviorRelay(value: "")
    var loadedWeight: BehaviorRelay<String> = BehaviorRelay(value: "")
    var unloadedWeight: BehaviorRelay<String> = BehaviorRelay(value: "")
    var luggageCapacity: BehaviorRelay<String> = BehaviorRelay(value: "")
    var tyresFront: BehaviorRelay<String> = BehaviorRelay(value: "")
    var engineType: BehaviorRelay<String> = BehaviorRelay(value: "")
    var engineCapacity: BehaviorRelay<String> = BehaviorRelay(value: "")
    var maximumPower: BehaviorRelay<String> = BehaviorRelay(value: "")
    var maximumTork: BehaviorRelay<String> = BehaviorRelay(value: "")
    var acceleration: BehaviorRelay<String> = BehaviorRelay(value: "")
    var topSpeed: BehaviorRelay<String> = BehaviorRelay(value: "")
    var vehicleType: BehaviorRelay<String> = BehaviorRelay(value: "")
    var bodyType: BehaviorRelay<String> = BehaviorRelay(value: "")
    var enginePower: BehaviorRelay<String> = BehaviorRelay(value: "")
    var productionYear: BehaviorRelay<String> = BehaviorRelay(value: "")
    var transmission: BehaviorRelay<String> = BehaviorRelay(value: "")
    
    init(accountVehicle: AccountVehicle) {
        self.accountVehicle = accountVehicle
        self.detail = Detail()
        self.getDetail()
        self.initValues()
    }
    
    func getDetail() {
        let detail = DefaultManager.getAccountVehicleDetail(detailId: self.accountVehicle.vehicleDetailId ?? "")
        
        if(detail == nil){
            APIClient.getDetail(detailId: self.accountVehicle.vehicleDetailId ?? "", completion: { result in
                switch result {
                case .success(let response):
                    self.detail = response.value ?? Detail()
                    DefaultManager.setAccountVehicleDetail(detailId: self.accountVehicle.vehicleDetailId ?? "", detail: self.detail)
                    self.initDetails()
                case .failure(let error):
                    print((error as! CustomError).localizedDescription)
                }
            })
        }
        else{
            self.detail = detail!
            initDetails()
        }
    }
    
    func updateAccountVehicle() -> Void {
        print("Plate: \(self.plate.value as Any)")
        print("Custom Vehicle Index: \(self.customVehicleSelectedIndex.value as Any)")
        print("Custom Consumption Index: \(self.customConsumptionIndex.value as Any)")
        print("Average Consumption Local: \(self.averageCustomConsumptionLocal.value as Any)")
        print("Average Consumption Out: \(self.averageCustomConsumptionOut.value as Any)")
        print("Custom Vehicle Name: \(self.customVehicleName.value as Any)")
        print("Custom Consumption Type Index: \(self.customConsumptionTypeIndex.value as Any)")
        let accountVehicle = AccountVehicle(accountVehicleId: self.accountVehicle.accountVehicleId,
                                            vehicleDetailId: self.accountVehicle.vehicleDetailId,
                                            userId: self.accountVehicle.userId,
                                            vehiclePlate: self.plate.value,
                                            vehicleUsage: self.accountVehicle.vehicleUsage,
                                            vehicleBrand: self.accountVehicle.vehicleBrand,
                                            vehicleModel: self.accountVehicle.vehicleModel,
                                            vehicleDescription: self.accountVehicle.vehicleDescription,
                                            customVehicle: self.customVehicleSelectedIndex.value == 1 ? true : false,
                                            customVehicleName: self.customVehicleName.value,
                                            customConsumption: self.customConsumptionIndex.value == 1 ? true : false,
                                            customConsumptionType: self.customConsumptionTypeIndex.value,
                                            averageCustomConsumptionLocal: Double(self.averageCustomConsumptionLocal.value) ?? 0,
                                            averageCustomConsumptionOut: Double(self.averageCustomConsumptionOut.value) ?? 0)
        APIClient.updateVehicle(accountVehicle: accountVehicle, completion: {result in
            switch result {
            case .success(let response):
                if response.status == true {
                    self.accountVehicle = response.value ?? self.accountVehicle
                    DefaultManager.updateAccountVehicle(accountVehicle: response.value ?? self.accountVehicle)
                    PopupHandler.successPopup(title: "Success", description: "The vehicle updated")
                    return
                }
                PopupHandler.errorPopup(title: "Error", description: "Something went wrong, vehicle could not be updated")
            case .failure(let error):
                print((error as! CustomError).localizedDescription)
                PopupHandler.errorPopup(title: "Error", description: "Something went wrong, vehicle could not be updated")
            }})
    }
    
    func initValues(){
        self.plate.accept(accountVehicle.vehiclePlate ?? "")
        self.customVehicle.accept(accountVehicle.customVehicle)
        self.customVehicleSelectedIndex.accept(accountVehicle.customVehicle == true ? 1 : 0)
        self.customConsumption.accept(accountVehicle.customConsumption)
        self.customConsumptionIndex.accept(accountVehicle.customConsumption == true ? 1 : 0)
        self.averageCustomConsumptionLocal.accept("\(accountVehicle.averageCustomConsumptionLocal)")
        self.averageCustomConsumptionOut.accept("\(accountVehicle.averageCustomConsumptionOut)")
        self.customVehicleName.accept(accountVehicle.customVehicleName ?? "")
        self.customConsumptionTypeIndex.accept(accountVehicle.customConsumptionType ?? -1)
    }
    
    func initDetails(){
        self.fuelType.accept("\(self.detail.getFuelTypeString()) / \(self.detail.emission ?? "-")")
        self.udc.accept("\(self.detail.udc ?? "-") lt")
        self.eudc.accept("\(self.detail.eudc ?? "-") lt")
        self.nedc.accept("\(self.detail.nedc ?? "-") lt")
        self.fuelCap.accept("\(self.detail.fuelcap) lt")
        self.seats.accept("\(detail.seats) Seats")
        self.length.accept("\(detail.length) mm")
        self.width.accept("\(detail.width) mm")
        self.height.accept("\(detail.height) mm")
        self.loadedWeight.accept("\(detail.loadedWeight) kg")
        self.unloadedWeight.accept("\(detail.unloadedWeight) kg")
        self.luggageCapacity.accept("\(detail.luggageCapacity) lt")
        self.tyresFront.accept("\(detail.tyresFront ?? "-")")
        self.engineType.accept("\(detail.getFuelTypeString()) / \(detail.cylinders) Cylinders")
        self.engineCapacity.accept("\(detail.ccm) cc")
        self.maximumTork.accept("\(detail.torque) nm / \(detail.rpm2) rpm")
        self.maximumPower.accept("\(detail.hp) hp (\(detail.kw) kw) / \(detail.rpm1) rpm")
        self.acceleration.accept("\(detail.acceleration ?? "-") seconds")
        self.topSpeed.accept("\(detail.topSpeed) km/h")
        self.vehicleType.accept("\(detail.newVehicleType ?? "-") / \(detail.autoClass ?? "-") Segment")
        self.bodyType.accept("\(detail.body ?? "-") Doors")
        self.enginePower.accept("\(detail.hp) Hp")
        self.productionYear.accept("\(detail.startYear ?? "-") / \(detail.endYear ?? "-")")
        self.transmission.accept(detail.transmission ?? "-")
    }
}
