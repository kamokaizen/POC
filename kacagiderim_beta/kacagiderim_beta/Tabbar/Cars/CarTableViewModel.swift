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
    var state: Variable<CardState> = Variable(CardState.none)
    var vehicles: Variable<[Vehicle]> = Variable([])
    
    init() {
        self.state.value = .empty
        getVehicles()
    }
    
    func getVehicles() -> Void {
        self.state.value = .loading
        let profile = UserDefaults.standard.value(forKey:"userProfile") as? User
        if(profile != nil){
            APIClient.getUserVehicles(userId: (profile!.userId)!, completion:{ result in
                switch result {
                case .success(let pageResponse):
                    if (pageResponse.value?.pageResult.count)! > 0 {
                        self.state.value = .hasData
                    }
                    else{
                        self.state.value = .empty
                    }
                case .failure(let error):
                    print((error as! CustomError).localizedDescription)
                }
            })
        }
        else{
            Utils.delayWithSeconds(1, completion: {
                self.state.value = .empty
            })
        }
    }
}
