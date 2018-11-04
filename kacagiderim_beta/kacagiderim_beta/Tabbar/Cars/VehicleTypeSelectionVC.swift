//
//  BrandSelectionViewController.swift
//  kacagiderim_beta
//
//  Created by Comodo on 2.11.2018.
//  Copyright © 2018 kacagiderim. All rights reserved.
//

import Foundation
import CardParts
import RxDataSources

class VehicleTypeSelectionVC: CardPartsViewController {
    
    var titlePart = CardPartTitleView(type: .titleOnly)
    var cardPartSeparatorView = CardPartSeparatorView()
    weak var viewModel: NewVehicleVM!
    
    public init(viewModel: NewVehicleVM) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
    }
    
    required public init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titlePart.label.text = "Choose Vehicle Type"
        
        let vehicleButton = CardPartButtonView()
        vehicleButton.setImage(Utils.imageWithImage(image: UIImage(named: "car.png")!, scaledToSize: CGSize(width: 50, height: 50)), for: .normal)
        vehicleButton.setImage(Utils.imageWithImage(image: UIImage(named: "add.png")!, scaledToSize: CGSize(width: 50, height: 50)), for: .highlighted)
        vehicleButton.addTarget(self, action: #selector(filterBrands), for: .touchUpInside)
        vehicleButton.tag = BrandType.AUTOMOBILE.rawValue
        
        let vehicleButtonTitle = CardPartTitleView(type: .titleOnly)
        vehicleButtonTitle.title = "Automobile"
        vehicleButtonTitle.titleColor = K.Constants.kacagiderimColor
        vehicleButtonTitle.titleFont = CardParts.theme.normalTextFont
        
        let stackVehicle = CardPartStackView()
        stackVehicle.axis = .vertical
        stackVehicle.spacing = 10
        stackVehicle.distribution = .fillProportionally
        stackVehicle.alignment = .center
        stackVehicle.addArrangedSubview(vehicleButton);
        stackVehicle.addArrangedSubview(vehicleButtonTitle);
        
        let vehicleMinivanButton = CardPartButtonView()
        vehicleMinivanButton.setImage(Utils.imageWithImage(image: UIImage(named: "car.png")!, scaledToSize: CGSize(width: 50, height: 50)), for: .normal)
        vehicleMinivanButton.setImage(Utils.imageWithImage(image: UIImage(named: "add.png")!, scaledToSize: CGSize(width: 50, height: 50)), for: .highlighted)
        vehicleMinivanButton.addTarget(self, action: #selector(filterBrands), for: .touchUpInside)
        vehicleMinivanButton.tag = BrandType.MINIVAN.rawValue
        
        let vehicleMinivanButtonTitle = CardPartTitleView(type: .titleOnly)
        vehicleMinivanButtonTitle.title = "Minivan"
        vehicleMinivanButtonTitle.titleColor = K.Constants.kacagiderimColor
        vehicleMinivanButtonTitle.titleFont = CardParts.theme.normalTextFont
        
        let stackMinivanVehicle = CardPartStackView()
        stackMinivanVehicle.axis = .vertical
        stackMinivanVehicle.spacing = 10
        stackMinivanVehicle.distribution = .fillProportionally
        stackMinivanVehicle.alignment = .center
        stackMinivanVehicle.addArrangedSubview(vehicleMinivanButton);
        stackMinivanVehicle.addArrangedSubview(vehicleMinivanButtonTitle);
        
        let vehicleSuvButton = CardPartButtonView()
        vehicleSuvButton.setImage(Utils.imageWithImage(image: UIImage(named: "car.png")!, scaledToSize: CGSize(width: 50, height: 50)), for: .normal)
        vehicleSuvButton.setImage(Utils.imageWithImage(image: UIImage(named: "add.png")!, scaledToSize: CGSize(width: 50, height: 50)), for: .highlighted)
        vehicleSuvButton.addTarget(self, action: #selector(filterBrands), for: .touchUpInside)
        vehicleSuvButton.tag = BrandType.SUV.rawValue
        
        let vehicleSuvButtonTitle = CardPartTitleView(type: .titleOnly)
        vehicleSuvButtonTitle.title = "SUV"
        vehicleSuvButtonTitle.titleColor = K.Constants.kacagiderimColor
        vehicleSuvButtonTitle.titleFont = CardParts.theme.normalTextFont
        
        let stackSuvVehicle = CardPartStackView()
        stackSuvVehicle.axis = .vertical
        stackSuvVehicle.spacing = 10
        stackSuvVehicle.distribution = .fillProportionally
        stackSuvVehicle.alignment = .center
        stackSuvVehicle.addArrangedSubview(vehicleSuvButton);
        stackSuvVehicle.addArrangedSubview(vehicleSuvButtonTitle);
        
        let stack = CardPartStackView()
        stack.axis = .horizontal
        stack.spacing = 10
        stack.distribution = .fillEqually
        stack.addArrangedSubview(stackVehicle)
        stack.addArrangedSubview(stackMinivanVehicle)
        stack.addArrangedSubview(stackSuvVehicle)
        
        setupCardParts([titlePart, cardPartSeparatorView, stack])
    }
    
    @objc func filterBrands(sender: UIButton) {
        viewModel.filterBrands(type: sender.tag)
    }
}
