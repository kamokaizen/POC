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

class NewVehicleVM {
    
    typealias ReactiveSectionBrand = Variable<[VehicleCollectionStruct]>
    var data = ReactiveSectionBrand([])
    var state: Variable<CardState> = Variable(.none)
    
    weak var rootViewController:NewVehicleVC?
    var selectedVehicleType:Int
    var selectedBrand:Brand?
    
    init(rootViewController: NewVehicleVC) {
        self.rootViewController = rootViewController
        self.state.value = .none
        self.selectedVehicleType = -1
        self.selectedBrand = nil
    }
        
    @objc func dismissTapped(sender: UIButton) {
        self.rootViewController!.dismiss(animated: true, completion: {})
    }
    
    @objc func search(sender: UIButton) {
        self.rootViewController!.dismiss(animated: true, completion: {})
    }
    
    func filterBrands(type: Int){
        self.selectedVehicleType = type
        self.state.value = .loading
        let brands = DefaultManager.getBrands()
        if(brands.count < 1){
            APIClient.getBrands(completion: { result in
                switch result {
                case .success(let response):
                    let brands = response.value?.pageResult ?? []
                    DefaultManager.setBrands(brands: brands)
                    self.data.value = [VehicleCollectionStruct(items: brands.filter { $0.type == type })]
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
                    self.data.value = [VehicleCollectionStruct(items: models)]
                    self.state.value = models.count >= 1 ? .hasData : .empty
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
            self.state.value = models.count >= 1 ? .hasData : .empty
            return
        }
    }
}
