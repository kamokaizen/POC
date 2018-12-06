//
//  ProfileFavouriteVC.swift
//  kacagiderim_beta
//
//  Created by kamilinal on 12/6/18.
//  Copyright © 2018 kacagiderim. All rights reserved.
//

import Foundation
import CardParts

class ProfileFavouriteVC: BaseCardPartsViewController {
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
        
        setupCardParts([CardPartsUtil.getTitleView(title: "Favourite Cities"), CardPartSeparatorView()])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
}
