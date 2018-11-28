//
//  CardPartsUtil.swift
//  kacagiderim_beta
//
//  Created by kamilinal on 11/23/18.
//  Copyright © 2018 kacagiderim. All rights reserved.
//

import Foundation
import CardParts
import UIKit

class CardPartsUtil {
    static func titleWithMenu(leftTitleText: String, menu: CardPartTitleView) -> CardPartView{
        let title = CardPartTextView(type: .title)
        title.label.font = CardParts.theme.headerTextFont
        title.label.text = leftTitleText
        
        menu.contentMode = .right
        
        let sv = CardPartStackView()
        sv.spacing = 10
        sv.distribution = .fill
        sv.axis = .horizontal
        sv.addArrangedSubview(title)
        sv.addArrangedSubview(menu)
        return sv
    }

    static func generateCenteredItem(letfLabelText:String, rightLabel: CardPartTextView) -> UIView {
        let leftLabel = CardPartTextView(type: .title)
        leftLabel.textAlignment = .left
        leftLabel.text = letfLabelText
        let item = CardPartCenteredView(leftView: leftLabel, centeredView: CardPartVerticalSeparatorView(), rightView: rightLabel)
        return item as UIView
    }
    
    static func generateCenteredItem(letfLabelText:String, rightLabelText: String) -> UIView {
        let leftLabel = CardPartTextView(type: .title)
        leftLabel.textAlignment = .left
        leftLabel.text = letfLabelText
        let rightLabel = CardPartTextView(type: .normal)
        rightLabel.text = rightLabelText
        let item = CardPartCenteredView(leftView: leftLabel, centeredView: CardPartVerticalSeparatorView(), rightView: rightLabel)
        return item as UIView
    }
    
    static func generateCenteredItemWithTextField(letfLabelText:String, rightTextField: CardPartTextField) -> CardPartView {
        let leftLabel = CardPartTextView(type: .title)
        leftLabel.textAlignment = .left
        leftLabel.text = letfLabelText
        let item = CardPartCenteredView(leftView: leftLabel, centeredView: CardPartVerticalSeparatorView(), rightView: rightTextField)
        return item
    }
    
    static func generateCenteredItemWithSegmentedControl(letfLabelText:String, rightSegmentedControl: UISegmentedControl) -> CardPartView {
        let leftLabel = CardPartTextView(type: .title)
        leftLabel.textAlignment = .left
        leftLabel.text = letfLabelText
        
        let sv = CardPartStackView()
        sv.spacing = 10
        sv.distribution = .fill
        sv.axis = .horizontal
        sv.addArrangedSubview(rightSegmentedControl)
        
        let item = CardPartCenteredView(leftView: leftLabel, centeredView: CardPartVerticalSeparatorView(), rightView: sv)
        return item
    }
}
