//
//  ProfileLocationVC.swift
//  kacagiderim_beta
//
//  Created by kamilinal on 12/6/18.
//  Copyright © 2018 kacagiderim. All rights reserved.
//

import Foundation
import CardParts
import GoogleMaps

class ProfileLocationVC: BaseCardPartsViewController {
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
        
        let homeImageView = CardPartImageView(image: Utils.imageWithImage(image: UIImage(named: "home.png")!, scaledToSize: CGSize(width: 50, height: 50)))
        let workImageView = CardPartImageView(image: Utils.imageWithImage(image: UIImage(named: "office.png")!, scaledToSize: CGSize(width: 50, height: 50)))
        
//        let homeLatLocationItem = CardPartsUtil.generateCenteredItem(letfLabelText:  "Home Lat", rightLabelText: "")
//        let homeLonLocationItem = CardPartsUtil.generateCenteredItem(letfLabelText:  "Home Lon", rightLabelText: "")
//
//        let workLatLocationItem = CardPartsUtil.generateCenteredItem(letfLabelText:  "Work Lat", rightLabelText: "")
//        let workLonLocationItem = CardPartsUtil.generateCenteredItem(letfLabelText:  "Work Lon", rightLabelText: "")
        
        let homeLocationItem = CardPartsUtil.generateCenteredItemWithButton(letfLabelText: "Home", rightButton: getButton() as! CardPartButtonView)
        let workLocationItem = CardPartsUtil.generateCenteredItemWithButton(letfLabelText: "Work", rightButton: getButton() as! CardPartButtonView)
        
//        let homeInnerSV = CardPartStackView()
//        homeInnerSV.spacing = 5
//        homeInnerSV.distribution = .fill
//        homeInnerSV.axis = .vertical
//        homeInnerSV.addArrangedSubview(homeLatLocationItem.0)
//        homeInnerSV.addArrangedSubview(homeLonLocationItem.0)
        
        let homeSVHorizontal = CardPartStackView()
        homeSVHorizontal.spacing = 5
        homeSVHorizontal.distribution = .fillProportionally
        homeSVHorizontal.axis = .horizontal
        homeSVHorizontal.addArrangedSubview(homeImageView)
        homeSVHorizontal.addArrangedSubview(homeLocationItem.0)
        
//        let workInnerSV = CardPartStackView()
//        workInnerSV.spacing = 5
//        workInnerSV.distribution = .fill
//        workInnerSV.axis = .vertical
//        workInnerSV.addArrangedSubview(workLatLocationItem.0)
//        workInnerSV.addArrangedSubview(workLonLocationItem.0)
        
        let workSVHorizontal = CardPartStackView()
        workSVHorizontal.spacing = 5
        workSVHorizontal.distribution = .fillProportionally
        workSVHorizontal.axis = .horizontal
        workSVHorizontal.addArrangedSubview(workImageView)
        workSVHorizontal.addArrangedSubview(workLocationItem.0)
        
        let mainSVVertical = CardPartStackView()
        mainSVVertical.spacing = 10
        mainSVVertical.distribution = .fill
        mainSVVertical.axis = .vertical
        mainSVVertical.addArrangedSubview(homeSVHorizontal)
        mainSVVertical.addArrangedSubview(CardPartSeparatorView())
        mainSVVertical.addArrangedSubview(workSVHorizontal)
        
//        viewModel.homeLatitude.asObservable().bind(to: homeLatLocationItem.1.rx.text).disposed(by: bag)
//        viewModel.homeLongitude.asObservable().bind(to: homeLonLocationItem.1.rx.text).disposed(by: bag)
//        viewModel.workLatitude.asObservable().bind(to: workLatLocationItem.1.rx.text).disposed(by: bag)
//        viewModel.workLongitude.asObservable().bind(to: workLonLocationItem.1.rx.text).disposed(by: bag)
        
        viewModel.homeLocationConfigured.asObservable().map({$0 == true ? "Configured" : "Not Configured"}).bind(to: homeLocationItem.1.rx.title()).disposed(by: bag)
        viewModel.workLocationConfigured.asObservable().map({$0 == true ? "Configured" : "Not Configured"}).bind(to: workLocationItem.1.rx.title()).disposed(by: bag)
        
        homeSVHorizontal.addConstraint(NSLayoutConstraint(item: homeImageView, attribute: .height, relatedBy: .equal, toItem:nil , attribute: .height, multiplier: 0, constant: 50.0))
        homeSVHorizontal.addConstraint(NSLayoutConstraint(item: homeImageView, attribute: .width, relatedBy: .equal, toItem:nil , attribute: .width, multiplier: 0, constant: 50.0))
        workSVHorizontal.addConstraint(NSLayoutConstraint(item: workImageView, attribute: .height, relatedBy: .equal, toItem:nil , attribute: .height, multiplier: 0, constant: 50.0))
        workSVHorizontal.addConstraint(NSLayoutConstraint(item: workImageView, attribute: .width, relatedBy: .equal, toItem:nil , attribute: .width, multiplier: 0, constant: 50.0))
        
        setupCardParts([CardPartsUtil.getTitleView(title: "Locations"), CardPartSeparatorView(), mainSVVertical])
    }
    
    func getButton() -> CardPartView {
        let button = CardPartButtonView()
        button.contentHorizontalAlignment = .center
//        button.setTitle("Configure", for: UIControl.State.normal)
//        button.setImage(Utils.imageWithImage(image: UIImage(named: "add.png")!, scaledToSize: CGSize(width: 50, height: 50)), for: UIControl.State.normal)
        button.addTarget(self, action: #selector(configureTapped), for: .touchUpInside)
        return button
    }
    
    @objc func configureTapped(sender: UIButton){
        let homePosition = CLLocationCoordinate2D(latitude: Double(self.viewModel.homeLatitude.value) ?? 0, longitude: Double(self.viewModel.homeLongitude.value) ?? 0)
        let workPosition = CLLocationCoordinate2D(latitude: Double(self.viewModel.workLatitude.value) ?? 0, longitude: Double(self.viewModel.workLongitude.value) ?? 0)
        
        let vm = ProfileLocationSelectorVM(homePosition: homePosition, workPosition: workPosition)
        let vc = ProfileLocationSelectorVC(viewModel: vm)
        self.present(vc, animated: true, completion: {})
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
}
