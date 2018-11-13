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
    var vehicleButton = CardPartButtonView()
    var vehicleSuvButton = CardPartButtonView()
    var vehicleMinivanButton = CardPartButtonView()
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
        
        vehicleButton.setImage(Utils.imageWithImage(image: UIImage(named: "car.png")!, scaledToSize: CGSize(width: 50, height: 50)), for: .normal)
        vehicleButton.setImage(Utils.imageWithImage(image: UIImage(named: "add.png")!, scaledToSize: CGSize(width: 50, height: 50)), for: .highlighted)
        vehicleButton.addTarget(self, action: #selector(filterBrands), for: .touchUpInside)
        vehicleButton.tag = BrandType.AUTOMOBILE.rawValue
        self.prepareButton(title: "Automobile", button: vehicleButton)
        
        vehicleMinivanButton.setImage(Utils.imageWithImage(image: UIImage(named: "car.png")!, scaledToSize: CGSize(width: 50, height: 50)), for: .normal)
        vehicleMinivanButton.setImage(Utils.imageWithImage(image: UIImage(named: "add.png")!, scaledToSize: CGSize(width: 50, height: 50)), for: .highlighted)
        vehicleMinivanButton.addTarget(self, action: #selector(filterBrands), for: .touchUpInside)
        vehicleMinivanButton.tag = BrandType.MINIVAN.rawValue
        self.prepareButton(title: "Minivan", button: vehicleMinivanButton)
        
        vehicleSuvButton.setImage(Utils.imageWithImage(image: UIImage(named: "car.png")!, scaledToSize: CGSize(width: 50, height: 50)), for: .normal)
        vehicleSuvButton.setImage(Utils.imageWithImage(image: UIImage(named: "add.png")!, scaledToSize: CGSize(width: 50, height: 50)), for: .highlighted)
        vehicleSuvButton.addTarget(self, action: #selector(filterBrands), for: .touchUpInside)
        vehicleSuvButton.tag = BrandType.SUV.rawValue
        self.prepareButton(title: "SUV", button: vehicleSuvButton)
        
        let stack = CardPartStackView()
        stack.axis = .horizontal
        stack.spacing = 10
        stack.distribution = .fillEqually
        stack.addArrangedSubview(vehicleButton)
        stack.addArrangedSubview(vehicleSuvButton)
        stack.addArrangedSubview(vehicleMinivanButton)
        
        setupCardParts([titlePart, cardPartSeparatorView, stack])
    }
    
    func prepareButton(title:String, button: CardPartButtonView) {
        button.setTitleColor(UIColor.grayText, for: UIControl.State.normal)
        button.titleLabel?.font = CardParts.theme.normalTextFont
        button.setTitle(title, for: UIControl.State.normal)
        button.contentHorizontalAlignment = .center
        button.centerImageAndButton(5, imageOnTop: true)
        button.contentEdgeInsets = UIEdgeInsets.init(top: 20, left: 10, bottom: 20, right: 10)
        makeButtonSelected(sender:button, state:false)
    }
    
    func makeButtonSelected(sender: CardPartButtonView, state: Bool){
        if(state){
            sender.layer.borderWidth = 2
            sender.setTitleColor(UIColor.amber, for: UIControl.State.normal)
            sender.layer.borderColor = UIColor(red: 0.93, green: 0, blue: 0, alpha: 1.0).cgColor
        }
        else{
            sender.layer.borderWidth = 1
            sender.setTitleColor(UIColor.grayText, for: UIControl.State.normal)
            sender.layer.borderColor = UIColor(red: 0.93, green: 0.93, blue: 0.95, alpha: 1.0).cgColor
        }
    }
    
    @objc func filterBrands(sender: UIButton) {
        makeButtonSelected(sender: vehicleButton, state:false)
        makeButtonSelected(sender: vehicleSuvButton, state:false)
        makeButtonSelected(sender: vehicleMinivanButton, state:false)
        makeButtonSelected(sender: sender as! CardPartButtonView, state:true)
        viewModel.filterBrands(type: sender.tag)
    }
}
