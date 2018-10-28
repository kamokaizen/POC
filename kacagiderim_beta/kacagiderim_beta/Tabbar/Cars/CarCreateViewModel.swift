//
//  CarCreateViewModel.swift
//  kacagiderim_beta
//
//  Created by kamilinal on 10/28/18.
//  Copyright © 2018 kacagiderim. All rights reserved.
//

import Foundation
import CardParts
import RxSwift
import RxCocoa

class CarCreateViewModel {
    var state: Variable<CardState> = Variable(CardState.none)
    
    init() {
        self.state.value = .none
    }
    
    func createVehicle() -> Void {
        self.state.value = .loading
        // TODO create vehicle
        Utils.delayWithSeconds(1, completion: {
            self.state.value = CardState.hasData
        })
    }
}
