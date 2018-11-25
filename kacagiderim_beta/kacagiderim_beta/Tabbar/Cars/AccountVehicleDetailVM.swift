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
    var plate: BehaviorRelay<String> = BehaviorRelay(value: "")
    var customVehicle: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    var customVehicleSelectedIndex: BehaviorRelay<Int> = BehaviorRelay(value: -1)
    var customConsumption: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    var customConsumptionIndex: BehaviorRelay<Int> = BehaviorRelay(value: -1)
    var averageCustomConsumptionLocal: BehaviorRelay<String> = BehaviorRelay(value: "")
    var averageCustomConsumptionOut: BehaviorRelay<String> = BehaviorRelay(value: "")
    var customVehicleName: BehaviorRelay<String> = BehaviorRelay(value: "")
    var customConsumptionType: BehaviorRelay<String> = BehaviorRelay(value: "")
    var customConsumptionTypeIndex: BehaviorRelay<Int> = BehaviorRelay(value: -1)
    
    init(accountVehicle: AccountVehicle) {
        self.accountVehicle = accountVehicle
        self.initValues()
    }
    
    func updateAccountVehicle() -> Void {
        print("Plate: \(self.plate.value as Any)")
        print("Custom Vehicle Index: \(self.customVehicleSelectedIndex.value as Any)")
        print("Custom Consumption Index: \(self.customConsumptionIndex.value as Any)")
        print("Average Consumption Local: \(self.averageCustomConsumptionLocal.value as Any)")
        print("Average Consumption Out: \(self.averageCustomConsumptionOut.value as Any)")
        print("Custom Vehicle Name: \(self.customVehicleName.value as Any)")
        print("Custom Consumption Type: \(self.customConsumptionType.value as Any)")
        print("Custom Consumption Type Index: \(self.customConsumptionType.value as Any)")
        // TODO update on server then update on local item
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
        self.customConsumptionType.accept(accountVehicle.customConsumptionType ?? "")
    }
}
