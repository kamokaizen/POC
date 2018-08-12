//
//  FuelPriceCollectionViewDataSource.swift
//  kacagiderim_beta
//
//  Created by kamilinal on 8/11/18.
//  Copyright © 2018 kacagiderim. All rights reserved.
//
import UIKit

class FuelPriceCollectionViewDataSource: NSObject, UICollectionViewDataSource {
    
    var fuelPrices: [FuelPrice]?
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return fuelPrices?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let item = collectionView
            .dequeueReusableCell(withReuseIdentifier: "fuelPriceCollectionViewCell", for: indexPath) as? FuelPriceCollectionViewCell,
            let prices = fuelPrices else {
                fatalError()
        }
        let fuelPrice = prices[indexPath.item]
        item.titleLabel.text = fuelPrice.fuelPriceItem.cityName != nil ? fuelPrice.fuelPriceItem.cityName : fuelPrice.fuelPriceItem.countryName
        item.gasolineLabel.text = String(format: "%.2f",fuelPrice.fuelPriceItem.avgFLPrc)
        item.dieselLabel.text = String(format: "%.2f",fuelPrice.fuelPriceItem.avgDSLPrc)
        item.lpgLabel.text = String(format: "%.2f",fuelPrice.fuelPriceItem.avgLpgPrc)
        item.updateLabel.text = fuelPrice.fuelPriceItem.lstUptTime
        
        item.gasolineImageView.clipsToBounds = true
        item.gasolineImageView.layer.borderWidth = 3.0;
        item.gasolineImageView.layer.borderColor = UIColor.white.cgColor
        item.gasolineImageView.layer.cornerRadius = 10.0;
        
        item.dieselImageView.clipsToBounds = true
        item.dieselImageView.layer.borderWidth = 3.0;
        item.dieselImageView.layer.borderColor = UIColor.white.cgColor
        item.dieselImageView.layer.cornerRadius = 10.0;
        
        item.lpgImageView.clipsToBounds = true
        item.lpgImageView.layer.borderWidth = 3.0;
        item.lpgImageView.layer.borderColor = UIColor.white.cgColor
        item.lpgImageView.layer.cornerRadius = 10.0;
        return item
    }
}
