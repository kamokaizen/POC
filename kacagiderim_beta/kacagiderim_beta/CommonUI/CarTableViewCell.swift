//
//  CarTableViewCell.swift
//  kacagiderim_beta
//
//  Created by kamilinal on 10/28/18.
//  Copyright © 2018 kacagiderim. All rights reserved.
//

import Foundation
import CardParts

class CarTableViewCell: CardPartTableViewCardPartsCell {
    
    var rootDelegate:TableViewDetailClick? = nil
    var data :AccountVehicle? = nil
    
    let name = CardPartTextView(type: .normal)
    let plate = CardPartTextView(type: .detail)
    let separator = CardPartVerticalSeparatorView()
    var showDetailButton = CardPartButtonView()
    var carImageView = CardPartImageView()
    var stack = CardPartStackView()
    var mainSV = CardPartStackView()
    
    override public init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        mainSV.axis = .horizontal
        mainSV.spacing = 10
        mainSV.distribution = .fillProportionally
        
        stack.axis = .vertical
        stack.spacing = 5
        stack.distribution = .fill
        stack.alignment = UIStackView.Alignment.top
        stack.addArrangedSubview(name);
        stack.addArrangedSubview(plate);
        
        carImageView.image = Utils.imageWithImage(image: UIImage(named: "car.png")!, scaledToSize: CGSize(width: 50, height: 50))
        showDetailButton.setImage(Utils.imageWithImage(image: UIImage(named: "ic_info_outline.png")!, scaledToSize: CGSize(width: 30, height: 30)), for: .normal)
        showDetailButton.addTarget(self, action: #selector(showDetailTapped), for: .touchUpInside)
        
        mainSV.addArrangedSubview(carImageView)
        mainSV.addArrangedSubview(stack)
        mainSV.addArrangedSubview(showDetailButton)
        mainSV.margins = UIEdgeInsets(top: 2.0, left: 25.0, bottom: 2.0, right: 30.0)
        
        // stack width = 5 x carImageView
        mainSV.addConstraint(NSLayoutConstraint(item: carImageView, attribute: .width, relatedBy: .equal, toItem: stack, attribute: .width, multiplier: 0.3, constant: 0.0))
        // stack width = 10 x carImageView
        mainSV.addConstraint(NSLayoutConstraint(item: showDetailButton, attribute: .width, relatedBy: .equal, toItem: stack, attribute: .width, multiplier: 0.1, constant: 0.0))
        
        setupCardParts([mainSV])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setData(data: AccountVehicle) {
        self.data = data
        self.plate.text = data.vehiclePlate
        if(data.customVehicle == true){
            self.name.text = data.customVehicleName
        }
        else{
            self.name.text = "\(data.vehicle.brandName ?? "") \(data.vehicle.longModelDescription ?? "")"
        }
    }
    
    
    func setRoot(delegate: TableViewDetailClick){
        self.rootDelegate = delegate
    }
    
    @objc func showDetailTapped() {
        print("show detail tapped")
        if((self.rootDelegate) != nil){
            self.rootDelegate!.didDetailButtonClicked(item: self.data!)
        }
    }
}
