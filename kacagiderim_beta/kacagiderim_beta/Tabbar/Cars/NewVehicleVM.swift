//
//  BrandCollectionViewModel.swift
//  kacagiderim_beta
//
//  Created by Comodo on 2.11.2018.
//  Copyright © 2018 kacagiderim. All rights reserved.
//

import Foundation
import RxSwift
import RxDataSources
import RxCocoa
import CardParts
import SwiftEntryKit

class NewVehicleVM {
    
    typealias ReactiveSectionBrand = Variable<[VehicleCollectionStruct]>
    var data = ReactiveSectionBrand([])
    var dataStack: [[VehicleCollectionStruct]]
    var state: Variable<CardState> = Variable(.none)
    var isBackButtonHide: Variable<Bool> = Variable(true)
    
    weak var rootViewController:NewVehicleVC?
    var selectedVehicleType:Int
    var selectedBrand:Brand?
    var selectedModel:Model?
    var selectedEngine:Engine?
    var selectedVersion:Version?
    var selectedDetail:Detail?
    
    var selectionString: Variable<String> = Variable("")
    var selectionStringArray: [String] = []
    
    var searchDataStack: Dictionary<Int, [Detail]>
    var searchVehicles: Variable<[Detail]> = Variable([])
    var searchString: Variable<String> = Variable("")
    var searchResultString: Variable<String> = Variable("")
    var currentPageNumber: Variable<Int> = Variable(1)
    var totalItemCount: Variable<Int> = Variable(1)
    var totalPageCount: Variable<Int> = Variable(1)
    var isPaginationBackButtonHide: Variable<Bool> = Variable(true)
    var isPaginationNextButtonHide: Variable<Bool> = Variable(true)
    var isSearchResultsStackHide : Variable<Bool> = Variable(true)
    
    init(rootViewController: NewVehicleVC) {
        self.rootViewController = rootViewController
        self.state.value = .none
        self.selectedVehicleType = -1
        self.selectedBrand = nil
        self.selectedModel = nil
        self.selectedVersion = nil
        self.selectedDetail = nil
        self.selectionStringArray = []
        self.dataStack = []
        self.searchDataStack = Dictionary()
        self.currentPageNumber.value = 1
        self.totalItemCount.value = 0
        self.totalPageCount.value = 0
    }
        
    @objc func dismiss(sender: UIButton) {
        self.rootViewController!.dismiss(animated: true, completion: {})
    }
    
    @objc func dismissSearch(sender: UIButton) {
        self.state.value = .hasData
    }
    
    @objc func search(sender: UIButton) {
        self.clearSearchFields()
        self.isSearchResultsStackHide.value = true
        self.state.value = .custom("search")
    }

    @objc func makeSearch(sender: UIButton) {
        self.currentPageNumber.value = 1
        self.searchDataStack.removeAll()
        self.getDetailsWithSearchString()
    }
    
    @objc func getNextPageDetails(){
        self.currentPageNumber.value = self.currentPageNumber.value + 1
        self.getDetailsWithSearchString()
    }

    @objc func getPreviousPageDetails(){
        self.currentPageNumber.value = self.currentPageNumber.value - 1
        self.getDetailsWithSearchString()
    }
    
    func clearSearchFields(){
        self.searchDataStack.removeAll()
        self.searchVehicles.value.removeAll()
        self.searchString.value = ""
        self.searchResultString.value = "Search Results"
        self.currentPageNumber.value = 1
        self.totalItemCount.value = 0
        self.totalPageCount.value = 1
        self.isPaginationNextButtonHide.value = false
        self.isPaginationBackButtonHide.value = false
        self.isSearchResultsStackHide.value = true
    }
    
