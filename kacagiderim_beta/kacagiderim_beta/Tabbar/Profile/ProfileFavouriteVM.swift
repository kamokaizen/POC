//
//  ProfileFavouriteVM.swift
//  kacagiderim_beta
//
//  Created by kamilinal on 12/8/18.
//  Copyright © 2018 kacagiderim. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import CardParts

class ProfileFavouriteVM {
    let state: BehaviorRelay<CardState> = BehaviorRelay(value:.empty)
    let favouriteCities: BehaviorRelay<[City]> = BehaviorRelay(value: [])
    let cities: BehaviorRelay<[City]> = BehaviorRelay(value:[])
    let selectedCityIndex: BehaviorRelay<(row:Int,component:Int)> = BehaviorRelay(value: (0, 0))
    
    init() {

    }
    
    func getSelectedCities(){
        let selectedCities = DefaultManager.getSelectedCities()
        self.favouriteCities.accept(selectedCities)
        self.updateState()
    }
    
    func updateState(){
        self.favouriteCities.value.count > 0 ? self.state.accept(.hasData) : self.state.accept(.empty)
    }
    
    func addSelectedCity(){
        let index = self.selectedCityIndex.value.row
        if(self.cities.value.count < 1){
            print("Cities are empty!!!")
            return
        }
        
        if(index >= self.cities.value.count || index < 0){
            print("Selected index is out of bounds!!!")
            return
        }
        
        var favouriteCities = self.favouriteCities.value
        let selectedItem = self.cities.value[index]
        let existItem = self.favouriteCities.value.first(where: { $0.cityId == selectedItem.cityId })
        if(existItem == nil){
            favouriteCities.append(selectedItem)
            DefaultManager.setSelectedCities(cities: favouriteCities)
            self.favouriteCities.accept(DefaultManager.getSelectedCities())
        }
        self.updateState()
    }
    
    func deleteSelectedCity(index: Int){
        var selectedCities = DefaultManager.getSelectedCities()
        selectedCities.remove(at: index)
        DefaultManager.setSelectedCities(cities: selectedCities)
        self.favouriteCities.accept(selectedCities)
        self.updateState()
    }
    
    func getCities(){
        let user = DefaultManager.getUser()
        
        if(user != nil && user?.countryId != nil){
            let cities = DefaultManager.getCities()
            
            if(cities != nil && cities!.count > 0){
                self.cities.accept(cities!)
                return
            }
            
            APIClient.getCitiesOfCountry(countryId: (user?.countryId)!, completion:{ result in
                switch result {
                case .success(let citiesResponse):
                    DefaultManager.setCities(cities: citiesResponse.value?.cities ?? [])
                    let cities = DefaultManager.getCities() ?? []
                    self.cities.accept(cities)
                    return
                case .failure(let error):
                    print((error as! CustomError).localizedDescription)
                    return
                }
            })
        }
    }
}
