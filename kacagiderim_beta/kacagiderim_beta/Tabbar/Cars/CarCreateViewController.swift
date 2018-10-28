//
//  CarCreateViewController.swift
//  kacagiderim_beta
//
//  Created by kamilinal on 10/28/18.
//  Copyright © 2018 kacagiderim. All rights reserved.
//

import Foundation
import CardParts
import DCKit

class CarCreateViewController: CardPartsViewController, ShadowCardTrait, RoundedCardTrait {
    weak var viewModel: CarCreateViewModel!
    
    var titlePart = CardPartTitleView(type: .titleOnly)
    var cardPartSeparatorView = CardPartSeparatorView()
    var createVehicleButton = CardPartButtonView()
    
    public init(viewModel: CarCreateViewModel) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
    }
    
    required public init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func shadowColor() -> CGColor {
        return UIColor.lightGray.cgColor
    }
    
    func shadowRadius() -> CGFloat {
        return 10.0
    }
    
    func shadowOpacity() -> Float {
        return 1.0
    }
    
    func cornerRadius() -> CGFloat {
        return 10.0
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createVehicleButton.setTitle("Create New Vehicle", for: .normal)
        createVehicleButton.setImage(Utils.imageWithImage(image: UIImage(named: "add.png")!, scaledToSize: CGSize(width: 50, height: 50)), for: .normal)
        createVehicleButton.addTarget(self, action: #selector(createButtonTapped), for: .touchUpInside)
        createVehicleButton.titleLabel?.font = CardParts.theme.normalTextFont
        createVehicleButton.setTitleColor(UIColor.darkDefault, for: .normal)
        
        createVehicleButton.imageEdgeInsets = UIEdgeInsets(top: 10, left: -20, bottom: 10, right: 0)
        createVehicleButton.imageView?.contentMode = .scaleAspectFit
        createVehicleButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: -20, bottom: 0, right: 0)
        
        setupCardParts([createVehicleButton])
    }
    
    @objc func createButtonTapped() {
        print("create tapped")
    }
}
