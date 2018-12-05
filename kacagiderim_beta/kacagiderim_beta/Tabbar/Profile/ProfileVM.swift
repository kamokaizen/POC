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
    var state: Variable<CardState> = Variable(.none)
    
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
    
    var countries:Countries?
    var cities: Cities?
    var citySelectionData: [[String]] = []
    let favouriteCities: BehaviorRelay<[String]> = BehaviorRelay(value: [])
    
    var imageURL: BehaviorRelay<String> = BehaviorRelay(value: "")
    var profileImage: BehaviorRelay<UIImage> = BehaviorRelay(value: UIImage())
    var loginType: BehaviorRelay<String> = BehaviorRelay(value: "")
    
    let defaultProfileImage = UIImage(named: "profile.png")
    
    init() {
        refreshLocalData()
        getProfileData()
    }
    
//    func saveAll() {
//        self.updateProfileData()
//    }
    
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
    
    func getProfileData(){
        let user = DefaultManager.getUser()
        if(user == nil){
            self.state.value = .loading
            APIClient.getCurrentUser(completion:{ result in
                switch result {
                case .success(let serverResponse):
                    self.user = serverResponse.value
                    DefaultManager.setUser(user: serverResponse.value!)
                    self.state.value = .hasData
                    self.initValues()
                case .failure(let error):
                    print((error as! CustomError).localizedDescription)
                    self.state.value = .custom("fail")
                }
            })
        }
        else{
            self.user = user;
            self.state.value = .hasData
            self.initValues()
        }
        
        
//        APIClient.getCurrentUser(completion:{ result in
//            switch result {
//            case .success(let userResponse):
//                let profile = userResponse.value
//                DefaultManager.setUser(user: profile)
//                self.usernameText.value = profile.username
//                self.nameText.value = profile.name ?? ""
//                self.surnameText.value = profile.surname ?? ""
//                if(profile.socialSecurityNumber != nil){
//                    self.ssnText.value = profile.socialSecurityNumber!
//                }
//                self.currencyMetric.value = profile.currencyMetric.rawValue
//                self.currencyMetricImage.value = Utils.imageWithImage(image: UIImage(named: profile.currencyMetric.rawValue)!, scaledToSize: CGSize(width: 25.0, height: 25.0))
//                
//                self.distanceMetric.value = profile.distanceMetric.rawValue
//                self.distanceMetricImage.value = Utils.imageWithImage(image: UIImage(named: profile.distanceMetric.rawValue)!, scaledToSize: CGSize(width: 25.0, height: 25.0))
//                
//                self.volumeMetric.value = profile.volumeMetric.rawValue
//                self.type.value = ProfileViewController.typeList.index(of: profile.userType.rawValue)!
//                self.typeText.value = profile.userType.rawValue
//                
//                self.homeLatitude.value = "\(profile.homeLatitude!)"
//                self.homeLongitude.value = "\(profile.homeLongitude!)"
//                self.workLatitude.value = "\(profile.workLatitude!)"
//                self.workLongitude.value = "\(profile.workLongitude!)"
//                
//                self.countryId.value = profile.countryId
//                self.countryName.value = self.getCountryName(countryId: profile.countryId)
//                
//                self.imageURL.value = profile.imageURL ?? ""
//                
//                ImageManager.getImage(imageUrl: self.imageURL.value, completion: { (response) in
//                    if(response != nil){
//                        self.profileImage.value = response!
//                    }
//                    else{
//                        self.profileImage.value = self.defaultProfileImage!
//                    }
//                })
//                self.loginType.value = profile.loginType.rawValue
//            case .failure(let error):
//                print((error as! CustomError).localizedDescription)
//            }
//        })
    }
 
    func initValues(){
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

        self.homeLatitude.accept("\(self.user.homeLatitude!)")
        self.homeLongitude.accept("\(self.user.homeLongitude!)")
        self.workLatitude.accept("\(self.user.workLatitude!)")
        self.workLongitude.accept("\(self.user.workLongitude!)")

        self.countryId.accept(self.user.countryId)
        self.countryName.accept(self.getCountryName(countryId: self.user.countryId))

        self.imageURL.accept(self.user.imageURL ?? "")
        self.loginType.accept(self.user.loginType.rawValue)
    }
    
//    func updateProfileData(){
//        let user = User(username: self.usernameText.value,
//                        name: self.nameText.value,
//                        surname: self.surnameText.value,
//                        countryId: self.countryId.value,
//                        homeLatitude: Double(self.homeLatitude.value) ?? nil,
//                        homeLongitude: Double(self.homeLongitude.value) ?? nil,
//                        workLatitude: Double(self.workLatitude.value) ?? nil,
//                        workLongitude: Double(self.workLongitude.value) ?? nil,
//                        currencyMetric: CurrencyMetrics(rawValue: self.currencyMetric.value)!,
//                        distanceMetric: DistanceMetrics(rawValue: self.distanceMetric.value)!,
//                        volumeMetric: VolumeMetrics(rawValue: self.volumeMetric.value)!,
//                        userType: UserType(rawValue: ProfileViewController.typeList[self.type.value])!,
//                        socialSecurityNumber: self.ssnText.value,
//                        loginType: LoginType(rawValue: self.loginType.value)!,
//                        imageURL: self.imageURL.value)
//
//        Utils.showLoadingIndicator(message: "Profile Updating", size: CGSize(width: 100, height: 100))
//
//        APIClient.updateAccount(user: user, completion: { result in
//            switch result {
//            case .success(let updateResponse):
//                Utils.dismissLoadingIndicator()
//                PopupHandler.successPopup(title: "Success", description: updateResponse.reason)
//                self.getProfileData()
//            case .failure(let error):
//                print((error as! CustomError).localizedDescription)
//                Utils.dismissLoadingIndicator()
//                PopupHandler.errorPopup(title: "Error", description: "Something went wrong")
//            }
//        })
//    }
}
