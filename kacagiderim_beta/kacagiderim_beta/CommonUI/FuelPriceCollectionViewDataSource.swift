//
//  FuelPriceCollectionViewDataSource.swift
//  kacagiderim_beta
//
//  Created by kamilinal on 8/11/18.
//  Copyright © 2018 kacagiderim. All rights reserved.
//
import UIKit

class FuelPriceCollectionViewDataSource: NSObject, UICollectionViewDataSource {
    
    var fuelPrices: [FuelPrice]? = []
    var cities: Cities?
    var countries: [Country]? = []
    var citySelectionData: [[String]] = []
    var countryCode: String = ""
    var superViewController: PricesViewController!
    
    func prepareCollectionView(){
        if let data = UserDefaults.standard.value(forKey:"countries") as? Data {
            let countries = try? PropertyListDecoder().decode(Countries.self, from: data)
            self.countries = countries?.countries
        }
        
        if let data = UserDefaults.standard.value(forKey:"userProfile") as? Data {
            let userProfile = try? PropertyListDecoder().decode(User.self, from: data)
            self.countryCode = getCountryCode(countryId: (userProfile?.countryId)!)
            APIClient.getCitiesOfCountry(countryId: (userProfile?.countryId)!, completion:{ result in
                switch result {
                case .success(let citiesResponse):
                    self.cities = citiesResponse.value;
                    var list: [String] = []
                    for city in (self.cities?.cities!)! {
                        list.append(city.cityName!)
                    }
                    self.citySelectionData.removeAll()
                    self.citySelectionData.append(list)
                case .failure(let error):
                    print((error as! CustomError).localizedDescription)
                }
            })
        }
        self.getPrices(countryCode: self.countryCode)
    }
    
    func getPrices(countryCode: String){
        self.fuelPrices?.removeAll()
        var selectedCities = UserDefaults.standard.value(forKeyPath: "selectedCities") as? [String];
        if(selectedCities == nil){
            selectedCities = []
        }
        if(selectedCities!.count > 0){
            for city in selectedCities! {
                APIClient.getFuelPrices(country: countryCode, city: city, completion:{ result in
                    switch result {
                    case .success(let fuelPriceResponse):
                        self.fuelPrices?.append(fuelPriceResponse.value!)
                        self.superViewController.pageControl.numberOfPages = (self.fuelPrices?.count)!
                        self.superViewController.collectionView.reloadData()
                    case .failure(let error):
                        print((error as! CustomError).localizedDescription)
                    }
                })
            }
        }
        else{
            APIClient.getFuelPrices(country: countryCode, city: "", completion:{ result in
                switch result {
                case .success(let fuelPriceResponse):
                    self.fuelPrices?.append(fuelPriceResponse.value!)
                    self.superViewController.pageControl.numberOfPages = (self.fuelPrices?.count)!
                    self.superViewController.collectionView.reloadData()
                case .failure(let error):
                    print((error as! CustomError).localizedDescription)
                }
            })
        }
    }
    
    func getPrice(city: String, country: String){
        var exist = false;
        for fuelPrice in self.fuelPrices! {
            if(city == fuelPrice.fuelPriceItem.cityName){
                exist = true
            }
        }
        if(!exist){
            APIClient.getFuelPrices(country: country, city: city, completion:{ result in
                switch result {
                case .success(let fuelPriceResponse):
                    self.fuelPrices?.append(fuelPriceResponse.value!)
                    self.superViewController.pageControl.numberOfPages = (self.fuelPrices?.count)!
                    self.superViewController.collectionView.reloadData()
                case .failure(let error):
                    print((error as! CustomError).localizedDescription)
                }
            })
        }
    }
    
    func getCountryCode(countryId: String) -> String {
        var countryCode: String = ""
        if(self.countries != nil){
            for country in self.countries! {
                if(country.countryId == countryId){
                    countryCode = country.countryCode!
                    break
                }
            }
        }
        return countryCode
    }
    
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
        
        item.dataSource = self
        item.superViewController = self.superViewController
        item.navigationItem.title = fuelPrice.fuelPriceItem.cityName != nil ? fuelPrice.fuelPriceItem.cityName : fuelPrice.fuelPriceItem.countryName
        item.updateLabel.text = fuelPrice.fuelPriceItem.lstUptTime
        
        item.gasolineLabel.text = String(format: "%.2f",fuelPrice.fuelPriceItem.avgFLPrc)
        item.dieselLabel.text = String(format: "%.2f",fuelPrice.fuelPriceItem.avgDSLPrc)
        item.lpgLabel.text = String(format: "%.2f",fuelPrice.fuelPriceItem.avgLpgPrc)
        item.descriptionLabel.text = "Price metric is \(fuelPrice.fuelPriceItem.cur)/lt"
        
        return item
    }
}
