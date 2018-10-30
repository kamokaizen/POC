//
//  CarTableViewModel.swift
//  kacagiderim_beta
//
//  Created by kamilinal on 10/28/18.
//  Copyright © 2018 kacagiderim. All rights reserved.
//

import Foundation
import CardParts
import RxSwift
import RxCocoa

class CarTableViewModel {
    var state: Variable<CardState> = Variable(CardState.empty)
    var accountVehicles: Variable<[AccountVehicle]> = Variable([])
    
    init() {
        self.state.value = .empty
    }
    
    func getVehicles() -> Void {
        self.state.value = .loading
        let user = DefaultManager.getUser()
        if(user != nil){
            APIClient.getUserVehicles(userId: (user?.userId)!, completion:{ result in
                switch result {
                case .success(let serverResponse):
                    if (serverResponse.value?.accountVehicles.count)! > 0 {
                        self.state.value = .hasData
                        self.accountVehicles.value = (serverResponse.value?.accountVehicles)!
                    }
                    else{
                        self.state.value = .empty
                    }
                case .failure(let error):
                    print((error as! CustomError).localizedDescription)
                    self.state.value = .custom("fail")
                }
            })
        }
        else{
            Utils.delayWithSeconds(1, completion: {
                self.state.value = .custom("fail")
            })
        }
    }
}
