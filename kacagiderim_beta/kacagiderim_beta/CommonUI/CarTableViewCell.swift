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
    let usage = CardPartTextView(type: .detail)
    let plate = CardPartTextView(type: .detail)
    let separator = CardPartVerticalSeparatorView()
    var showDetailButton = CardPartButtonView()
    var logoImageView = CardPartImageView()
    var modelImageView = CardPartImageView()
    var stack = CardPartStackView()
    var mainSV = CardPartStackView()
    var defaultLogoImage = Utils.imageWithImage(image: UIImage(named: "car.png")!, scaledToSize: CGSize(width: 20, height: 20))
    var defaultCarImage = Utils.imageWithImage(image: UIImage(named: "default_car.png")!, scaledToSize: CGSize(width: 75, height: 50))
    
    override public init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        
        brand.font = CardParts.theme.titleFont
        brand.textColor = CardParts.theme.buttonTitleColor
        logoImageView.image = defaultLogoImage
        modelImageView.image = defaultCarImage
        
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
        detailStack.alignment = .trailing
        detailStack.axis = .vertical
        detailStack.spacing = 5
        detailStack.distribution = .fill
        detailStack.addArrangedSubview(plate)
        detailStack.addArrangedSubview(usage)
        
        stack.axis = .vertical
        stack.spacing = 5
        stack.distribution = .fill
        stack.addArrangedSubview(imageStack);
        stack.addArrangedSubview(name);
        
        showDetailButton.setImage(Utils.imageWithImage(image: UIImage(named: "forward.png")!, scaledToSize: CGSize(width: 30, height: 30)), for: .normal)
        showDetailButton.addTarget(self, action: #selector(showDetailTapped), for: .touchUpInside)
        
        let modelImageStack = CardPartStackView()
        modelImageStack.axis = .horizontal
        modelImageStack.spacing = 5
        modelImageStack.distribution = .fill
        modelImageStack.alignment = UIStackView.Alignment.center
        modelImageStack.addArrangedSubview(modelImageView)
        
        mainSV.addArrangedSubview(modelImageView)
        mainSV.addArrangedSubview(stack)
        mainSV.addArrangedSubview(detailStack)
//        mainSV.addArrangedSubview(showDetailButton)
        
        imageStack.addConstraint(NSLayoutConstraint(item: logoImageView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 0, constant: 30))
        imageStack.addConstraint(NSLayoutConstraint(item: logoImageView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 0, constant: 30))
        
        mainSV.addConstraint(NSLayoutConstraint(item: modelImageView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 0, constant: 75))
        mainSV.addConstraint(NSLayoutConstraint(item: modelImageView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 0, constant: 50))

        mainSV.addConstraint(NSLayoutConstraint(item: stack, attribute: .width, relatedBy: .equal, toItem: detailStack, attribute: .width, multiplier: 3, constant: 0))
        
        setupCardParts([mainSV])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setData(data: AccountVehicle) {
        self.logoImageView.image = nil
        self.modelImageView.image = defaultCarImage
        self.data = data
        self.brand.text = (data.vehicleBrand ?? "").uppercased()
        self.usage.text = data.vehicleUsage != 0 ? String(data.vehicleUsage!) + " km" : ""
        self.plate.text = data.vehiclePlate?.uppercased()
        self.name.text = data.customVehicle ? data.customVehicleName ?? "" : (data.vehicleDescription ?? "")
        
        ImageManager.getImageFromCloudinary(path: K.Constants.cloudinaryLogoPath + (data.vehicleBrand ?? ""), completion:  { (response) in
            if(response != nil){
                self.logoImageView.image = response
            }
            else{
                self.logoImageView.image = self.defaultLogoImage
            }
        })
        
        ImageManager.getImageFromCloudinary(path: K.Constants.cloudinaryCarPath + (data.vehicleBrand ?? "") + "/thumb/" + (data.vehicleModel ?? ""), completion:  { (response) in
            if(response != nil){
                self.modelImageView.image = response
                self.modelImageView.layer.cornerRadius = 5.0;
                self.modelImageView.clipsToBounds = true;
            }
            else{
                self.modelImageView.image = self.defaultCarImage
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
