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
    }
        
    @objc func dismissTapped(sender: UIButton) {
        self.rootViewController!.dismiss(animated: true, completion: {})
    }
    
    @objc func search(sender: UIButton) {
        self.rootViewController!.dismiss(animated: true, completion: {})
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
                    self.data.value = [VehicleCollectionStruct(items: brands.filter { $0.type == type })]
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
                    self.data.value = [VehicleCollectionStruct(items: models)]
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
                    self.data.value = [VehicleCollectionStruct(items: engines)]
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
                    self.data.value = [VehicleCollectionStruct(items: versions)]
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
    
    func getDetails(version: Version){
        self.state.value = .loading
        self.selectedVersion = version
        
        let details = DefaultManager.getDetails(versionId: version.getId())
        if(details.count < 1){
            APIClient.getDetails(versionId: version.getId(), completion: { result in
                switch result {
                case .success(let response):
                    let details = response.value?.pageResult ?? []
                    DefaultManager.setDetails(versionId: version.getId(), details: details)
                    self.data.value = [VehicleCollectionStruct(items: details)]
                    self.dataStack.append(self.data.value)
                    self.state.value = details.count >= 1 ? .hasData : .empty
                    self.selectionStringArray.append(version.getName())
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
            self.selectionStringArray.append(version.getName())
            self.selectionString.value = self.selectionStringArray.joined(separator: ">")
            self.isBackButtonHide.value = false
            return
        }
    }
}
