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
        let isAccountVehiclesFetched = DefaultManager.isAccountVehiclesFetched()
        
        if(isAccountVehiclesFetched){
            let accountVehicles = DefaultManager.getAccountVehicles()
            
            // if has vehicle no need to get data from server
            if(accountVehicles.count > 0){
                self.state.value = .hasData
                self.accountVehicles.value = accountVehicles
                return
            }
        }
        else{
            refreshAccountVehicles()
        }
    }
    
    func refreshAccountVehicles(){
        let user = DefaultManager.getUser()
        if(user != nil){
            self.state.value = .loading
            APIClient.getUserVehicles(userId: (user?.userId)!, completion:{ result in
                switch result {
                case .success(let serverResponse):
                    DefaultManager.setIsAccountVehiclesFetched(isAccountVehiclesFetched: true)
                    DefaultManager.setAccountVehicles(accountVehicles: serverResponse.value?.accountVehicles ?? [])
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
    
    @objc func deleteRow(indexPath: Int){
        let attributes = Utils.getAttributes(element: EKAttributes.centerFloat,
                                             duration: .infinity,
                                             entryBackground: .color(color: .white),
                                             screenBackground: .color(color: .dimmedLightBackground),
                                             roundCorners: .all(radius: 25))
        
        let okButtonLabelStyle = EKProperty.LabelStyle(font: MainFont.medium.with(size: 16), color: EKColor.Teal.a600)
        let okButtonLabel = EKProperty.LabelContent(text: "Delete", style: okButtonLabelStyle)
        let okButton = EKProperty.ButtonContent(label: okButtonLabel, backgroundColor: .clear, highlightedBackgroundColor:  EKColor.Teal.a600.withAlphaComponent(0.05)) {
            SwiftEntryKit.dismiss()
            
            let accountVehicleId = self.accountVehicles.value[indexPath].accountVehicleId ?? ""
            APIClient.deleteVehicle(accountVehicleId: accountVehicleId, completion: {result in
                switch result {
                case .success(let response):
                    if response.status == true {
                        self.accountVehicles.value.remove(at: indexPath)
                        DefaultManager.setAccountVehicles(accountVehicles: self.accountVehicles.value)
                        PopupHandler.successPopup(title: "Success", description: "The vehicle deleted")
                        return
                    }
                    PopupHandler.errorPopup(title: "Error", description: "Something went wrong, vehicle could not be deleted")
                case .failure(let error):
                    print((error as! CustomError).localizedDescription)
                    PopupHandler.errorPopup(title: "Error", description: "Something went wrong, vehicle could not be deleted")
                }})
        }
        
        Utils.showAlertView(attributes: attributes, title: "Confirmation", desc: "Do you want to delete selected vehicle?", textColor: .black, imageName: "logo.png", imagePosition: .left, customButton: okButton)
    }
    
    @objc func refreshData(_ sender: Any) {
        // refresh Data
        refreshAccountVehicles()
    }
}