    @objc func chooseVehicleType(sender: UIButton){
        let attributes = Utils.getAttributes(element: EKAttributes.bottomToast,
                                             duration: .infinity,
                                             entryBackground: .gradient(gradient: .init(colors: [EKColor.Netflix.light, EKColor.Netflix.dark], startPoint: .zero, endPoint: CGPoint(x: 1, y: 1))),
                                             screenBackground: .color(color: .dimmedLightBackground),
                                             roundCorners: .all(radius: 25))
        let buttonLabelStyle = EKProperty.LabelStyle(font: MainFont.medium.with(size: 20), color: EKColor.Netflix.dark)
        
        let automobileButton = EKProperty.ButtonContent(label: EKProperty.LabelContent(text: "Automobile", style: buttonLabelStyle), backgroundColor: .white, highlightedBackgroundColor:  EKColor.Gray.light) {
            SwiftEntryKit.dismiss()
            self.filterBrands(type: BrandType.AUTOMOBILE.rawValue)
        }
        let suvButton = EKProperty.ButtonContent(label: EKProperty.LabelContent(text: "SUV", style: buttonLabelStyle), backgroundColor: .white, highlightedBackgroundColor:  EKColor.Gray.light) {
            SwiftEntryKit.dismiss()
            self.filterBrands(type: BrandType.SUV.rawValue)
        }
        let minivanButton = EKProperty.ButtonContent(label: EKProperty.LabelContent(text: "Minivan & Panelvan", style: buttonLabelStyle), backgroundColor: .white, highlightedBackgroundColor:  EKColor.Gray.light) {
            SwiftEntryKit.dismiss()
            self.filterBrands(type: BrandType.MINIVAN.rawValue)
        }
        
        Utils.showSelectionPopup(attributes: attributes, title: "Vehicle Type Selection", titleColor: .white, description: "Plese select at least a vehicle type from below types. Currently, There are three types of vehicle exist.", descriptionColor: .white, image: UIImage(named: "ic_success")!, buttons: [automobileButton, suvButton, minivanButton])
    }
        
    @objc func back(sender: UIButton) {
        if(self.dataStack.count > 1){
            self.dataStack.removeLast()
            self.selectionStringArray.removeLast()
        }
        self.data.value = self.dataStack.last ?? []
        self.selectionString.value = self.selectionStringArray.joined(separator: ">")
        self.isBackButtonHide.value = self.dataStack.count > 1 ? false : true
        self.state.value = .hasData
    }
    
    @objc func reset(sender: UIButton) {
        self.filterBrands(type: self.selectedVehicleType)
    }
    
    @objc func refresh(){
        
    }
    
    func filterBrands(type: Int){
        self.selectedVehicleType = type
        self.state.value = .loading
        let brands = DefaultManager.getBrands()
        self.dataStack.removeAll()
        self.data.value = []
        self.selectionString.value = ""
        self.selectionStringArray.removeAll()
        
        if(brands.count < 1){
            APIClient.getBrands(completion: { result in
                switch result {
                case .success(let response):
                    let brands = response.value?.pageResult ?? []
                    DefaultManager.setBrands(brands: brands)
                    // to be sorted for the first time use Default Manager
                    let sortedBrands = DefaultManager.getBrands()
                    self.data.value = [VehicleCollectionStruct(items: sortedBrands.filter { $0.type == type })]
                    self.dataStack.append(self.data.value)
                    self.state.value = brands.count >= 1 ? .hasData : .empty
                    return
                case .failure(let error):
                    print((error as! CustomError).localizedDescription)
                    self.state.value = .custom("fail")
                    return
                }
            })
        }
        else{
            self.data.value = [VehicleCollectionStruct(items: brands.filter { $0.type == type })]
            self.dataStack.append(self.data.value)
            self.state.value = brands.count >= 1 ? .hasData : .empty
            return
        }
    }
    
    func getModels(brand:Brand){
        self.state.value = .loading
        self.selectedBrand = brand
        let brandId = brand.brandId ?? ""
        let models = DefaultManager.getModels(brandId: brandId)
        if(models.count < 1) {
            APIClient.getModels(brandId: brandId, completion: { result in
                switch result {
                case .success(let response):
                    let models = response.value?.pageResult ?? []
                    DefaultManager.setModels(brandId: brandId, models: models)
                    let sortedModels = DefaultManager.getModels(brandId: brandId)
                    self.data.value = [VehicleCollectionStruct(items: sortedModels)]
                    self.dataStack.append(self.data.value)
                    self.state.value = models.count >= 1 ? .hasData : .empty
                    self.selectionStringArray.append(brand.getName())
                    self.selectionString.value = brand.getName()
                    self.isBackButtonHide.value = false
                    return
                case .failure(let error):
                    print((error as! CustomError).localizedDescription)
                    self.state.value = .custom("fail")
                    return
                }
            })
        }
        else{
            self.data.value = [VehicleCollectionStruct(items: models)]
            self.dataStack.append(self.data.value)
            self.state.value = models.count >= 1 ? .hasData : .empty
            self.selectionStringArray.append(brand.getName())
            self.selectionString.value = brand.getName()
            self.isBackButtonHide.value = false
            return
        }
    }
    
