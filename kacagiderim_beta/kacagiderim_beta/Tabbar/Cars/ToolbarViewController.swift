//
//  ToolbarViewController.swift
//  kacagiderim_beta
//
//  Created by Comodo on 2.11.2018.
//  Copyright © 2018 kacagiderim. All rights reserved.
//

import Foundation
import CardParts

class Toolbar: CardPartsViewController {
    
    public init() {
        super.init(nibName: nil, bundle: nil)
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
        cancelPart.addTarget(self, action: #selector(dismissTapped), for: .touchUpInside)
        
        let title = CardPartTitleView(type: .titleOnly)
        title.title = "NEW VEHICLE"
        title.titleColor = K.Constants.kacagiderimColor
        title.titleFont = CardParts.theme.titleFont
        
        let image = Utils.imageWithImage(image: UIImage(named: "search.png")!, scaledToSize: CGSize(width: 50, height: 50))
        let searchButton = CardPartButtonView()
        searchButton.contentHorizontalAlignment = .right
        searchButton.setImage(image, for: UIControl.State.normal)
        searchButton.addTarget(self, action: #selector(search), for: .touchUpInside)
        
        let sv = CardPartStackView()
        sv.spacing = 10
        sv.distribution = .fillEqually
        sv.alignment = .center
        sv.addArrangedSubview(cancelPart)
        sv.addArrangedSubview(title)
        sv.addArrangedSubview(searchButton)
        
        setupCardParts([sv])
    }
    
    @objc func dismissTapped(sender: UIButton) {
        self.dismiss(animated: true, completion: {})
    }
    
    @objc func search(sender: UIButton) {
        self.dismiss(animated: true, completion: {})
    }
}
