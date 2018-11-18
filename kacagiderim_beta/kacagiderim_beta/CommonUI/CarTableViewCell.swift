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
    
    let brand = CardPartTextView(type: .normal)
    let name = CardPartTextView(type: .normal)
    let year = CardPartTextView(type: .detail)
    let plate = CardPartTextView(type: .detail)
    let separator = CardPartVerticalSeparatorView()
    var showDetailButton = CardPartButtonView()
    var logoImageView = CardPartImageView()
    var modelImageView = CardPartImageView()
    var stack = CardPartStackView()
    var mainSV = CardPartStackView()
    
    override public init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        
        brand.font = CardParts.theme.titleFont
        brand.textColor = CardParts.theme.buttonTitleColor
        logoImageView.image = Utils.imageWithImage(image: UIImage(named: "car.png")!, scaledToSize: CGSize(width: 20, height: 20))
        modelImageView.image = Utils.imageWithImage(image: UIImage(named: "car.png")!, scaledToSize: CGSize(width: 50, height: 50))
                
        year.textAlignment = .right
        
        mainSV.axis = .horizontal
        mainSV.spacing = 10
        mainSV.distribution = .fill
        
        let imageStack = CardPartStackView()
        imageStack.axis = .horizontal
        imageStack.spacing = 5
        imageStack.distribution = .fill
        imageStack.alignment = UIStackView.Alignment.center
        imageStack.addArrangedSubview(logoImageView)
        imageStack.addArrangedSubview(brand);
        
        let detailStack = CardPartStackView()
        detailStack.axis = .horizontal
        detailStack.spacing = 5
        detailStack.distribution = .fillEqually
        detailStack.alignment = UIStackView.Alignment.center
        detailStack.addArrangedSubview(plate)
        detailStack.addArrangedSubview(year)
        
        stack.axis = .vertical
        stack.spacing = 5
        stack.distribution = .fillEqually
        stack.alignment = UIStackView.Alignment.leading
        stack.addArrangedSubview(imageStack);
        stack.addArrangedSubview(name);
        stack.addArrangedSubview(detailStack);
        
        showDetailButton.setImage(Utils.imageWithImage(image: UIImage(named: "forward.png")!, scaledToSize: CGSize(width: 30, height: 30)), for: .normal)
        showDetailButton.addTarget(self, action: #selector(showDetailTapped), for: .touchUpInside)
        
        let modelImageStack = CardPartStackView()
        modelImageStack.axis = .horizontal
        modelImageStack.spacing = 5
        modelImageStack.distribution = .fill
        modelImageStack.alignment = UIStackView.Alignment.center
        modelImageStack.addArrangedSubview(modelImageView)
        
        mainSV.addArrangedSubview(modelImageStack)
        mainSV.addArrangedSubview(stack)
        mainSV.addArrangedSubview(showDetailButton)
        
        imageStack.addConstraint(NSLayoutConstraint(item: logoImageView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 0, constant: 30))
        imageStack.addConstraint(NSLayoutConstraint(item: logoImageView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 0, constant: 30))
        
        modelImageStack.addConstraint(NSLayoutConstraint(item: modelImageView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 0, constant: 75))
        modelImageStack.addConstraint(NSLayoutConstraint(item: modelImageView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 0, constant: 50))

        setupCardParts([mainSV])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setData(data: AccountVehicle) {
        self.logoImageView.image = nil
        self.modelImageView.image = nil
        self.data = data
        self.brand.text = data.vehicle?.brandImageName?.uppercased()
        self.year.text = data.vehicle != nil ? ((data.vehicle?.startYear!)! + "-" + (data.vehicle?.endYear!)!) : ""
        self.plate.text = data.vehiclePlate?.uppercased()
        self.name.text = data.customVehicle ? data.customVehicleName ?? "" : (data.vehicle != nil ? data.vehicle?.longModelDescription ?? "" : "")
        
        ImageManager.getImageFromCloudinary(path: K.Constants.cloudinaryLogoPath + (data.vehicle?.brandImageName ?? ""), completion:  { (response) in
            if(response != nil){
                self.logoImageView.image = response
            }
        })
        
        ImageManager.getImageFromCloudinary(path: K.Constants.cloudinaryCarPath + (data.vehicle?.brandImageName ?? "") + "/thumb/" + (data.vehicle?.modelImageName ?? ""), completion:  { (response) in
            if(response != nil){
                self.modelImageView.image = response
                self.modelImageView.layer.cornerRadius = 5.0;
                self.modelImageView.clipsToBounds = true;
            }
        })
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