    func getEngines(model: Model){
        self.state.value = .loading
        self.selectedModel = model
        
        let engines = DefaultManager.getEngines(modelId: model.getId())
        if(engines.count < 1){
            APIClient.getEngines(modelId: model.getId(), completion: { result in
                switch result {
                case .success(let response):
                    let engines = response.value?.pageResult ?? []
                    DefaultManager.setEngines(modelId: model.getId(), engines: engines)
                    let sortedEngines = DefaultManager.getEngines(modelId: model.getId())
                    self.data.value = [VehicleCollectionStruct(items: sortedEngines)]
                    self.dataStack.append(self.data.value)
                    self.state.value = engines.count >= 1 ? .hasData : .empty
                    self.selectionStringArray.append(model.getName())
                    self.selectionString.value = (self.selectedModel?.brandName)! + ">" + (self.selectedModel?.name)!
                    self.isBackButtonHide.value = false
                    return
                case .failure(let error):
                    print((error as! CustomError).localizedDescription)
                    self.state.value = .custom("fail")
                    return
                }
            })
        }
        else{
            self.data.value = [VehicleCollectionStruct(items: engines)]
            self.dataStack.append(self.data.value)
            self.state.value = engines.count >= 1 ? .hasData : .empty
            self.selectionStringArray.append(model.getName())
            self.selectionString.value = (self.selectedModel?.brandName)! + ">" + (self.selectedModel?.name)!
            self.isBackButtonHide.value = false
            return
        }
    }
    
    func getVersions(engine: Engine){
        self.state.value = .loading
        self.selectedEngine = engine
        
        let versions = DefaultManager.getVersions(engineId: engine.getId())
        if(versions.count < 1){
            APIClient.getVersions(engineId: engine.getId(), completion: { result in
                switch result {
                case .success(let response):
                    let versions = response.value?.pageResult ?? []
                    DefaultManager.setVersions(engineId: engine.getId(), versions: versions)
                    let sortedVersions = DefaultManager.getVersions(engineId: engine.getId())
                    self.data.value = [VehicleCollectionStruct(items: sortedVersions)]
                    self.dataStack.append(self.data.value)
                    self.state.value = versions.count >= 1 ? .hasData : .empty
                    self.selectionStringArray.append(engine.getName())
                    self.selectionString.value = self.selectionStringArray.joined(separator: ">")
                    self.isBackButtonHide.value = false
                    return
                case .failure(let error):
                    print((error as! CustomError).localizedDescription)
                    self.state.value = .custom("fail")
                    return
                }
            })
        }
        else{
            self.data.value = [VehicleCollectionStruct(items: versions)]
            self.dataStack.append(self.data.value)
            self.state.value = versions.count >= 1 ? .hasData : .empty
            self.selectionStringArray.append(engine.getName())
            self.selectionString.value = self.selectionStringArray.joined(separator: ">")
            self.isBackButtonHide.value = false
            return
        }
    }
    
