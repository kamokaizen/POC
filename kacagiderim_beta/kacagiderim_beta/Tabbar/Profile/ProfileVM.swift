//
//  ProfileVM.swift
//  kacagiderim_beta
//
//  Created by kamilinal on 12/5/18.
//  Copyright © 2018 kacagiderim. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import CardParts

class ProfileVM {
//    var state: Variable<CardState> = Variable(.none)
    
    let typeList:[String] = [UserType.INDIVIDUAL.rawValue, UserType.COMPANY.rawValue]
    var user: User!
    
    var username: BehaviorRelay<String> = BehaviorRelay(value: "")
    var name: BehaviorRelay<String> = BehaviorRelay(value: "")
    var surname: BehaviorRelay<String> = BehaviorRelay(value: "")
    var ssn: BehaviorRelay<String> = BehaviorRelay(value: "")
    var countryId: BehaviorRelay<String> = BehaviorRelay(value: "")
    var countryName: BehaviorRelay<String> = BehaviorRelay(value: "")
    var type: BehaviorRelay<Int> = BehaviorRelay<Int>(value:0)
    var typeText: BehaviorRelay<String> = BehaviorRelay(value: "")
    
    var homeLatitude: BehaviorRelay<String> = BehaviorRelay(value: "")
    var homeLongitude: BehaviorRelay<String> = BehaviorRelay(value: "")
    var workLatitude: BehaviorRelay<String> = BehaviorRelay(value: "")
    var workLongitude: BehaviorRelay<String> = BehaviorRelay(value: "")
    
    var currencyMetric: BehaviorRelay<String> = BehaviorRelay(value: "")
    var currencyMetricImage: BehaviorRelay<UIImage> = BehaviorRelay(value: UIImage())
    var distanceMetric: BehaviorRelay<String> = BehaviorRelay(value: "")
    var distanceMetricImage: BehaviorRelay<UIImage> = BehaviorRelay(value: UIImage())
    var volumeMetric: BehaviorRelay<String> = BehaviorRelay(value: "")
    
    var currencyIndex: BehaviorRelay<Int> = BehaviorRelay<Int>(value:0)
    var distanceIndex: BehaviorRelay<Int> = BehaviorRelay<Int>(value:0)
    var volumeIndex: BehaviorRelay<Int> = BehaviorRelay<Int>(value:0)
    
    var countries:Countries?
    var cities: Cities?
    var citySelectionData: [[String]] = []
    let favouriteCities: BehaviorRelay<[String]> = BehaviorRelay(value: [])
    
    var imageURL: BehaviorRelay<String> = BehaviorRelay(value: "")
    var profileImage: BehaviorRelay<UIImage> = BehaviorRelay(value: UIImage())
    var loginType: BehaviorRelay<String> = BehaviorRelay(value: "")
    
    let defaultProfileImage = Utils.imageWithImage(image: UIImage(named: "default_profile.png")!, scaledToSize: CGSize(width: 96, height: 96))
    
    init() {
    }
    
