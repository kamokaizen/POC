//
//  CarDetailViewController.swift
//  kacagiderim_beta
//
//  Created by Comodo on 30.10.2018.
//  Copyright © 2018 kacagiderim. All rights reserved.
//

import Foundation
import CardParts

class AccountVehicleDetailVC: CardsViewController {
    
    var cards: [CardController] = []
    var viewModel: AccountVehicleDetailVM?
    
    public init(accountVehicle: AccountVehicle) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = AccountVehicleDetailVM(accountVehicle: accountVehicle)
    }
    
    required public init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.cards = [MainVC(self.viewModel!), OptionalsVC(self.viewModel!), OverallDetailVC(self.viewModel!), EnginePerformanceDetailVC(self.viewModel!), FuelConsumptionDetailVC(self.viewModel!), DimensionsDetailVC(self.viewModel!)]
        loadCards(cards: cards)
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
    
    class MainVC : CardPartsViewController, ShadowCardTrait, RoundedCardTrait {
        weak  var viewModel: AccountVehicleDetailVM!
        
        public init(_ viewModel: AccountVehicleDetailVM) {
            super.init(nibName: nil, bundle: nil)
            self.viewModel = viewModel
        }
        
        required public init(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        func shadowColor() -> CGColor {
            return UIColor.lightGray.cgColor
        }
        
        func shadowRadius() -> CGFloat {
            return 10.0
        }
        
        func shadowOpacity() -> Float {
            return 1.0
        }
        
        func cornerRadius() -> CGFloat {
            return 10.0
        }
        
        override func viewDidLoad() {
            super.viewDidLoad()
            let detail = self.viewModel.accountVehicle.vehicle
            
            if (detail != nil) {
                let brand = CardPartTextView(type: .title)
                brand.label.font = CardParts.theme.headerTextFont
                brand.label.text = detail?.brandImageName?.uppercased()
                
                let model = CardPartTextView(type: .title)
                model.label.font = CardParts.theme.normalTextFont
                model.label.text = detail?.longModelDescription?.uppercased()
                
                let brandLogo = CardPartImageView()
                ImageManager.getImageFromCloudinary(path: K.Constants.cloudinaryLogoPath + (detail?.brandImageName ?? ""), completion:  { (response) in
                    if(response != nil){
                        brandLogo.image = response
                    }
                })
                
                let modelImage = CardPartImageView()
                ImageManager.getImageFromCloudinary(path: K.Constants.cloudinaryCarPath + (detail?.brandImageName ?? "") + "/" + (detail?.modelImageName ?? ""), completion:  { (response) in
                    if(response != nil){
                        modelImage.image = response
                        modelImage.layer.cornerRadius = 5.0;
                        modelImage.clipsToBounds = true;
                    }
                })
                
                let titleSVHorizontal = CardPartStackView()
                titleSVHorizontal.spacing = 10
                titleSVHorizontal.distribution = .fill
                titleSVHorizontal.alignment = .center
                titleSVHorizontal.contentMode = .center
                titleSVHorizontal.axis = .horizontal
                titleSVHorizontal.addArrangedSubview(brandLogo)
                titleSVHorizontal.addArrangedSubview(brand)
                
                let mainSVVertical = CardPartStackView()
                mainSVVertical.spacing = 10
                mainSVVertical.distribution = .fill
                mainSVVertical.axis = .vertical
                mainSVVertical.alignment = .center
                mainSVVertical.addArrangedSubview(titleSVHorizontal)
                mainSVVertical.addArrangedSubview(modelImage)
                mainSVVertical.addArrangedSubview(model)
                
                mainSVVertical.addConstraint(NSLayoutConstraint(item: modelImage, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 0, constant: 360))
                mainSVVertical.addConstraint(NSLayoutConstraint(item: modelImage, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 0, constant: 240))
                
                titleSVHorizontal.addConstraint(NSLayoutConstraint(item: brandLogo, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 0, constant: 50))
                titleSVHorizontal.addConstraint(NSLayoutConstraint(item: brandLogo, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 0, constant: 50))

                setupCardParts([mainSVVertical])
            }
        }
    }
    
    class OptionalsVC : CardPartsViewController, ShadowCardTrait, RoundedCardTrait {
        weak  var viewModel: AccountVehicleDetailVM!
        
        let buttonStack = CardPartTitleView(type: .titleWithMenu)
        let vehiclePlateTF = CardPartTextField(format: .none)
        var customVehicleSC = UISegmentedControl(items: ["Custom Vehicle Off", "Custom Vehicle On"])
        var customConsumptionSC = UISegmentedControl(items: ["Custom Consumption Off", "Custom Consumption On"])
        let averageConsumptionLocalTF = CardPartTextField(format: .none)
        let averageConsumptionOutTF = CardPartTextField(format: .none)
        let customVehicleNameTF = CardPartTextField(format: .none)
        let customConsumptionTypeSC = UISegmentedControl(items: [FuelTypeString.BENZIN.rawValue, FuelTypeString.DIZEL.rawValue, FuelTypeString.BENZIN_LPG.rawValue, FuelTypeString.HIBRIT.rawValue])
        
        public init(_ viewModel: AccountVehicleDetailVM) {
            super.init(nibName: nil, bundle: nil)
            self.viewModel = viewModel
        }
        
        required public init(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        func shadowColor() -> CGColor {
            return UIColor.lightGray.cgColor
        }
        
        func shadowRadius() -> CGFloat {
            return 10.0
        }
        
        func shadowOpacity() -> Float {
            return 1.0
        }
        
        func cornerRadius() -> CGFloat {
            return 10.0
        }
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            buttonStack.menuTitle = "Actions"
            buttonStack.menuOptions = ["Save", "Reset"]
            buttonStack.menuOptionObserver  = {[weak self] (title, index) in
                // Logic to determine which menu option was clicked
                // and how to respond
                if index == 0 {
                    self!.viewModel.updateAccountVehicle()
                }
                else if index == 1 {
                    self!.viewModel.initValues();
                }
            }
            let titlePart = CardPartsUtil.titleWithMenu(leftTitleText: "Optionals", menu: buttonStack)
            
            let seperator = CardPartSeparatorView()
            
            vehiclePlateTF.keyboardType = .default
            vehiclePlateTF.placeholder = "Type a plate"
            vehiclePlateTF.font = CardParts.theme.normalTextFont
            vehiclePlateTF.textColor = CardParts.theme.normalTextColor
            
            // viewModel - textField bind
            viewModel.plate.asObservable().bind(to: vehiclePlateTF.rx.text).disposed(by: bag)
            // textField - viewModel bind
            vehiclePlateTF.rx.text.orEmpty.bind(to: viewModel.plate).disposed(by: bag)
            
            let vehiclePlateItem = CardPartsUtil.generateCenteredItemWithTextField(letfLabelText: "Vehicle Plate", rightTextField: vehiclePlateTF)
        
            // viewModel - selection bind
            viewModel.customVehicleSelectedIndex.asObservable().bind(to: customVehicleSC.rx.selectedSegmentIndex).disposed(by: bag)
            // selection - viewModel bind
            customVehicleSC.rx.selectedSegmentIndex.bind(to: viewModel.customVehicleSelectedIndex).disposed(by: bag)
            
//            let customSelectionItem = CardPartsUtil.generateCenteredItemWithSegmentedControl(letfLabelText: "Custom Vehicle", rightSegmentedControl: customVehicleSC)

            // viewModel - selection bind
            viewModel.customConsumptionIndex.asObservable().bind(to: customConsumptionSC.rx.selectedSegmentIndex).disposed(by: bag)
            // selection - viewModel bind
            customConsumptionSC.rx.selectedSegmentIndex.bind(to: viewModel.customConsumptionIndex).disposed(by: bag)
            
//            let customConsumptionItem = CardPartsUtil.generateCenteredItemWithSegmentedControl(letfLabelText: "Custom Consumption", rightSegmentedControl: customConsumptionSC)
            
            averageConsumptionLocalTF.keyboardType = .default
            averageConsumptionLocalTF.placeholder = "Type consumption value (100 km/h)"
            averageConsumptionLocalTF.font = CardParts.theme.normalTextFont
            averageConsumptionLocalTF.textColor = CardParts.theme.normalTextColor
            
            let averageLocalItem = CardPartsUtil.generateCenteredItemWithTextField(letfLabelText: "Local Consumption", rightTextField: averageConsumptionLocalTF)
            
            // viewModel - textField bind
            viewModel.averageCustomConsumptionLocal.asObservable().bind(to: averageConsumptionLocalTF.rx.text).disposed(by: bag)
            // textField - viewModel bind
            averageConsumptionLocalTF.rx.text.orEmpty.bind(to: viewModel.averageCustomConsumptionLocal).disposed(by: bag)
            // editable - bind
            viewModel.customConsumptionIndex.asObservable().map({$0 == 1 ? true : false}).bind(to: averageConsumptionLocalTF.rx.isUserInteractionEnabled).disposed(by:bag)
            
            averageConsumptionOutTF.keyboardType = .default
            averageConsumptionOutTF.placeholder = "Type consumption value (100 km/h)"
            averageConsumptionOutTF.font = CardParts.theme.normalTextFont
            averageConsumptionOutTF.textColor = CardParts.theme.normalTextColor
            
            let averageOutItem = CardPartsUtil.generateCenteredItemWithTextField(letfLabelText: "Out Consumption", rightTextField: averageConsumptionOutTF)
            
            // viewModel - textField bind
            viewModel.averageCustomConsumptionOut.asObservable().bind(to: averageConsumptionOutTF.rx.text).disposed(by: bag)
            // textField - viewModel bind
            averageConsumptionOutTF.rx.text.orEmpty.bind(to: viewModel.averageCustomConsumptionOut).disposed(by: bag)
            // editable - bind
            viewModel.customConsumptionIndex.asObservable().map({$0 == 1 ? true : false}).bind(to: averageConsumptionOutTF.rx.isUserInteractionEnabled).disposed(by:bag)
            
            customVehicleNameTF.keyboardType = .default
            customVehicleNameTF.placeholder = "Type a name"
            customVehicleNameTF.font = CardParts.theme.normalTextFont
            customVehicleNameTF.textColor = CardParts.theme.normalTextColor
            
            let vehicleNameItem = CardPartsUtil.generateCenteredItemWithTextField(letfLabelText: "Vehicle Name", rightTextField: customVehicleNameTF)
            
            // viewModel - textField bind
            viewModel.customVehicleName.asObservable().bind(to: customVehicleNameTF.rx.text).disposed(by: bag)
            // textField - viewModel bind
            customVehicleNameTF.rx.text.orEmpty.bind(to: viewModel.customVehicleName).disposed(by: bag)
            // editable - bind
            viewModel.customVehicleSelectedIndex.asObservable().map({$0 == 1 ? true : false}).bind(to: customVehicleNameTF.rx.isUserInteractionEnabled).disposed(by:bag)
            
//            let customConsumptionTypeItem = CardPartsUtil.generateCenteredItemWithSegmentedControl(letfLabelText: "Custom Consumption Type", rightSegmentedControl: customConsumptionTypeSC)
            
            // viewModel - selection bind
            viewModel.customConsumptionTypeIndex.asObservable().bind(to: customConsumptionTypeSC.rx.selectedSegmentIndex).disposed(by: bag)
            // selection - viewModel bind
            customConsumptionTypeSC.rx.selectedSegmentIndex.bind(to: viewModel.customConsumptionTypeIndex).disposed(by: bag)
            // editable - bind
            viewModel.customConsumptionIndex.asObservable().map({$0 == 1 ? true : false}).bind(to: customConsumptionTypeSC.rx.isUserInteractionEnabled).disposed(by:bag)
            
            let mainSVVertical = CardPartStackView()
            mainSVVertical.spacing = 10
            mainSVVertical.distribution = .fillEqually
            mainSVVertical.axis = .vertical
            mainSVVertical.addArrangedSubview(customVehicleSC as UIView)
            mainSVVertical.addArrangedSubview(customConsumptionSC as UIView)
            mainSVVertical.addArrangedSubview(customConsumptionTypeSC as UIView)
            mainSVVertical.addArrangedSubview(vehiclePlateItem as! UIView)
            mainSVVertical.addArrangedSubview(vehicleNameItem as! UIView)
            mainSVVertical.addArrangedSubview(averageLocalItem as! UIView)
            mainSVVertical.addArrangedSubview(averageOutItem as! UIView)
            
            setupCardParts([titlePart, seperator, mainSVVertical])
        }
    }
    
    class OverallDetailVC : CardPartsViewController {
        weak  var viewModel: AccountVehicleDetailVM!
        
        public init(_ viewModel: AccountVehicleDetailVM) {
            super.init(nibName: nil, bundle: nil)
            self.viewModel = viewModel
        }
        
        required public init(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        override func viewDidLoad() {
            super.viewDidLoad()
            let detail = self.viewModel.accountVehicle.vehicle
            
            let overall = CardPartTextView(type: .title)
            overall.label.font = CardParts.theme.headerTextFont
            overall.label.text = "Overall"
            
            let seperator = CardPartSeparatorView()
            let mainSVVertical = CardPartStackView()
            mainSVVertical.spacing = 10
            mainSVVertical.distribution = .fill
            mainSVVertical.axis = .vertical
            
            if(detail != nil){
                let vehicleType = "\(detail?.newVehicleType ?? "-") / \(detail?.autoClass ?? "-") Segment"
                mainSVVertical.addArrangedSubview(CardPartsUtil.generateCenteredItem(letfLabelText: "Vehicle Type", rightLabelText: vehicleType))
                mainSVVertical.addArrangedSubview(CardPartsUtil.generateCenteredItem(letfLabelText: "Body Type / Door Number", rightLabelText: "\(detail?.body ?? "-") Doors"))
                let engineType = "\(detail?.getFuelTypeString() ?? "-") / \(detail?.cylinders ?? 0) Cylinders"
                mainSVVertical.addArrangedSubview(CardPartsUtil.generateCenteredItem(letfLabelText: "Engine Type", rightLabelText: engineType))
                mainSVVertical.addArrangedSubview(CardPartsUtil.generateCenteredItem(letfLabelText: "Engine Power", rightLabelText: "\(detail?.hp ?? 0) Hp"))
                let yearsOfProduction = "\(detail?.startYear ?? "-") / \(detail?.endYear ?? "-")"
                mainSVVertical.addArrangedSubview(CardPartsUtil.generateCenteredItem(letfLabelText: "Year Of Production(Begin/End)", rightLabelText: yearsOfProduction))
                mainSVVertical.addArrangedSubview(CardPartsUtil.generateCenteredItem(letfLabelText: "Transmission", rightLabelText: detail?.transmission ?? "-"))
            }
            
            setupCardParts([overall, seperator, mainSVVertical])
        }
    }
    
    class EnginePerformanceDetailVC : CardPartsViewController {
        weak  var viewModel: AccountVehicleDetailVM!
        
        public init(_ viewModel: AccountVehicleDetailVM) {
            super.init(nibName: nil, bundle: nil)
            self.viewModel = viewModel
        }
        
        required public init(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        override func viewDidLoad() {
            super.viewDidLoad()
            let detail = self.viewModel.accountVehicle.vehicle
            
            let title = CardPartTextView(type: .title)
            title.label.font = CardParts.theme.headerTextFont
            title.label.text = "Engine & Performance"
            
            let seperator = CardPartSeparatorView()
            let mainSVVertical = CardPartStackView()
            mainSVVertical.spacing = 10
            mainSVVertical.distribution = .fill
            mainSVVertical.axis = .vertical
            
            if(detail != nil){
                let engineType = "\(detail?.getFuelTypeString() ?? "-") / \(detail?.cylinders ?? 0) Cylinders"
                mainSVVertical.addArrangedSubview(CardPartsUtil.generateCenteredItem(letfLabelText: "Engine Type", rightLabelText: engineType))
                mainSVVertical.addArrangedSubview(CardPartsUtil.generateCenteredItem(letfLabelText: "Engine Capacity", rightLabelText: "\(detail?.ccm ?? 0) cc"))
                mainSVVertical.addArrangedSubview(CardPartsUtil.generateCenteredItem(letfLabelText: "Maximum Power", rightLabelText: "\(detail?.hp ?? 0) hp (\(detail?.kw ?? 0) kw) / \(detail?.rpm1 ?? 0) rpm"))
                mainSVVertical.addArrangedSubview(CardPartsUtil.generateCenteredItem(letfLabelText: "Maximum Tork", rightLabelText: "\(detail?.torque ?? 0) nm / \(detail?.rpm2 ?? 0) rpm"))
                mainSVVertical.addArrangedSubview(CardPartsUtil.generateCenteredItem(letfLabelText: "Acceleration(0-100 km/h)", rightLabelText: "\(detail?.acceleration ?? "-") seconds"))
                mainSVVertical.addArrangedSubview(CardPartsUtil.generateCenteredItem(letfLabelText: "Top Speed", rightLabelText: "\(detail?.topSpeed ?? 0) km/h"))
            }
            
            setupCardParts([title, seperator, mainSVVertical])
        }
    }
    
    class FuelConsumptionDetailVC : CardPartsViewController {
        weak  var viewModel: AccountVehicleDetailVM!
        
        public init(_ viewModel: AccountVehicleDetailVM) {
            super.init(nibName: nil, bundle: nil)
            self.viewModel = viewModel
        }
        
        required public init(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        override func viewDidLoad() {
            super.viewDidLoad()
            let detail = self.viewModel.accountVehicle.vehicle
            
            let title = CardPartTextView(type: .title)
            title.label.font = CardParts.theme.headerTextFont
            title.label.text = "Fuel Consumption"
            
            let seperator = CardPartSeparatorView()
            let mainSVVertical = CardPartStackView()
            mainSVVertical.spacing = 10
            mainSVVertical.distribution = .fill
            mainSVVertical.axis = .vertical
            
            if(detail != nil){
                let fuelType = "\(detail?.getFuelTypeString() ?? "") / \(detail?.emission ?? "-")"
                mainSVVertical.addArrangedSubview(CardPartsUtil.generateCenteredItem(letfLabelText: "Fuel Type", rightLabelText: fuelType))
                mainSVVertical.addArrangedSubview(CardPartsUtil.generateCenteredItem(letfLabelText: "Local (100 km/h)", rightLabelText: "\(detail?.udc ?? "-") lt"))
                mainSVVertical.addArrangedSubview(CardPartsUtil.generateCenteredItem(letfLabelText: "Intercity (100 km/h)", rightLabelText: "\(detail?.eudc ?? "-") lt"))
                mainSVVertical.addArrangedSubview(CardPartsUtil.generateCenteredItem(letfLabelText: "Average (100 km/h)", rightLabelText: "\(detail?.nedc ?? "-") lt"))
                mainSVVertical.addArrangedSubview(CardPartsUtil.generateCenteredItem(letfLabelText: "Fuel Depot Capacity", rightLabelText: "\(detail?.fuelcap ?? 0) lt"))
            }
            
            setupCardParts([title, seperator, mainSVVertical])
        }
    }
    
    class DimensionsDetailVC : CardPartsViewController {
        weak  var viewModel: AccountVehicleDetailVM!
        
        public init(_ viewModel: AccountVehicleDetailVM) {
            super.init(nibName: nil, bundle: nil)
            self.viewModel = viewModel
        }
        
        required public init(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        override func viewDidLoad() {
            super.viewDidLoad()
            let detail = self.viewModel.accountVehicle.vehicle
            
            let title = CardPartTextView(type: .title)
            title.label.font = CardParts.theme.headerTextFont
            title.label.text = "Dimensions"
            
            let seperator = CardPartSeparatorView()
            let mainSVVertical = CardPartStackView()
            mainSVVertical.spacing = 10
            mainSVVertical.distribution = .fill
            mainSVVertical.axis = .vertical
            
            if(detail != nil){
                mainSVVertical.addArrangedSubview(CardPartsUtil.generateCenteredItem(letfLabelText: "Number of Seats", rightLabelText: "\(detail?.seats ?? 0) Seats"))
                mainSVVertical.addArrangedSubview(CardPartsUtil.generateCenteredItem(letfLabelText: "Length", rightLabelText: "\(detail?.length ?? 0) mm"))
                mainSVVertical.addArrangedSubview(CardPartsUtil.generateCenteredItem(letfLabelText: "Width", rightLabelText: "\(detail?.width ?? 0) mm"))
                mainSVVertical.addArrangedSubview(CardPartsUtil.generateCenteredItem(letfLabelText: "Height", rightLabelText: "\(detail?.height ?? 0) mm"))
                mainSVVertical.addArrangedSubview(CardPartsUtil.generateCenteredItem(letfLabelText: "Net Weight", rightLabelText: "\(detail?.loadedWeight ?? 0) kg"))
                mainSVVertical.addArrangedSubview(CardPartsUtil.generateCenteredItem(letfLabelText: "Carrying Capacity", rightLabelText: "\(detail?.unloadedWeight ?? 0) kg"))
                mainSVVertical.addArrangedSubview(CardPartsUtil.generateCenteredItem(letfLabelText: "Luggage Capacity", rightLabelText: "\(detail?.luggageCapacity ?? 0) lt"))
                mainSVVertical.addArrangedSubview(CardPartsUtil.generateCenteredItem(letfLabelText: "Wheel Dimensions", rightLabelText: "\(detail?.tyresFront ?? "-")"))
            }
            
            setupCardParts([title, seperator, mainSVVertical])
        }
    }
}
