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
    let imageCP = CardPartImageView(image: Utils.imageWithImage(image: UIImage(named: "add.png")!, scaledToSize: CGSize(width: 50, height: 50)))
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        //        titleCP.margins = .init(top: 50, left: 20, bottom: 5, right: 30)
        titleCP.font = CardParts.theme.smallTextFont
        
        let stack = CardPartStackView()
        stack.axis = .vertical
        stack.spacing = 5
        stack.distribution = .fillProportionally
        stack.alignment = .center
        stack.addArrangedSubview(titleCP);
        stack.addArrangedSubview(imageCP);
        
        // stack titleCP height = 0.3 x imageCP
        stack.addConstraint(NSLayoutConstraint(item: titleCP, attribute: .height, relatedBy: .equal, toItem:nil , attribute: .height, multiplier: 0, constant: 25.0))
        stack.addConstraint(NSLayoutConstraint(item: imageCP, attribute: .height, relatedBy: .equal, toItem:nil , attribute: .height, multiplier: 0, constant: 50.0))
        
        setupCardParts([stack])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setData(_ data: CommonVehicleProtocol) {
        self.data = data
        titleCP.text = data.getName()
        titleCP.textAlignment = .center
        titleCP.textColor = .black
        
        //        let imageURL = data.imageName ?? ""
        //        // TODO GET IMAGE FROM URL
        //        ImageCache.default.retrieveImage(forKey: imageURL, options: nil) {
        //            image, cacheType in
        //            if let image = image {
        //                print("Get image \(image), cacheType: \(cacheType).")
        //                //In this code snippet, the `cacheType` is .disk
        //                self.imageCP.image = image
        //            } else {
        //                print("Not exist in cache.")
        //                let url = URL(string: imageURL)!
        //                ImageDownloader.default.downloadImage(with: url, options: [], progressBlock: nil) {
        //                    (image, error, url, data) in
        //                    if let image = image {
        //                        ImageCache.default.store(image, forKey: imageURL)
        //                        self.imageCP.image = image
        //                    }
        //                }
        //            }
        //        }
    }
}
