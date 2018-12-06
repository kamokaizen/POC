//
//  ProfileVC.swift
//  kacagiderim_beta
//
//  Created by kamilinal on 12/5/18.
//  Copyright © 2018 kacagiderim. All rights reserved.
//

import Foundation
import CardParts
import SwiftEntryKit

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
        
        let usernameItem = CardPartsUtil.generateCenteredItem(letfLabelText: "Username", rightLabelText: "")
        let nameItem = CardPartsUtil.generateCenteredItemWithTextField(letfLabelText: "Name", rightTextFieldPlaceHolder: "Type your name")
        let surnameItem = CardPartsUtil.generateCenteredItemWithTextField(letfLabelText: "Surname", rightTextFieldPlaceHolder: "Type your surname")
        let ssnItem = CardPartsUtil.generateCenteredItemWithTextField(letfLabelText: "Social Security Number", rightTextFieldPlaceHolder: "Type your ssn number")
        let countryItem = CardPartsUtil.generateCenteredItem(letfLabelText:  "Country", rightLabelText: "")
        let userTypeItem = CardPartsUtil.generateCenteredItem(letfLabelText:  "User Type", rightLabelText: "")
        
        let profileLogo = CardPartImageView()
        profileLogo.contentMode = .scaleAspectFit
        viewModel.profileImage.asObservable().bind(to: profileLogo.rx.image).disposed(by: bag)
        
        let loggedOutButton = CardPartButtonView()
        loggedOutButton.contentHorizontalAlignment = .center
        loggedOutButton.setTitle("Log Out", for: .normal)
        loggedOutButton.addTarget(self, action: #selector(logoutButtonTapped), for: .touchUpInside)
        loggedOutButton.titleLabel?.font = CardParts.theme.normalTextFont
        loggedOutButton.setTitleColor(K.Constants.kacagiderimColorWarning, for: .normal)
        loggedOutButton.setImage(Utils.imageWithImage(image: UIImage(named: "logout.png")!, scaledToSize: CGSize(width: 30, height: 30)), for: .normal)
        
        viewModel.username.asObservable().bind(to: usernameItem.1.rx.text).disposed(by: bag)
        viewModel.name.asObservable().bind(to: nameItem.1.rx.text).disposed(by: bag)
        viewModel.surname.asObservable().bind(to: surnameItem.1.rx.text).disposed(by: bag)
        viewModel.ssn.asObservable().bind(to: ssnItem.1.rx.text).disposed(by: bag)
        viewModel.countryName.asObservable().bind(to: countryItem.1.rx.text).disposed(by: bag)
        viewModel.typeText.asObservable().bind(to: userTypeItem.1.rx.text).disposed(by: bag)
        nameItem.1.rx.text.orEmpty.bind(to: viewModel.name).disposed(by: bag)
        surnameItem.1.rx.text.orEmpty.bind(to: viewModel.surname).disposed(by: bag)
        ssnItem.1.rx.text.orEmpty.bind(to: viewModel.ssn).disposed(by: bag)
        
        let mainSVVertical = CardPartStackView()
        mainSVVertical.spacing = 10
        mainSVVertical.distribution = .fill
        mainSVVertical.axis = .vertical
        mainSVVertical.addArrangedSubview(profileLogo)
        mainSVVertical.addArrangedSubview(loggedOutButton)
        mainSVVertical.addArrangedSubview(usernameItem.0)
        mainSVVertical.addArrangedSubview(nameItem.0 as! UIView)
        mainSVVertical.addArrangedSubview(surnameItem.0 as! UIView)
        mainSVVertical.addArrangedSubview(ssnItem.0 as! UIView)
        mainSVVertical.addArrangedSubview(countryItem.0)
        mainSVVertical.addArrangedSubview(userTypeItem.0)
        
        setupCardParts([getTitleStack(title: "Profile"), CardPartSeparatorView(), mainSVVertical])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.getProfileData(forceRefresh: false)
    }
    
    func getTitleStack(title: String) -> CardPartStackView {
        let titleView = CardPartsUtil.getTitleView(title: title)
        
        let moreImage = Utils.imageWithImage(image: UIImage(named: "more.png")!, scaledToSize: CGSize(width: 50, height: 50))
        let moreButton = CardPartButtonView()
        moreButton.contentHorizontalAlignment = .right
        moreButton.setImage(moreImage, for: .normal)
        moreButton.addTarget(self, action: #selector(self.more), for: .touchUpInside)
        
        let sv = CardPartStackView()
        sv.spacing = 1
        sv.distribution = .fill
        sv.alignment = .center
        sv.addArrangedSubview(titleView as! UIView)
        sv.addArrangedSubview(moreButton)
        return sv
    }
    
    @objc func more(sender: UIButton){
        let attributes = Utils.getAttributes(element: EKAttributes.bottomToast,
                                             duration: .infinity,
                                             entryBackground: .gradient(gradient: .init(colors: [EKColor.Netflix.light, EKColor.Netflix.dark], startPoint: .zero, endPoint: CGPoint(x: 1, y: 1))),
                                             screenBackground: .color(color: .dimmedLightBackground),
                                             roundCorners: .all(radius: 25))
        let buttonLabelStyle = EKProperty.LabelStyle(font: MainFont.medium.with(size: 20), color: EKColor.Netflix.dark)
        
        let resetButton = EKProperty.ButtonContent(label: EKProperty.LabelContent(text: "Reset", style: buttonLabelStyle), backgroundColor: .white, highlightedBackgroundColor:  EKColor.Gray.light) {
            SwiftEntryKit.dismiss()
            Utils.delayWithSeconds(0.5, completion: {
                self.viewModel.reset()
            })
        }
        let saveButton = EKProperty.ButtonContent(label: EKProperty.LabelContent(text: "Save", style: buttonLabelStyle), backgroundColor: .white, highlightedBackgroundColor:  EKColor.Gray.light) {
            SwiftEntryKit.dismiss()
            Utils.delayWithSeconds(0.5, completion: {
                self.viewModel.save()
            })
        }
        let refreshButton = EKProperty.ButtonContent(label: EKProperty.LabelContent(text: "Refresh", style: buttonLabelStyle), backgroundColor: .white, highlightedBackgroundColor:  EKColor.Gray.light) {
            SwiftEntryKit.dismiss()
            Utils.delayWithSeconds(0.5, completion: {
                self.viewModel.getProfileData(forceRefresh: true)
            })
        }
        
        Utils.showSelectionPopup(attributes: attributes, title: "Actions", titleColor: .white, description: "Plese select an action from below list", descriptionColor: .white, image: UIImage(named: "ic_success")!, buttons: [resetButton, saveButton, refreshButton])
    }
    
    @objc func logoutButtonTapped() {
        let attributes = Utils.getAttributes(element: EKAttributes.centerFloat,
                                             duration: .infinity,
                                             entryBackground: .color(color: .white),
                                             screenBackground: .color(color: .dimmedLightBackground),
                                             roundCorners: .all(radius: 25))
        
        // Ok Button - Make transition to a new entry when the button is tapped
        let okButtonLabelStyle = EKProperty.LabelStyle(font: MainFont.medium.with(size: 16), color: EKColor.Teal.a600)
        let okButtonLabel = EKProperty.LabelContent(text: "Log out", style: okButtonLabelStyle)
        let okButton = EKProperty.ButtonContent(label: okButtonLabel, backgroundColor: .clear, highlightedBackgroundColor:  EKColor.Teal.a600.withAlphaComponent(0.05)) {
            SwiftEntryKit.dismiss()
            AuthManager.logout()
        }
        
        Utils.showAlertView(attributes: attributes, title: "Confirmation", desc: "Are you sure you want to log out?", textColor: .black, imageName: "logo.png", imagePosition: .left, customButton: okButton)
    }
}