    func getCountryName(countryId: String) -> String {
        var countryName = countryId;
        if(self.countries != nil){
            for country in (self.countries?.countries)! {
                if(country.countryId == countryId){
                    countryName = country.countryName!
                    return countryName
                }
            }
        }
        return countryName
    }
    
//    func setCountryId(countryName: String) -> Void {
//        if(self.countries != nil){
//            for country in (self.countries?.countries)! {
//                if(country.countryName == countryName){
//                    self.countryId.value = country.countryId!
//                    break;
//                }
//            }
//        }
//    }
    
//    func getCitiesOfCountryPopoper(countryId: String, viewController: UIViewController, sourceView: UIView){
//        APIClient.getCitiesOfCountry(countryId: countryId, completion:{ result in
//            switch result {
//            case .success(let citiesResponse):
//                self.cities = citiesResponse.value;
//                var list: [String] = []
//                for city in (self.cities?.cities!)! {
//                    list.append(city.cityName!)
//                }
//                self.citySelectionData.removeAll()
//                self.citySelectionData.append(list.sorted(by: <))
//                
//                if(list.count > 0){
//                    let mcPicker = McPicker(data: self.citySelectionData)
//                    let fixedSpace = McPickerBarButtonItem.fixedSpace(width: 20.0)
//                    let flexibleSpace = McPickerBarButtonItem.flexibleSpace()
//                    let fireButton = McPickerBarButtonItem.done(mcPicker: mcPicker, title: "Ok")
//                    let cancelButton = McPickerBarButtonItem.cancel(mcPicker: mcPicker, barButtonSystemItem: .cancel)
//                    mcPicker.setToolbarItems(items: [fixedSpace, cancelButton, flexibleSpace, fireButton, fixedSpace])
//                    
//                    mcPicker.showAsPopover(fromViewController: viewController,sourceView: sourceView, doneHandler: { (selections: [Int : String]) -> Void in
//                        if let name = selections[0] {
//                            print("Selected:" + name)
//                            var selectedCities = DefaultManager.getSelectedCities()
//                            selectedCities.append(name)
//                            selectedCities = Array(Set(selectedCities))
//                            DefaultManager.setSelectedCities(cities: selectedCities)
//                            self.favouriteCities.value = selectedCities.sorted(by:<);
//                        }})
//                }
//                else{
//                    // show error
//                }
//            case .failure(let error):
//                print((error as! CustomError).localizedDescription)
//            }
//        })
//    }
    
//    func deleteCityFromSelectedCities(cityName: String) -> Void {
//        // remove from userdefaults
//        var selectedCities = DefaultManager.getSelectedCities()
//        if let indexInSelectedCities = selectedCities.index(of:cityName) {
//            selectedCities.remove(at: indexInSelectedCities)
//        }
//        DefaultManager.setSelectedCities(cities: selectedCities)
//        self.favouriteCities.value = selectedCities.sorted(by: <)
//    }
    
    func refreshLocalData(){
        self.countries = DefaultManager.getCountries()
        let selectedCities = DefaultManager.getSelectedCities()
        self.favouriteCities.accept(selectedCities.sorted(by: <))
    }
    
    func getProfileData(forceRefresh: Bool){
        if(forceRefresh){
            Utils.showLoadingIndicator(message: "Profile Refreshing...", size: CGSize(width: 50, height: 50))
            APIClient.getCurrentUser(completion:{ result in
                switch result {
                case .success(let serverResponse):
                    self.user = serverResponse.value
                    DefaultManager.setUser(user: serverResponse.value!)
//                    self.state.value = .hasData
                    self.initValues()
                    Utils.dismissLoadingIndicator()
                    PopupHandler.successPopup(title: "Success", description: "Profile refreshed")
                    return
                case .failure(let error):
                    print((error as! CustomError).localizedDescription)
//                    self.state.value = .custom("fail")
                    Utils.dismissLoadingIndicator()
                    return
                }
            })
        }
        
        let user = DefaultManager.getUser()
        if(user == nil){
//            self.state.value = .loading
            Utils.showLoadingIndicator(message: "Profile Refreshing...", size: CGSize(width: 100, height: 100))
            APIClient.getCurrentUser(completion:{ result in
                switch result {
                case .success(let serverResponse):
                    self.user = serverResponse.value
                    DefaultManager.setUser(user: serverResponse.value!)
//                    self.state.value = .hasData
                    self.initValues()
                    Utils.dismissLoadingIndicator()
                    return
                case .failure(let error):
                    print((error as! CustomError).localizedDescription)
//                    self.state.value = .custom("fail")
                    Utils.dismissLoadingIndicator()
                    return
                }
            })
        }
        else{
            self.user = user;
//            self.state.value = .hasData
            self.initValues()
        }
    }
 
