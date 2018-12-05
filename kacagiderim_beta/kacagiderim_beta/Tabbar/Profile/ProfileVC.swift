//
//  ProfileVC.swift
//  kacagiderim_beta
//
//  Created by kamilinal on 12/5/18.
//  Copyright © 2018 kacagiderim. All rights reserved.
//

import Foundation
import CardParts

class ProfileVC: BaseCardPartsViewController {
    weak var viewModel: ProfileVM!
    
    public init(viewModel: ProfileVM) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
    }
    
    required public init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let titlePart = CardPartTextView(type: .title)
        titlePart.label.font = CardParts.theme.headerTextFont
        titlePart.label.text = "Profile"
        
        let mainSVVertical = CardPartStackView()
        mainSVVertical.spacing = 10
        mainSVVertical.distribution = .fill
        mainSVVertical.axis = .vertical
        
        let usernameItem = CardPartsUtil.generateCenteredItemWithTextField(letfLabelText: "Username", rightTextFieldPlaceHolder: "Type your username")
        let nameItem = CardPartsUtil.generateCenteredItemWithTextField(letfLabelText: "Name", rightTextFieldPlaceHolder: "Type your name")
        let surnameItem = CardPartsUtil.generateCenteredItemWithTextField(letfLabelText: "Surname", rightTextFieldPlaceHolder: "Type your surname")
        let ssnItem = CardPartsUtil.generateCenteredItemWithTextField(letfLabelText: "Social Security Number", rightTextFieldPlaceHolder: "Type your ssn number")
//        let countryItem = CardPartsUtil.generateCenteredItemWithTextField(letfLabelText: "Country", rightTextFieldPlaceHolder: "Type your username")
        
        viewModel.username.asObservable().bind(to: usernameItem.1.rx.text).disposed(by: bag)
        viewModel.name.asObservable().bind(to: nameItem.1.rx.text).disposed(by: bag)
        viewModel.surname.asObservable().bind(to: surnameItem.1.rx.text).disposed(by: bag)
        viewModel.ssn.asObservable().bind(to: ssnItem.1.rx.text).disposed(by: bag)
        usernameItem.1.rx.text.orEmpty.bind(to: viewModel.username).disposed(by: bag)
        nameItem.1.rx.text.orEmpty.bind(to: viewModel.name).disposed(by: bag)
        surnameItem.1.rx.text.orEmpty.bind(to: viewModel.surname).disposed(by: bag)
        ssnItem.1.rx.text.orEmpty.bind(to: viewModel.ssn).disposed(by: bag)
        
        mainSVVertical.addArrangedSubview(usernameItem.0 as! UIView)
        mainSVVertical.addArrangedSubview(nameItem.0 as! UIView)
        mainSVVertical.addArrangedSubview(surnameItem.0 as! UIView)
        mainSVVertical.addArrangedSubview(ssnItem.0 as! UIView)
//        mainSVVertical.addArrangedSubview(countryItem as! UIView)
        
        setupCardParts([titlePart, CardPartSeparatorView(), mainSVVertical])
    }
}
