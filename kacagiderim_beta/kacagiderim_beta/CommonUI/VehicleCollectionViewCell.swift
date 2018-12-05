//
//  VehicleCollectionViewCell.swift
//  kacagiderim_beta
//
//  Created by kamilinal on 11/4/18.
//  Copyright © 2018 kacagiderim. All rights reserved.
//

import Foundation
import RxSwift
import RxDataSources
import RxCocoa
import CardParts

struct VehicleCollectionStruct {
    var items: [Item]
}

extension VehicleCollectionStruct: SectionModelType {
    typealias Item = CommonVehicleProtocol
    
    init(original: VehicleCollectionStruct, items: [Item]) {
        self = original
        self.items = items
    }
}

class VehicleCollectionViewCell: CardPartCollectionViewCardPartsCell {
    let bag = DisposeBag()
    var data: CommonVehicleProtocol? = nil
    let titleCP = CardPartTextView(type: .normal)
    let productionCP = CardPartTextView(type: .normal)
    let imageCP = CardPartImageView()
    var defaultCarImage = Utils.imageWithImage(image: UIImage(named: "default_car.png")!, scaledToSize: CGSize(width: 75, height: 50))
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        //        titleCP.margins = .init(top: 50, left: 20, bottom: 5, right: 30)
        titleCP.font = CardParts.theme.smallTextFont
        productionCP.font = CardParts.theme.smallTextFont
        imageCP.image = defaultCarImage
        
        let stack = CardPartStackView()
        stack.axis = .vertical
        stack.spacing = 5
//        stack.distribution = .fillProportionally
        stack.distribution = .fill
        stack.alignment = .center
        stack.addArrangedSubview(titleCP);
        stack.addArrangedSubview(productionCP);
        stack.addArrangedSubview(imageCP);
        
        // stack titleCP height = 0.3 x imageCP
//        stack.addConstraint(NSLayoutConstraint(item: titleCP, attribute: .height, relatedBy: .equal, toItem:nil , attribute: .height, multiplier: 0, constant: 25.0))
        stack.addConstraint(NSLayoutConstraint(item: imageCP, attribute: .height, relatedBy: .equal, toItem:nil , attribute: .height, multiplier: 0, constant: 50.0))
        
        setupCardParts([stack])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setData(_ data: CommonVehicleProtocol) {
        self.imageCP.image = self.defaultCarImage
        titleCP.text = ""
        productionCP.text = ""
        
        self.data = data
        titleCP.text = data.getName()
        titleCP.textAlignment = .center
        titleCP.textColor = .black
       
        if(data is Detail){
            productionCP.text = data.getDetail()
            productionCP.textAlignment = .center
            productionCP.textColor = .black
        }
        
        if(data is Engine || data is Version || data is Detail){
            self.imageCP.image = Utils.imageWithImage(image: UIImage(named: data.getImagePath())!, scaledToSize: CGSize(width: 50, height: 50))
            return
        }
        
        ImageManager.getImageFromCloudinary(path: data.getImagePath(), completion:  { (response) in
            if(response != nil){
                self.imageCP.image = response
                self.imageCP.layer.cornerRadius = 5.0;
                self.imageCP.clipsToBounds = true;
            }
            else{
                self.imageCP.image = self.defaultCarImage
                self.imageCP.layer.cornerRadius = 5.0;
                self.imageCP.clipsToBounds = true;
            }
        })
    }
}
