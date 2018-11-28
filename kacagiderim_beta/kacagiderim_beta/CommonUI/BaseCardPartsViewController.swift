//
//  BaseCardPartsViewController.swift
//  kacagiderim_beta
//
//  Created by kamilinal on 11/28/18.
//  Copyright © 2018 kacagiderim. All rights reserved.
//

import Foundation
import CardParts

class BaseCardPartsViewController: CardPartsViewController, ShadowCardTrait, RoundedCardTrait {
    
    func shadowColor() -> CGColor {
        return UIColor.lightGray.cgColor
    }
    
    func shadowRadius() -> CGFloat {
        return 10.0
    }
    
    func shadowOpacity() -> Float {
        return 1.0
    }
    
    func cornerRadius() -> CGFloat {
        return 10.0
    }
}
