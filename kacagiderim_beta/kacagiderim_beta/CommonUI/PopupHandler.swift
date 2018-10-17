//
//  PopupHandler.swift
//  kacagiderim_beta
//
//  Created by kamilinal on 10/16/18.
//  Copyright © 2018 kacagiderim. All rights reserved.
//

import Foundation
import SwiftEntryKit

class PopupHandler {
    static func showLoginSuccessPopup(buttonCompletion: @escaping () -> Void){
        let attributes = Utils.getAttributes(element: EKAttributes.bottomFloat,
                                             duration: .infinity,
                                             entryBackground: .color(color: EKColor.Teal.a600),
                                             screenBackground: .color(color: .dimmedLightBackground),
                                             roundCorners: .all(radius: 25))
        Utils.showPopupMessage(attributes: attributes, title: "Congratulations", titleColor: .white, description: "You have successfully logged in.", descriptionColor: .white, buttonTitleColor: .darkSubText, buttonBackgroundColor: .white, buttonTitle: "Lets Start", image: UIImage(named: "ic_success")!, buttonCompletion: {
            buttonCompletion()
        })
    }
    
    static func newAccountCreatedPopup(buttonCompletion: @escaping () -> Void){
        let attributes = Utils.getAttributes(element: EKAttributes.bottomFloat,
                                             duration: .infinity,
                                             entryBackground: .color(color: EKColor.Teal.a600),
                                             screenBackground: .color(color: .dimmedLightBackground),
                                             roundCorners: .all(radius: 25))
        Utils.showPopupMessage(attributes: attributes, title: "Congratulations", titleColor: .white, description: "You have successfully created a new account", descriptionColor: .white, buttonTitleColor: .darkSubText, buttonBackgroundColor: .white, buttonTitle: "Lets Sign In", image: UIImage(named: "ic_success")!, buttonCompletion: {
            buttonCompletion()
        })
    }
    
    static func errorPopup(title: String, description: String){
        let attributes = Utils.getAttributes(element: EKAttributes.topFloat,
                                             duration: 3,
                                             entryBackground: .gradient(gradient: .init(colors: [.redish, .orange], startPoint: .zero, endPoint: CGPoint(x: 1, y: 1))),
                                             screenBackground: .color(color: .dimmedLightBackground),
                                             roundCorners: .all(radius: 25))
        Utils.showNotificationMessage(attributes: attributes, title: title, desc: description, textColor: .white, imageName: "alert")
    }
    
    static func infoPopup(title: String, description: String){
        let attributes = Utils.getAttributes(element: EKAttributes.topFloat,
                                             duration: 3,
                                             entryBackground: .gradient(gradient: .init(colors: [.facebookDarkBlue, .satCyan], startPoint: .zero, endPoint: CGPoint(x: 1, y: 1))),
                                             screenBackground: .color(color: .dimmedLightBackground),
                                             roundCorners: .all(radius: 25))
        Utils.showNotificationMessage(attributes: attributes, title: title, desc: description, textColor: .white, imageName: "ic_info_outline")
    }
    
    static func successPopup(title: String, description: String){
        let attributes = Utils.getAttributes(element: EKAttributes.topFloat,
                                             duration: 3,
                                             entryBackground: .gradient(gradient: .init(colors: [.greenGrass, .satCyan], startPoint: .zero, endPoint: CGPoint(x: 1, y: 1))),
                                             screenBackground: .color(color: .dimmedLightBackground),
                                             roundCorners: .all(radius: 25))
        Utils.showNotificationMessage(attributes: attributes, title: title, desc: description, textColor: .white, imageName: "ic_success")
    }
}
