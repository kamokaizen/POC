//
//  FuelPriceCollectionViewCell.swift
//  kacagiderim_beta
//
//  Created by kamilinal on 8/11/18.
//  Copyright © 2018 kacagiderim. All rights reserved.
//

import UIKit
import McPicker

final class FuelPriceCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var navigationItem: UINavigationItem!
    @IBOutlet weak var addButton: UIBarButtonItem!
    @IBOutlet weak var trashButton: UIBarButtonItem!
    @IBOutlet weak var updateLabel: UILabel!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var gasolineLabel: UILabel!
    @IBOutlet weak var dieselLabel: UILabel!
    @IBOutlet weak var lpgLabel: UILabel!
        
    var superViewController:PricesViewController!
    var dataSource:FuelPriceCollectionViewDataSource!
    
    @IBAction func addButtonTapped(sender: UIBarButtonItem) {
        let mcPicker = McPicker(data: self.dataSource.citySelectionData)
        let fixedSpace = McPickerBarButtonItem.fixedSpace(width: 20.0)
        let flexibleSpace = McPickerBarButtonItem.flexibleSpace()
        let fireButton = McPickerBarButtonItem.done(mcPicker: mcPicker, title: "Ok") // Set custom Text
        let cancelButton = McPickerBarButtonItem.cancel(mcPicker: mcPicker, barButtonSystemItem: .cancel) // or system items
        // Set custom toolbar items
        mcPicker.setToolbarItems(items: [fixedSpace, cancelButton, flexibleSpace, fireButton, fixedSpace])
        
        mcPicker.showAsPopover(fromViewController: self.superViewController, sourceView: sender.value(forKey: "view") as? UIView, cancelHandler: {
            print("cancelled")
        }, doneHandler: { (selections: [Int : String]) -> Void in
            if let name = selections[0] {
                print("Selected:" + name)
                var selectedCities = UserDefaults.standard.value(forKeyPath: "selectedCities") as? [String];
                if(selectedCities == nil){
                    selectedCities = []
                }
                selectedCities!.append(name)
                selectedCities = Array(Set(selectedCities!))
                print(selectedCities!)
                UserDefaults.standard.set(selectedCities, forKey: "selectedCities");
                self.dataSource.getPrice(city:name, country: self.dataSource.countryCode)
            }})
    }
    
    @IBAction func deleteButtonTapped(sender: UIBarButtonItem) {
        if(self.dataSource.fuelPrices != nil){
            for (index, fuelPrice) in self.dataSource.fuelPrices!.enumerated() {
                if(fuelPrice.fuelPriceItem.cityName == self.navigationItem.title){
                    print("will be deleted", self.navigationItem.title!)
                    self.dataSource.fuelPrices?.remove(at: index);
                    
                    // remove from userdefaults
                    var selectedCities = UserDefaults.standard.value(forKeyPath: "selectedCities") as? [String];
                    if(selectedCities == nil){
                        selectedCities = []
                    }
                    if let indexInSelectedCities = selectedCities!.index(of:self.navigationItem.title!) {
                        selectedCities!.remove(at: indexInSelectedCities)
                    }
                    print(selectedCities!)
                    UserDefaults.standard.set(selectedCities, forKey: "selectedCities");
                    
                    break
                }
            }
            self.superViewController.pageControl.numberOfPages = (self.dataSource.fuelPrices?.count)!
            self.superViewController.collectionView.reloadData()
        }
    }
}
