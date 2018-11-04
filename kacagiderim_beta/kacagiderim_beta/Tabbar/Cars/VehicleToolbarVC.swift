//
//  ToolbarViewController.swift
//  kacagiderim_beta
//
//  Created by Comodo on 2.11.2018.
//  Copyright © 2018 kacagiderim. All rights reserved.
//

import Foundation
import CardParts

class VehicleToolbarVC: CardPartsViewController {
    
    weak  var viewModel: NewVehicleVM!
    
    public init(viewModel: NewVehicleVM) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
    }
    
    required public init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let cancelImage = Utils.imageWithImage(image: UIImage(named: "close.png")!, scaledToSize: CGSize(width: 50, height: 50))
        let cancelPart = CardPartButtonView()
        cancelPart.setImage(cancelImage, for: UIControl.State.normal)
        cancelPart.contentHorizontalAlignment = .left
        cancelPart.addTarget(self.viewModel, action: #selector(self.viewModel.dismissTapped), for: .touchUpInside)
        
        let title = CardPartTitleView(type: .titleOnly)
        title.title = "NEW VEHICLE"
        title.titleColor = K.Constants.kacagiderimColor
        title.titleFont = CardParts.theme.titleFont
        
        let image = Utils.imageWithImage(image: UIImage(named: "search.png")!, scaledToSize: CGSize(width: 50, height: 50))
        let searchButton = CardPartButtonView()
        searchButton.contentHorizontalAlignment = .right
        searchButton.setImage(image, for: UIControl.State.normal)
        searchButton.addTarget(self.viewModel, action: #selector(self.viewModel.search), for: .touchUpInside)
        
        let sv = CardPartStackView()
        sv.spacing = 10
        sv.distribution = .fillEqually
        sv.alignment = .center
        sv.addArrangedSubview(cancelPart)
        sv.addArrangedSubview(title)
        sv.addArrangedSubview(searchButton)
        
        setupCardParts([sv])
    }
}
