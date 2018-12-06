//
//  ProfileMetricsVC.swift
//  kacagiderim_beta
//
//  Created by kamilinal on 12/6/18.
//  Copyright © 2018 kacagiderim. All rights reserved.
//

import Foundation
import CardParts

class ProfileMetricsVC: BaseCardPartsViewController {
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
        
        let currencySC = UISegmentedControl(items: ["Lira","Euro","Dollar"])
        let distanceSC = UISegmentedControl(items: ["Km","Meter","Mile"])
        let volumeSC = UISegmentedControl(items: ["Liter", "Gallon"])
        
        let currencyItem = CardPartsUtil.generateCenteredItemWithSegmentedControl(letfLabelText: "Currency", rightSegmentedControl: currencySC)
        let distanceItem = CardPartsUtil.generateCenteredItemWithSegmentedControl(letfLabelText: "Distance", rightSegmentedControl: distanceSC)
        let volumeItem = CardPartsUtil.generateCenteredItemWithSegmentedControl(letfLabelText: "Volume", rightSegmentedControl: volumeSC)
        
        
        viewModel.currencyIndex.asObservable().bind(to: currencySC.rx.selectedSegmentIndex).disposed(by: bag)
        viewModel.distanceIndex.asObservable().bind(to: distanceSC.rx.selectedSegmentIndex).disposed(by: bag)
        viewModel.volumeIndex.asObservable().bind(to: volumeSC.rx.selectedSegmentIndex).disposed(by: bag)
        currencySC.rx.selectedSegmentIndex.bind(to: viewModel.currencyIndex).disposed(by: bag)
        distanceSC.rx.selectedSegmentIndex.bind(to: viewModel.distanceIndex).disposed(by: bag)
        volumeSC.rx.selectedSegmentIndex.bind(to: viewModel.volumeIndex).disposed(by: bag)
        
        let mainSVVertical = CardPartStackView()
        mainSVVertical.spacing = 10
        mainSVVertical.distribution = .fill
        mainSVVertical.axis = .vertical
        mainSVVertical.addArrangedSubview(currencyItem as! UIView)
        mainSVVertical.addArrangedSubview(distanceItem as! UIView)
        mainSVVertical.addArrangedSubview(volumeItem as! UIView)
        
        setupCardParts([CardPartsUtil.getTitleView(title: "Metrics"), CardPartSeparatorView(), mainSVVertical])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
}
