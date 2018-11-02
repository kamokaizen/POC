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

class BrandCollectionViewModel {
    
    typealias ReactiveSectionBrand = Variable<[BrandCollectionStruct]>
    typealias ReactiveSectionModel = Variable<[BrandCollectionStruct]>
    var dataBrand = ReactiveSectionBrand([])
    var dataModel = ReactiveSectionBrand([])
    
    init() {
        let brands = DefaultManager.getBrands()
        dataBrand.value = [BrandCollectionStruct(header: "", items: brands)]
    }
    
    func filterBrands(type: Int){
        let brands = DefaultManager.getBrands()
        if(brands.count < 1){
            APIClient.getBrands(completion: { result in
                switch result {
                case .success(let response):
                    let brands = response.value?.pageResult ?? []
                    DefaultManager.setBrands(brands: brands)
                    self.dataBrand.value = [BrandCollectionStruct(header: "", items: brands.filter { $0.type == type })]
                case .failure(let error):
                    print((error as! CustomError).localizedDescription)
                }
            })
        }
        else{
            dataBrand.value = [BrandCollectionStruct(header: "", items: brands.filter { $0.type == type })]
        }
    }
    
    func getModels(brandId:String){
        let models = DefaultManager.getModels(brandId: brandId)
        if(models.count < 1) {
            APIClient.getModels(brandId: brandId, completion: { result in
                switch result {
                case .success(let response):
                    let models = response.value?.pageResult ?? []
                    DefaultManager.setModels(brandId: brandId, models: models)
                case .failure(let error):
                    print((error as! CustomError).localizedDescription)
                }
                
            })
        }
        return models
    }
}
