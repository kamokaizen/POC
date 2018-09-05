//
//  CustomCardPartTheme.swift
//  kacagiderim_beta
//
//  Created by kamilinal on 9/6/18.
//  Copyright © 2018 kacagiderim. All rights reserved.
//

import Foundation
import CardParts

public class CustomCardPartTheme: CardPartsTheme {
    
    static var turboHeaderBlueColor: UIColor { get { return UIColor.colorFromHex(0x05A4B5) }}
    
    public var cardsViewContentInsetTop: CGFloat = 0.0
    public var cardsLineSpacing: CGFloat = 12
    
    public var cardShadow: Bool = true
    public var cardCellMargins: UIEdgeInsets = UIEdgeInsets(top: 9.0, left: 12.0, bottom: 12.0, right: 12.0)
    public var cardPartMargins: UIEdgeInsets = UIEdgeInsets(top: 5.0, left: 15.0, bottom: 5.0, right: 15.0)
    
    // CardPartSeparatorView
    public var separatorColor: UIColor = UIColor.color(221, green: 221, blue: 221)
    public var horizontalSeparatorMargins: UIEdgeInsets = UIEdgeInsets(top: 5.0, left: 15.0, bottom: 5.0, right: 15.0)
    
    // CardPartTextView
    public var smallTextFont: UIFont = UIFont(name: "HelveticaNeue", size: CGFloat(10))!
    public var smallTextColor: UIColor = UIColor.color(136, green: 136, blue: 136)
    public var normalTextFont: UIFont = UIFont(name: "HelveticaNeue", size: CGFloat(14))!
    public var normalTextColor: UIColor = UIColor.color(136, green: 136, blue: 136)
    public var titleTextFont: UIFont = UIFont(name: "HelveticaNeue-Medium", size: CGFloat(16))!
    public var titleTextColor: UIColor = UIColor.color(17, green: 17, blue: 17)
    public var headerTextFont: UIFont = UIFont.turboGenericFontBlack(.header)
    public var headerTextColor: UIColor = UIColor.turboCardPartTitleColor
    public var detailTextFont: UIFont = UIFont(name: "HelveticaNeue", size: CGFloat(12))!
    public var detailTextColor: UIColor = UIColor.color(136, green: 136, blue: 136)
    
    // CardPartTitleView
    public var titleFont: UIFont = UIFont(name: "HelveticaNeue-Medium", size: CGFloat(16))!
    public var titleColor: UIColor = UIColor.color(17, green: 17, blue: 17)
    public var titleViewMargins: UIEdgeInsets = UIEdgeInsets(top: 5.0, left: 15.0, bottom: 10.0, right: 15.0)
    
    // CardPartButtonView
    public var buttonTitleFont: UIFont = UIFont(name: "HelveticaNeue", size: CGFloat(17))!
    public var buttonTitleColor: UIColor = UIColor(red: 69.0/255.0, green: 202.0/255.0, blue: 230.0/255.0, alpha: 1.0)
    
    // CardPartBarView
    public var barBackgroundColor: UIColor = UIColor(red: 221.0/255.0, green: 221.0/255.0, blue: 221.0/255.0, alpha: 1.0)
    public var barColor: UIColor = turboHeaderBlueColor
    public var todayLineColor: UIColor = UIColor.Gray8
    public var barHeight: CGFloat = 13.5
    public var roundedCorners: Bool = false
    public var showTodayLine: Bool = true
    
    // CardPartTableView
    public var tableViewMargins: UIEdgeInsets = UIEdgeInsets(top: 0.0, left: 14.0, bottom: 0.0, right: 14.0)
    
    // CardPartTableViewCell and CardPartTitleDescriptionView
    public var leftTitleFont: UIFont = UIFont(name: "HelveticaNeue", size: CGFloat(17))!
    public var leftDescriptionFont: UIFont = UIFont(name: "HelveticaNeue", size: CGFloat(12))!
    public var rightTitleFont: UIFont = UIFont(name: "HelveticaNeue", size: CGFloat(17))!
    public var rightDescriptionFont: UIFont = UIFont(name: "HelveticaNeue", size: CGFloat(12))!
    public var leftTitleColor: UIColor = UIColor.color(17, green: 17, blue: 17)
    public var leftDescriptionColor: UIColor = UIColor.color(169, green: 169, blue: 169)
    public var rightTitleColor: UIColor = UIColor.color(17, green: 17, blue: 17)
    public var rightDescriptionColor: UIColor = UIColor.color(169, green: 169, blue: 169)
    public var secondaryTitlePosition : CardPartSecondaryTitleDescPosition = .right
    
    public init() {
        
    }
}
