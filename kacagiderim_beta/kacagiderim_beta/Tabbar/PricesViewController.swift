//
//  FuelPricesViewController.swift
//  kacagiderim_beta
//
//  Created by Comodo on 16.07.2018.
//  Copyright © 2018 kacagiderim. All rights reserved.
//

import UIKit
import McPicker

class PricesViewController: UIViewController, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate {
    
    @IBOutlet var pageControl: UIPageControl!
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var addButton: UIButton!
    
//    var cities: Cities?
//    var countries: [Country]?
//    var citySelectionData: [[String]] = []
//    var fuelPrices: [FuelPrice]? = []
//    var countryCode: String = ""
    var messageHelper = MessageHelper()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        (self.collectionView.dataSource as? FuelPriceCollectionViewDataSource)?.superViewController = self
        (self.collectionView.dataSource as? FuelPriceCollectionViewDataSource)?.prepareCollectionView()
        
//        if let data = UserDefaults.standard.value(forKey:"countries") as? Data {
//            let countries = try? PropertyListDecoder().decode(Countries.self, from: data)
//            self.countries = countries?.countries
//        }
//
//        if let data = UserDefaults.standard.value(forKey:"userProfile") as? Data {
//            let userProfile = try? PropertyListDecoder().decode(User.self, from: data)
//            self.countryCode = getCountryCode(countryId: (userProfile?.countryId)!)
//            APIClient.getCitiesOfCountry(countryId: (userProfile?.countryId)!, completion:{ result in
//                switch result {
//                case .success(let citiesResponse):
//                    self.cities = citiesResponse.value;
//                    var list: [String] = []
//                    for city in (self.cities?.cities!)! {
//                        list.append(city.cityName!)
//                    }
//                    self.citySelectionData.removeAll()
//                    self.citySelectionData.append(list)
//                case .failure(let error):
//                    self.messageHelper.showErrorMessage(text: (error as! CustomError).localizedDescription, view:self.view)
//                }
//            })
//        }
//        self.getPrices(countryCode: self.countryCode)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    func getCountryCode(countryId: String) -> String {
//        var countryCode: String = ""
//        if(self.countries != nil){
//            for country in self.countries! {
//                if(country.countryId == countryId){
//                    countryCode = country.countryCode!
//                    break
//                }
//            }
//        }
//        return countryCode
//    }
//
//    func getPrices(countryCode: String){
//        self.fuelPrices?.removeAll()
//        var selectedCities = UserDefaults.standard.value(forKeyPath: "selectedCities") as? [String];
//        if(selectedCities == nil){
//            selectedCities = []
//        }
//        if(selectedCities!.count > 0){
//            for city in selectedCities! {
//                APIClient.getFuelPrices(country: countryCode, city: city, completion:{ result in
//                    switch result {
//                    case .success(let fuelPriceResponse):
//                        self.fuelPrices?.append(fuelPriceResponse.value!)
//                        (self.collectionView.dataSource as? FuelPriceCollectionViewDataSource)?.fuelPrices = self.fuelPrices
//                        self.pageControl.numberOfPages = (self.fuelPrices?.count)!
//                        self.collectionView.reloadData()
//                    case .failure(let error):
//                        self.messageHelper.showErrorMessage(text: (error as! CustomError).localizedDescription, view:self.view)
//                    }
//                })
//            }
//        }
//        else{
//            APIClient.getFuelPrices(country: countryCode, city: "", completion:{ result in
//                switch result {
//                case .success(let fuelPriceResponse):
//                    self.fuelPrices?.append(fuelPriceResponse.value!)
//                    (self.collectionView.dataSource as? FuelPriceCollectionViewDataSource)?.fuelPrices = self.fuelPrices
//                    self.pageControl.numberOfPages = (self.fuelPrices?.count)!
//                    self.collectionView.reloadData()
//                case .failure(let error):
//                    self.messageHelper.showErrorMessage(text: (error as! CustomError).localizedDescription, view:self.view)
//                }
//            })
//        }
//    }
//
//    func getPrice(city: String, country: String){
//        var exist = false;
//        for fuelPrice in self.fuelPrices! {
//            if(city == fuelPrice.fuelPriceItem.cityName){
//                exist = true
//            }
//        }
//        if(!exist){
//            APIClient.getFuelPrices(country: country, city: city, completion:{ result in
//                switch result {
//                case .success(let fuelPriceResponse):
//                    self.fuelPrices?.append(fuelPriceResponse.value!)
//                    (self.collectionView.dataSource as? FuelPriceCollectionViewDataSource)?.fuelPrices = self.fuelPrices
//                    self.pageControl.numberOfPages = (self.fuelPrices?.count)!
//                    self.collectionView.reloadData()
//                case .failure(let error):
//                    self.messageHelper.showErrorMessage(text: (error as! CustomError).localizedDescription, view:self.view)
//                }
//            })
//        }
//    }
    
    // MARK: Collection View Delegate Flow Layout
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.bounds.size
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        
        if collectionView == pageControl {
            
            let inset = (self.pageControl.bounds.width - self.pageControl.size(forNumberOfPages: self.pageControl.numberOfPages).width)/2
            return UIEdgeInsets(top: 0, left: inset, bottom: 0, right: inset)
        }
        return .zero
    }
    
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        pageControl.numberOfPages = count
//        pageControl.isHidden = !(count > 1)
//        return count
//    }
    
    // MARK: ScrollView Delegate Methods
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        pageControl?.currentPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        pageControl?.currentPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
    }
    
//    @IBAction func addButtonTapped(sender: UIButton) {
//        let mcPicker = McPicker(data: self.citySelectionData)
//        let fixedSpace = McPickerBarButtonItem.fixedSpace(width: 20.0)
//        let flexibleSpace = McPickerBarButtonItem.flexibleSpace()
//        let fireButton = McPickerBarButtonItem.done(mcPicker: mcPicker, title: "Ok") // Set custom Text
//        let cancelButton = McPickerBarButtonItem.cancel(mcPicker: mcPicker, barButtonSystemItem: .cancel) // or system items
//        // Set custom toolbar items
//        mcPicker.setToolbarItems(items: [fixedSpace, cancelButton, flexibleSpace, fireButton, fixedSpace])
//
//        mcPicker.showAsPopover(fromViewController: self, sourceView: sender, cancelHandler: {
//                print("cancelled")
//            }, doneHandler: { (selections: [Int : String]) -> Void in
//            if let name = selections[0] {
//                print("Selected:" + name)
//                var selectedCities = UserDefaults.standard.value(forKeyPath: "selectedCities") as? [String];
//                if(selectedCities == nil){
//                    selectedCities = []
//                }
//                selectedCities!.append(name)
//                selectedCities = Array(Set(selectedCities!))
//                print(selectedCities!)
//                UserDefaults.standard.set(selectedCities, forKey: "selectedCities");
//                self.getPrice(city:name, country: self.countryCode)
//            }})
//    }
}
