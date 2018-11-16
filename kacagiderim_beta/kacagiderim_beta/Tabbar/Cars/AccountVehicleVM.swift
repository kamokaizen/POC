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
import SwiftEntryKit

class AccountVehicleVM {
    var state: Variable<CardState> = Variable(CardState.empty)
    var accountVehicles: Variable<[AccountVehicle]> = Variable([])
    
    init() {
        self.state.value = .empty
    }
    
    func getAccountVehicles() -> Void {
        let accountVehicles = DefaultManager.getAccountVehicles()
        
        // if has vehicle no need to get data from server
        if(accountVehicles.count > 0){
            self.state.value = .hasData
            self.accountVehicles.value = accountVehicles
            return
        }
        
        refreshAccountVehicles()
    }
    
    func refreshAccountVehicles(){
        let user = DefaultManager.getUser()
        if(user != nil){
            self.state.value = .loading
            APIClient.getUserVehicles(userId: (user?.userId)!, completion:{ result in
                switch result {
                case .success(let serverResponse):
                    if (serverResponse.value?.accountVehicles.count)! > 0 {
                        self.state.value = .hasData
                        self.accountVehicles.value = (serverResponse.value?.accountVehicles)!
                        DefaultManager.setAccountVehicles(accountVehicles: self.accountVehicles.value)
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
    
    @objc func deleteRow(indexPath: Int){
        let attributes = Utils.getAttributes(element: EKAttributes.centerFloat,
                                             duration: .infinity,
                                             entryBackground: .color(color: .white),
                                             screenBackground: .color(color: .dimmedLightBackground),
                                             roundCorners: .all(radius: 25))
        
        // Ok Button - Make transition to a new entry when the button is tapped
        let okButtonLabelStyle = EKProperty.LabelStyle(font: MainFont.medium.with(size: 16), color: EKColor.Teal.a600)
        let okButtonLabel = EKProperty.LabelContent(text: "Delete", style: okButtonLabelStyle)
        let okButton = EKProperty.ButtonContent(label: okButtonLabel, backgroundColor: .clear, highlightedBackgroundColor:  EKColor.Teal.a600.withAlphaComponent(0.05)) {
            SwiftEntryKit.dismiss()
            self.accountVehicles.value.remove(at: indexPath)
            // TODO remove from profile too on backend..
            PopupHandler.successPopup(title: "Success", description: "The vehicle deleted")
        }
        
        Utils.showAlertView(attributes: attributes, title: "Confirmation", desc: "Are you sure, Do you want to delete selected vehicle?", textColor: .black, imageName: "logo.png", imagePosition: .left, customButton: okButton)
    }
    
    @objc func refreshData(_ sender: Any) {
        // refresh Data
        refreshAccountVehicles()
    }
}
