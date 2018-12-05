//
//  SearchVehicleVM.swift
//  kacagiderim_beta
//
//  Created by kamilinal on 12/4/18.
//  Copyright © 2018 kacagiderim. All rights reserved.
//

import Foundation
import RxSwift
import RxDataSources
import RxCocoa
import CardParts

class SearchVehicleVM {
    
    var state: BehaviorRelay<CardState> = BehaviorRelay(value: .none)
    
    var searchDataStack: Dictionary<Int, [Detail]>
    var searchVehicles: BehaviorRelay<[Detail]> = BehaviorRelay(value: [])
    var searchString: BehaviorRelay<String> = BehaviorRelay(value: "")
    var searchResultString: BehaviorRelay<String> = BehaviorRelay(value: "")
    var currentPageNumber: BehaviorRelay<Int> = BehaviorRelay(value: 1)
    var totalItemCount: BehaviorRelay<Int> = BehaviorRelay(value: 1)
    var totalPageCount: BehaviorRelay<Int> = BehaviorRelay(value: 1)
    var isPaginationBackButtonHide: BehaviorRelay<Bool> = BehaviorRelay(value:true)
    var isPaginationNextButtonHide: BehaviorRelay<Bool> = BehaviorRelay(value:true)
    var isSearchResultsStackHide : BehaviorRelay<Bool> = BehaviorRelay(value:true)
    var isCreateVehicleSuccess : BehaviorRelay<Bool> = BehaviorRelay(value: false)
    
    var isLoading : BehaviorRelay<Bool> = BehaviorRelay(value: false)
    
    init() {
        self.state.accept(.none)
        self.searchDataStack = Dictionary()
        self.currentPageNumber.accept(1)
        self.totalItemCount.accept(0)
        self.totalPageCount.accept(0)
        self.isCreateVehicleSuccess.accept(false);
        self.isLoading.accept(false)
    }
        
    @objc func search(sender: UIButton) {
        self.clearSearchFields()
        self.isSearchResultsStackHide.accept(true)
        self.state.accept(.none)
    }
    
    func makeSearch() {
        self.currentPageNumber.accept(1)
        self.searchDataStack.removeAll()
        self.getDetailsWithSearchString()
    }
    
    @objc func getNextPageDetails(sender: UIButton){
        self.currentPageNumber.accept(self.currentPageNumber.value + 1)
        self.getDetailsWithSearchString()
    }
    
    @objc func getPreviousPageDetails(sender: UIButton){
        self.currentPageNumber.accept(self.currentPageNumber.value - 1)
        self.getDetailsWithSearchString()
    }
    
    func getDetailsWithSearchString(){
        self.isLoading.accept(true)
        let details = self.searchDataStack[self.currentPageNumber.value] ?? []
        
        if(details.count > 0){
            self.searchVehicles.accept(details)
            self.isLoading.accept(false)
            self.updateSearchResultStack()
        }
        else{
            APIClient.vehicleSearch(searchText: self.searchString.value, pageNumber: self.currentPageNumber.value, completion: { result in
                switch result {
                case .success(let response):
                    self.searchVehicles.accept(response.value?.pageResult ?? [])
                    self.totalItemCount.accept(response.value?.pagination?.totalItemCount ?? 0)
                    self.totalPageCount.accept(response.value?.pagination?.totalPage ?? 0)
                    self.currentPageNumber.accept(response.value?.pagination?.currentPage ?? 0)
                    self.searchDataStack.updateValue(self.searchVehicles.value, forKey: self.currentPageNumber.value);
                    self.isLoading.accept(false)
                    self.updateSearchResultStack()
                    return
                case .failure(let error):
                    print((error as! CustomError).localizedDescription)
                    self.isLoading.accept(false)
                    PopupHandler.errorPopup(title: "Error", description: "Something went wrong while searching vehicle")
                    return
                }
            })
        }
    }
    
    func updateSearchResultStack(){
        self.isPaginationBackButtonHide.accept(self.currentPageNumber.value <= 1)
        self.isPaginationNextButtonHide.accept(self.currentPageNumber.value >= self.totalPageCount.value)
        self.isSearchResultsStackHide.accept(false) // first time search make visible
        let currentPageShown = self.totalItemCount.value == 0 ? 0 : self.currentPageNumber.value
        self.searchResultString.accept("\(self.totalItemCount.value) vehicles found | Page \(currentPageShown)/\(self.totalPageCount.value)")
    }
    
    func clearSearchFields(){
        self.searchDataStack.removeAll()
        self.searchVehicles.accept([])
        self.searchString.accept("")
        self.searchResultString.accept("Search Results")
        self.currentPageNumber.accept(1)
        self.totalItemCount.accept(0)
        self.totalPageCount.accept(1)
        self.isPaginationNextButtonHide.accept(false)
        self.isPaginationBackButtonHide.accept(false)
        self.isSearchResultsStackHide.accept(true)
        self.isCreateVehicleSuccess.accept(false)
    }
    
    func addVehicle(detail: Detail, options: VehicleAddFormStruct){
        let user = DefaultManager.getUser()
        let newVehicle = AccountVehicle(accountVehicleId: nil,
                                        vehicleDetailId: detail.getId(),
                                        userId: user?.userId,
                                        vehiclePlate: options.vehiclePlate,
                                        vehicleUsage: 0,
                                        vehicleBrand: detail.brandImageName,
                                        vehicleModel: detail.modelImageName,
                                        vehicleDescription: "\(detail.startYear ?? "") - \(detail.endYear ?? "") | \(detail.longModelDescription ?? "")",
                                        customVehicle: false,
                                        customVehicleName: nil,
                                        customConsumption: false,
                                        customConsumptionType: nil,
                                        averageCustomConsumptionLocal: 0,
                                        averageCustomConsumptionOut: 0)
        Utils.showLoadingIndicator(message: "Vehicles are updating", size: CGSize(width: 100, height: 100))
        
        APIClient.createVehicle(accountVehicle: newVehicle, completion: { result in
            switch result {
            case .success(let createResponse):
                // update account vehicles on default
                var accountVehicles = DefaultManager.getAccountVehicles()
                accountVehicles.append(createResponse.value!)
                DefaultManager.setAccountVehicles(accountVehicles: accountVehicles)
                self.isCreateVehicleSuccess.accept(true)
                Utils.dismissLoadingIndicator()
//                self.rootViewController!.dismiss(animated: true, completion: {})
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
}
