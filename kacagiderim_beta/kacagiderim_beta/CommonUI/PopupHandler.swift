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
    
    // Vehicle Form
    static func showVehicleAddForm(detail: Detail, style: FormStyle, buttonCompletion: @escaping (VehicleAddFormStruct) -> Void) {
        var attributes: EKAttributes
        attributes = .toast
        attributes.windowLevel = .normal
        attributes.position = .bottom
        attributes.displayDuration = .infinity
        
        attributes.entranceAnimation = .init(translate: .init(duration: 0.65, spring: .init(damping: 1, initialVelocity: 0)))
        attributes.exitAnimation = .init(translate: .init(duration: 0.65, spring: .init(damping: 1, initialVelocity: 0)))
        attributes.popBehavior = .animated(animation: .init(translate: .init(duration: 0.65, spring: .init(damping: 1, initialVelocity: 0))))
        
        attributes.entryInteraction = .absorbTouches
        attributes.screenInteraction = .dismiss
        
        attributes.entryBackground = .gradient(gradient: .init(colors: [EKColor.Netflix.light, EKColor.Netflix.dark], startPoint: .zero, endPoint: CGPoint(x: 1, y: 1)))
        
        attributes.shadow = .active(with: .init(color: .black, opacity: 0.3, radius: 3))
        attributes.screenBackground = .color(color: .dimmedDarkBackground)
        attributes.scroll = .edgeCrossingDisabled(swipeable: true)
        attributes.statusBar = .light
        
        attributes.positionConstraints.keyboardRelation = .bind(offset: .init(bottom: 0, screenEdgeResistance: 0))
        attributes.positionConstraints.maxSize = .init(width: .constant(value: UIScreen.main.minEdge), height: .intrinsic)
        
        let title = EKProperty.LabelContent(text: "\(detail.getDetail()) | \(detail.brandImageName?.uppercased() ?? "") \(detail.longModelDescription ?? "")" , style: style.title)
        var textFields = FormFieldPresetFactory.fields(by: [.vehiclePlate], style: style)
        let button = EKProperty.ButtonContent(label: .init(text: "Add To Profile", style: style.buttonTitle), backgroundColor: style.buttonBackground, highlightedBackgroundColor: style.buttonBackground.withAlphaComponent(0.8)) {
            SwiftEntryKit.dismiss()
            buttonCompletion(VehicleAddFormStruct(vehiclePlate: textFields[0].textContent, vehicleConsumptionLocal: "", vehicleConsumptionOut: ""))
        }
        let contentView = EKFormMessageView(with: title, textFieldsContent: textFields, buttonContent: button)
        attributes.lifecycleEvents.didAppear = {
            contentView.becomeFirstResponder(with: 0)
        }
        SwiftEntryKit.display(entry: contentView, using: attributes, presentInsideKeyWindow: true)
    }
    
    // Sign up form
    static func showSignupForm(attributes: inout EKAttributes, style: FormStyle) {
        let title = EKProperty.LabelContent(text: "Fill your personal details", style: style.title)
        let textFields = FormFieldPresetFactory.fields(by: [.fullName, .mobile, .email, .password], style: style)
        let button = EKProperty.ButtonContent(label: .init(text: "Continue", style: style.buttonTitle), backgroundColor: style.buttonBackground, highlightedBackgroundColor: style.buttonBackground.withAlphaComponent(0.8)) {
            SwiftEntryKit.dismiss()
        }
        let contentView = EKFormMessageView(with: title, textFieldsContent: textFields, buttonContent: button)
        attributes.lifecycleEvents.didAppear = {
            contentView.becomeFirstResponder(with: 0)
        }
        SwiftEntryKit.display(entry: contentView, using: attributes, presentInsideKeyWindow: true)
    }
}
