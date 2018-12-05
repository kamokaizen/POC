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
import NVActivityIndicatorView

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

    static func getTitleView(title: String) -> CardPartView{
        let titleView = CardPartTextView(type: .title)
        titleView.label.font = CardParts.theme.headerTextFont
        titleView.label.text = title
        return titleView
    }
    
    static func getLoadingView(title: String, text: String) -> [CardPartView]{
        let loadingIndicator = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 100, height: 100), type: K.Constants.default_spinner, color:UIColor.black , padding: 0)
        let loadingTextView = CardPartTextView(type: .normal)
        loadingTextView.text = text
        loadingIndicator.startAnimating()
        let stack = CardPartStackView()
        stack.axis = .vertical
        stack.spacing = 10
        stack.distribution = .equalSpacing
        stack.alignment = UIStackView.Alignment.center
        stack.addArrangedSubview(loadingIndicator);
        stack.addArrangedSubview(loadingTextView);
        return [stack]
    }
    
    static func getFailView(title: String, image: UIImage, text: String) -> [CardPartView] {
        let titlePart = CardPartTitleView(type: .titleOnly)
        titlePart.label.text = title
        
        let imageView = CardPartImageView(image: image)
        imageView.contentMode = .scaleAspectFit;
        let textView = CardPartTextView(type: .normal)
        textView.text = text
        let stack = CardPartStackView()
        stack.axis = .vertical
        stack.spacing = 10
        stack.distribution = .equalSpacing
        stack.alignment = UIStackView.Alignment.center
        stack.addArrangedSubview(imageView);
        stack.addArrangedSubview(textView);
        
        return [titlePart, CardPartSeparatorView(), stack]
    }
    
    static func generateCenteredItem(letfLabelText:String, rightLabel: CardPartTextView) -> UIView {
        let leftLabel = CardPartTextView(type: .title)
        leftLabel.textAlignment = .left
        leftLabel.text = letfLabelText
        let item = CardPartCenteredView(leftView: leftLabel, centeredView: CardPartVerticalSeparatorView(), rightView: rightLabel)
        return item as UIView
    }
    
    static func generateCenteredItem(letfLabelText:String, rightLabelText: String) -> (UIView, CardPartTextView) {
        let leftLabel = CardPartTextView(type: .title)
        leftLabel.textAlignment = .left
        leftLabel.text = letfLabelText
        let rightLabel = CardPartTextView(type: .normal)
        rightLabel.text = rightLabelText
        let item = CardPartCenteredView(leftView: leftLabel, centeredView: CardPartVerticalSeparatorView(), rightView: rightLabel)
        return (item as UIView, rightLabel)
    }
    
    static func generateCenteredItemWithTextField(letfLabelText:String, rightTextField: CardPartTextField) -> CardPartView {
        let leftLabel = CardPartTextView(type: .title)
        leftLabel.textAlignment = .left
        leftLabel.text = letfLabelText
        let item = CardPartCenteredView(leftView: leftLabel, centeredView: CardPartVerticalSeparatorView(), rightView: rightTextField)
        return item
    }
    
    static func generateCenteredItemWithTextField(letfLabelText:String, rightTextFieldPlaceHolder: String) -> (CardPartView, CardPartTextField) {
        let leftLabel = CardPartTextView(type: .title)
        leftLabel.textAlignment = .left
        leftLabel.text = letfLabelText
        let rightTextField = CardPartTextField(format: .none)
        rightTextField.keyboardType = .default
        rightTextField.placeholder = rightTextFieldPlaceHolder
        rightTextField.font = CardParts.theme.normalTextFont
        rightTextField.textColor = CardParts.theme.normalTextColor
        let item = CardPartCenteredView(leftView: leftLabel, centeredView: CardPartVerticalSeparatorView(), rightView: rightTextField)
        return (item, rightTextField)
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
