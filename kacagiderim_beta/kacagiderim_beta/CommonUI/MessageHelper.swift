//
//  MessageHelper.swift
//  kacagiderim_beta
//
//  Created by kamilinal on 7/21/18.
//  Copyright © 2018 kacagiderim. All rights reserved.
//

import UIKit
import Dodo

class MessageHelper {
    
    func showInfoMessage(text: String, view: UIView){
        view.dodo.style.label.color = UIColor.white
        view.dodo.style.bar.hideAfterDelaySeconds = 5
        view.dodo.style.bar.hideOnTap = true
        view.dodo.topAnchor = view.safeAreaLayoutGuide.topAnchor
        view.dodo.bottomAnchor = view.safeAreaLayoutGuide.bottomAnchor
        view.dodo.success(text)
        view.dodo.style.leftButton.icon = .close
        view.dodo.style.leftButton.hideOnTap = true
        view.dodo.style.leftButton.tintColor = DodoColor.fromHexString("#FFFFFF90")
        view.dodo.style.bar.animationHide = DodoAnimations.slideRight.hide
    }
    
    func showErrorMessage(text: String, view: UIView){
        view.dodo.style.label.color = UIColor.white
        view.dodo.style.bar.hideAfterDelaySeconds = 5
        view.dodo.style.bar.hideOnTap = true
        view.dodo.topAnchor = view.safeAreaLayoutGuide.topAnchor
        view.dodo.bottomAnchor = view.safeAreaLayoutGuide.bottomAnchor
        view.dodo.error(text)
        view.dodo.style.leftButton.icon = .close
        view.dodo.style.leftButton.hideOnTap = true
        view.dodo.style.leftButton.tintColor = DodoColor.fromHexString("#FFFFFF90")
        view.dodo.style.bar.animationHide = DodoAnimations.slideRight.hide
    }
}