    func getDetails(version: Version?, engine: Engine?){
        self.state.value = .loading
        self.selectedVersion = version
        self.selectedEngine = engine
        let id = version != nil ? version?.getId() : (engine != nil) ? engine?.getId() : ""
        let selectedName = version != nil ? version?.getName() : (engine != nil) ? engine?.getName() : ""
        
        let details = DefaultManager.getDetails(versionId: id!)
        if(details.count < 1){
            APIClient.getDetails(versionId: id!, completion: { result in
                switch result {
                case .success(let response):
                    let details = response.value?.pageResult ?? []
                    DefaultManager.setDetails(versionId: id!, details: details)
                    let sortedDetails = DefaultManager.getDetails(versionId: id!)
                    self.data.value = [VehicleCollectionStruct(items: sortedDetails)]
                    self.dataStack.append(self.data.value)
                    self.state.value = details.count >= 1 ? .hasData : .empty
                    self.selectionStringArray.append(selectedName!)
                    self.selectionString.value = self.selectionStringArray.joined(separator: ">")
                    self.isBackButtonHide.value = false
                    return
                case .failure(let error):
                    print((error as! CustomError).localizedDescription)
                    self.state.value = .custom("fail")
                    return
                }
            })
        }
        else{
            self.data.value = [VehicleCollectionStruct(items: details)]
            self.dataStack.append(self.data.value)
            self.state.value = details.count >= 1 ? .hasData : .empty
            self.selectionStringArray.append(selectedName!)
            self.selectionString.value = self.selectionStringArray.joined(separator: ">")
            self.isBackButtonHide.value = false
            return
        }
    }
    
    func addVehicle(detail: Detail, options: VehicleAddFormStruct){
        let user = DefaultManager.getUser()
        let newVehicle = AccountVehicle(accountVehicleId: nil,
                                        vehicleDetailId: detail.getId(),
                                        userId: user?.userId,
                                        vehiclePlate: options.vehiclePlate,
                                        customVehicle: false,
                                        customVehicleName: nil,
                                        customConsumption: false,
                                        customConsumptionType: nil,
                                        averageCustomConsumptionLocal: 0,
                                        averageCustomConsumptionOut: 0,
                                        vehicle: detail)
        Utils.showLoadingIndicator(message: "Vehicles are updating", size: CGSize(width: 100, height: 100))
        
        APIClient.createVehicle(accountVehicle: newVehicle, completion: { result in
            switch result {
            case .success(let createResponse):
                
                // update account vehicles on default
                var accountVehicles = DefaultManager.getAccountVehicles()
                accountVehicles.append(createResponse.value!)
                DefaultManager.setAccountVehicles(accountVehicles: accountVehicles)
                
                Utils.dismissLoadingIndicator()
                self.rootViewController!.dismiss(animated: true, completion: {})
                
                Utils.delayWithSeconds(1, completion: {
                    PopupHandler.successPopup(title: "Success", description: "New vehicle is added")
                })
            case .failure(let error):
                Utils.dismissLoadingIndicator()
                print((error as! CustomError).localizedDescription)
                PopupHandler.errorPopup(title: "Error", description: "Something went wrong while adding new vehicle")
            }
        })
    }
    
    func getDetailsWithSearchString(){
        self.state.value = .loading
        let details = self.searchDataStack[self.currentPageNumber.value] ?? []
        
        if(details.count > 0){
            self.searchVehicles.value = details
            self.state.value = .custom("search")
            self.updateSearchResultStack()
        }
        else{
            APIClient.vehicleSearch(searchText: self.searchString.value, pageNumber: self.currentPageNumber.value, completion: { result in
                switch result {
                case .success(let response):
                    self.searchVehicles.value = response.value?.pageResult ?? []
                    self.totalItemCount.value = response.value?.pagination?.totalItemCount ?? 0
                    self.totalPageCount.value = response.value?.pagination?.totalPage ?? 0
                    self.currentPageNumber.value = response.value?.pagination?.currentPage ?? 0
                    self.searchDataStack.updateValue(self.searchVehicles.value, forKey: self.currentPageNumber.value);
                    self.state.value = .custom("search")
                    self.updateSearchResultStack()
                    return
                case .failure(let error):
                    print((error as! CustomError).localizedDescription)
                    self.state.value = .custom("fail")
                    return
                }
            })
        }
    }
    
    func updateSearchResultStack(){
        self.isPaginationBackButtonHide.value = self.currentPageNumber.value <= 1
        self.isPaginationNextButtonHide.value = self.currentPageNumber.value >= self.totalPageCount.value
        self.isSearchResultsStackHide.value = false // first time search make visible
        let currentPageShown = self.totalItemCount.value == 0 ? 0 : self.currentPageNumber.value
        self.searchResultString.value = "\(self.totalItemCount.value) vehicles found | Page \(currentPageShown)/\(self.totalPageCount.value)"
    }
}