    func initValues(){
        refreshLocalData()
        
        self.username.accept(self.user.username)
        self.name.accept(self.user.name ?? "")
        self.surname.accept(self.user.surname ?? "")
        self.ssn.accept(self.user.socialSecurityNumber ?? "")
        
        self.currencyMetric.accept(self.user.currencyMetric.rawValue)
        self.currencyMetricImage.accept(Utils.imageWithImage(image: UIImage(named: self.user.currencyMetric.rawValue)!, scaledToSize: CGSize(width: 25.0, height: 25.0)))

        self.distanceMetric.accept(self.user.distanceMetric.rawValue)
        self.distanceMetricImage.accept(Utils.imageWithImage(image: UIImage(named: self.user.distanceMetric.rawValue)!, scaledToSize: CGSize(width: 25.0, height: 25.0)))

        self.volumeMetric.accept(self.user.volumeMetric.rawValue)
        self.type.accept(self.typeList.index(of: self.user.userType.rawValue)!)
        self.typeText.accept(self.user.userType.rawValue)

        self.currencyIndex.accept(Utils.getCurrencyIndex(metric: self.user.currencyMetric).rawValue)
        self.distanceIndex.accept(Utils.getDistanceIndex(metric: self.user.distanceMetric).rawValue)
        self.volumeIndex.accept(Utils.getVolumeIndex(metric: self.user.volumeMetric).rawValue)
        
        self.homeLatitude.accept("\(self.user.homeLatitude!)")
        self.homeLongitude.accept("\(self.user.homeLongitude!)")
        self.workLatitude.accept("\(self.user.workLatitude!)")
        self.workLongitude.accept("\(self.user.workLongitude!)")

        self.countryId.accept(self.user.countryId)
        self.countryName.accept(self.getCountryName(countryId: self.user.countryId))

        self.imageURL.accept(self.user.imageURL ?? "")
        self.loginType.accept(self.user.loginType.rawValue)
        
        ImageManager.getImage(imageUrl: self.imageURL.value, completion: { (response) in
            if(response != nil){
                let resized = Utils.imageWithImage(image: response!, scaledToSize: CGSize(width: 96, height: 96))
                self.profileImage.accept(resized)
            }
            else{
                self.profileImage.accept(self.defaultProfileImage)
            }
        })
    }
    
    func reset(){
        self.initValues()
        PopupHandler.successPopup(title: "Success", description: "Changes have been reverted")
    }
    
    func save(){
        let user = User(username: self.username.value,
                        name: self.name.value,
                        surname: self.surname.value,
                        countryId: self.countryId.value,
                        homeLatitude: Double(self.homeLatitude.value) ?? nil,
                        homeLongitude: Double(self.homeLongitude.value) ?? nil,
                        workLatitude: Double(self.workLatitude.value) ?? nil,
                        workLongitude: Double(self.workLongitude.value) ?? nil,
                        currencyMetric: Utils.getCurrencyMetric(index: CurrencyMetricsIndex(rawValue: self.currencyIndex.value)!),
                        distanceMetric: Utils.getDistanceMetric(index: DistanceMetricsIndex(rawValue: self.distanceIndex.value)!),
                        volumeMetric: Utils.getVolumeMetric(index: VolumeMetricsIndex(rawValue: self.volumeIndex.value)!),
                        userType: UserType(rawValue: ProfileViewController.typeList[self.type.value])!,
                        socialSecurityNumber: self.ssn.value,
                        loginType: LoginType(rawValue: self.loginType.value)!,
                        imageURL: self.imageURL.value)

        Utils.showLoadingIndicator(message: "Profile Updating...", size: CGSize(width: 100, height: 100))

        APIClient.updateAccount(user: user, completion: { result in
            switch result {
            case .success(let updateResponse):
                Utils.dismissLoadingIndicator()
                PopupHandler.successPopup(title: "Success", description: "Profile updated")
                self.user = updateResponse.value
                DefaultManager.setUser(user: updateResponse.value!)
                self.initValues()
            case .failure(let error):
                print((error as! CustomError).localizedDescription)
                Utils.dismissLoadingIndicator()
                PopupHandler.errorPopup(title: "Error", description: "Something went wrong while updating profile")
            }
        })
    }
}
