//
//  Utils.swift
//  kacagiderim_beta
//
//  Created by kamilinal on 7/21/18.
//  Copyright © 2018 kacagiderim. All rights reserved.
//

import Foundation
import UIKit
import NVActivityIndicatorView
import SwiftEntryKit

class Utils {
    
    static func delayWithSeconds(_ seconds: Double, completion: @escaping () -> ()) {
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
            completion()
        }
    }
    
    static func imageWithImage(image:UIImage, scaledToSize newSize:CGSize) -> UIImage{
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        image.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }
    
    static func showLoadingIndicator(message:String, size:CGSize){
        let activityData = ActivityData(size: size, message: message, type: K.Constants.default_spinner)
        NVActivityIndicatorPresenter.sharedInstance.startAnimating(activityData, K.Constants.DEFAULT_FADE_IN_ANIMATION)
    }
    
    static func dismissLoadingIndicator(){
        NVActivityIndicatorPresenter.sharedInstance.stopAnimating(K.Constants.DEFAULT_FADE_OUT_ANIMATION)
    }
    
    static func getAttributes(element: EKAttributes, duration: Double, entryBackground: EKAttributes.BackgroundStyle, screenBackground: EKAttributes.BackgroundStyle, roundCorners: EKAttributes.RoundCorners) -> EKAttributes{
        var ekAttribute = element
        ekAttribute.hapticFeedbackType = .success
        ekAttribute.displayDuration = duration
        ekAttribute.entryBackground = entryBackground
        ekAttribute.screenBackground = screenBackground
        ekAttribute.shadow = .active(with: .init(color: .black, opacity: 0.5, radius: 10))
        ekAttribute.screenInteraction = .dismiss
        ekAttribute.entryInteraction = .absorbTouches
        ekAttribute.scroll = .enabled(swipeable: true, pullbackAnimation: .easeOut)
        ekAttribute.roundCorners = roundCorners
        ekAttribute.entranceAnimation = .init(translate: .init(duration: 0.7, spring: .init(damping: 1, initialVelocity: 0)),
                                              scale: .init(from: 1.05, to: 1, duration: 0.4, spring: .init(damping: 1, initialVelocity: 0)))
        ekAttribute.exitAnimation = .init(translate: .init(duration: 0.2))
        ekAttribute.popBehavior = .animated(animation: .init(translate: .init(duration: 0.3), scale: .init(from: 1, to: 0.7, duration: 0.7)))
        ekAttribute.positionConstraints.verticalOffset = 10
        ekAttribute.positionConstraints.size = .init(width: .offset(value: 20), height: .intrinsic)
        ekAttribute.positionConstraints.maxSize = .init(width: .constant(value: UIScreen.main.minEdge), height: .intrinsic)
        ekAttribute.statusBar = .dark
        return ekAttribute
    }
    
    static func showNotificationMessage(attributes: EKAttributes, title: String, desc: String, textColor: UIColor, imageName: String? = nil) {
        let title = EKProperty.LabelContent(text: title, style: .init(font: MainFont.medium.with(size: 16), color: textColor))
        let description = EKProperty.LabelContent(text: desc, style: .init(font: MainFont.light.with(size: 14), color: textColor))
        var image: EKProperty.ImageContent?
        if let imageName = imageName {
            image = .init(image: UIImage(named: imageName)!, size: CGSize(width: 35, height: 35))
        }
        
        let simpleMessage = EKSimpleMessage(image: image, title: title, description: description)
        let notificationMessage = EKNotificationMessage(simpleMessage: simpleMessage)
        
        let contentView = EKNotificationMessageView(with: notificationMessage)
        SwiftEntryKit.display(entry: contentView, using: attributes)
    }
    
    static func showAlertView(attributes: EKAttributes, title: String, desc: String, textColor: UIColor, imageName: String, imagePosition: EKAlertMessage.ImagePosition, customButton:EKProperty.ButtonContent? = nil) {
        
        // Generate textual content
        let title = EKProperty.LabelContent(text: title, style: .init(font: MainFont.medium.with(size: 15), color: textColor, alignment: .center))
        let description = EKProperty.LabelContent(text: desc, style: .init(font: MainFont.light.with(size: 13), color: textColor, alignment: .center))
        let image = EKProperty.ImageContent(imageName: imageName, size: CGSize(width: 35, height: 35), contentMode: .scaleAspectFit)
        let simpleMessage = EKSimpleMessage(image: image, title: title, description: description)
        
        // Close button
        let closeButtonLabelStyle = EKProperty.LabelStyle(font: MainFont.medium.with(size: 16), color: EKColor.Gray.a800)
        let closeButtonLabel = EKProperty.LabelContent(text: "Cancel", style: closeButtonLabelStyle)
        let closeButton = EKProperty.ButtonContent(label: closeButtonLabel, backgroundColor: .clear, highlightedBackgroundColor:  EKColor.Gray.a800.withAlphaComponent(0.05)) {
            SwiftEntryKit.dismiss()
        }
        
        let buttonsBarContent: EKProperty.ButtonBarContent
        
        if(customButton == nil) {
            buttonsBarContent = EKProperty.ButtonBarContent(with: closeButton, separatorColor: EKColor.Gray.light, expandAnimatedly: true)
        }
        else{
            buttonsBarContent = EKProperty.ButtonBarContent(with: closeButton, customButton!, separatorColor: EKColor.Gray.light, expandAnimatedly: true)
        }
        
        let alertMessage = EKAlertMessage(simpleMessage: simpleMessage, imagePosition: imagePosition, buttonBarContent: buttonsBarContent)
        
        // Setup the view itself
        let contentView = EKAlertMessageView(with: alertMessage)
        SwiftEntryKit.display(entry: contentView, using: attributes)
    }
    
    static func showPopupMessage(attributes: EKAttributes, title: String, titleColor: UIColor, description: String, descriptionColor: UIColor, buttonTitleColor: UIColor, buttonBackgroundColor: UIColor, buttonTitle: String, image: UIImage? = nil, buttonCompletion: @escaping () -> Void) {
        
        var themeImage: EKPopUpMessage.ThemeImage?
        
        if let image = image {
            themeImage = .init(image: .init(image: image, size: CGSize(width: 60, height: 60), contentMode: .scaleAspectFit))
        }
        
        let title = EKProperty.LabelContent(text: title, style: .init(font: MainFont.medium.with(size: 24), color: titleColor, alignment: .center))
        let description = EKProperty.LabelContent(text: description, style: .init(font: MainFont.light.with(size: 16), color: descriptionColor, alignment: .center))
        let button = EKProperty.ButtonContent(label: .init(text: buttonTitle, style: .init(font: MainFont.bold.with(size: 16), color: buttonTitleColor)), backgroundColor: buttonBackgroundColor, highlightedBackgroundColor: buttonTitleColor.withAlphaComponent(0.05))
        let message = EKPopUpMessage(themeImage: themeImage, title: title, description: description, button: button) {
            SwiftEntryKit.dismiss()
            buttonCompletion()
        }
        
        let contentView = EKPopUpMessageView(with: message)
        SwiftEntryKit.display(entry: contentView, using: attributes)
    }
    
    static func showSelectionPopup(attributes: EKAttributes, title: String, titleColor: UIColor, description: String, descriptionColor: UIColor, image: UIImage? = nil, buttons: [EKProperty.ButtonContent]? = nil) {
        
        // Generate textual content
        let title = EKProperty.LabelContent(text: title, style: .init(font: MainFont.medium.with(size: 20), color: titleColor, alignment: .center))
        let description = EKProperty.LabelContent(text: description, style: .init(font: MainFont.light.with(size: 15), color: descriptionColor, alignment: .center))
        let simpleMessage = EKSimpleMessage(title: title, description: description)
        
        var buttonsBarContent = EKProperty.ButtonBarContent(separatorColor: EKColor.Gray.light, expandAnimatedly: true)
        if(buttons != nil && (buttons?.count)! > 0){
            for button in buttons! {
                buttonsBarContent.content.append(button)
            }
        }
        
        let alertMessage = EKAlertMessage(simpleMessage: simpleMessage, imagePosition: EKAlertMessage.ImagePosition.top, buttonBarContent:buttonsBarContent)
        
        // Setup the view itself
        let contentView = EKAlertMessageView(with: alertMessage)
        
        SwiftEntryKit.display(entry: contentView, using: attributes)
    }
    
    static func getBrandTypeString(value: Int) -> String{
        switch value {
        case BrandType.AUTOMOBILE.rawValue:
            return "Automobile"
        case BrandType.MINIVAN.rawValue:
            return "Minivan"
        case BrandType.SUV.rawValue:
            return "SUV"
        default:
            return ""
        }
    }
    
    static func getCurrencyIndex(metric:CurrencyMetrics) -> CurrencyMetricsIndex{
        switch metric{
        case .TRY:
            return CurrencyMetricsIndex.TRY
        case .EUR:
            return CurrencyMetricsIndex.EUR
        case .USD:
            return CurrencyMetricsIndex.USD
        }
    }
    
    static func getDistanceIndex(metric:DistanceMetrics) -> DistanceMetricsIndex{
        switch metric{
        case .KM:
            return DistanceMetricsIndex.KM
        case .M:
            return DistanceMetricsIndex.M
        case .MILE:
            return DistanceMetricsIndex.MILE
        }
    }
    
    static func getVolumeIndex(metric:VolumeMetrics) -> VolumeMetricsIndex{
        switch metric{
        case .LITER:
            return VolumeMetricsIndex.LITER
        case .GALLON:
            return VolumeMetricsIndex.GALLON
        }
    }
    
    static func getCurrencyMetric(index: CurrencyMetricsIndex) -> CurrencyMetrics {
        switch index {
        case .TRY:
            return CurrencyMetrics.TRY
        case .USD:
            return CurrencyMetrics.USD
        case .EUR:
            return CurrencyMetrics.EUR
        }
    }
    
    static func getDistanceMetric(index: DistanceMetricsIndex) -> DistanceMetrics {
        switch index {
        case .KM:
            return DistanceMetrics.KM
        case .M:
            return DistanceMetrics.M
        case .MILE:
            return DistanceMetrics.MILE
        }
    }
    
    static func getVolumeMetric(index: VolumeMetricsIndex) -> VolumeMetrics {
        switch index {
        case .LITER:
            return VolumeMetrics.LITER
        case .GALLON:
            return VolumeMetrics.GALLON
        }
    }
}
