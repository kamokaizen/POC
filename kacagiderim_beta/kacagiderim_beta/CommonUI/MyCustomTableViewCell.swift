//
//  MyCustomViewCell.swift
//  kacagiderim_beta
//
//  Created by kamilinal on 9/3/18.
//  Copyright © 2018 kacagiderim. All rights reserved.
//

import Foundation
import CardParts

class MyCustomTableViewCell: CardPartTableViewCardPartsCell {
        
    let attrHeader1 = CardPartTextView(type: .normal)
    let deleteButton = CardPartButtonView()
    let separator = CardPartVerticalSeparatorView()
    var viewModel:ProfileViewModel?
    
    override public init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        
        deleteButton.setTitle("delete", for: .normal)
        deleteButton.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
        deleteButton.titleLabel?.font = CardParts.theme.normalTextFont
        deleteButton.setTitleColor(K.Constants.kacagiderimColorWarning, for: .normal)
        let centeredView = CardPartCenteredView(leftView: attrHeader1, centeredView: separator, rightView: deleteButton)
        centeredView.margins = UIEdgeInsets(top: 0.0, left: 40.0, bottom: 0.0, right: 15.0)
        setupCardParts([centeredView])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func deleteButtonTapped(){
        print("delete tapped")
        self.viewModel?.deleteCityFromSelectedCities(cityName: self.attrHeader1.text!)
    }
    
    func setData(data: String, viewModel: ProfileViewModel) {
        // Do something in here
        self.attrHeader1.text = data
        self.viewModel = viewModel
    }
}
