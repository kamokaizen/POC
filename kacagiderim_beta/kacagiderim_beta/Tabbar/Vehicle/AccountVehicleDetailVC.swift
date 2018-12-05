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
    
    class MainVC : BaseCardPartsViewController {
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
            
            let brand = CardPartTextView(type: .title)
            brand.label.font = CardParts.theme.headerTextFont
            brand.label.text = (viewModel.accountVehicle.vehicleBrand ?? "").uppercased()
            
            let model = CardPartTextView(type: .title)
            model.label.font = CardParts.theme.normalTextFont
            model.label.text = (viewModel.accountVehicle.vehicleDescription ?? "").uppercased()
            
            let brandLogo = CardPartImageView()
            viewModel.brandLogo.asObservable().bind(to: brandLogo.rx.image).disposed(by: bag)
            
            let modelImage = CardPartImageView()
            viewModel.vehiclePhoto.asObservable().bind(to: modelImage.rx.image).disposed(by: bag)
            
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
    
    class OptionalsVC : BaseCardPartsViewController {
        weak  var viewModel: AccountVehicleDetailVM!
        
        let buttonStack = CardPartTitleView(type: .titleWithMenu)
        let vehiclePlateTF = CardPartTextField(format: .none)
        let vehicleUsageTF = CardPartTextField(format: .none)
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
        
            vehicleUsageTF.keyboardType = .default
            vehicleUsageTF.placeholder = "Type your vehicle's usage"
            vehicleUsageTF.font = CardParts.theme.normalTextFont
            vehicleUsageTF.textColor = CardParts.theme.normalTextColor
            // viewModel - textField bind
            viewModel.usage.asObservable().bind(to: vehicleUsageTF.rx.text).disposed(by: bag)
            // textField - viewModel bind
            vehicleUsageTF.rx.text.orEmpty.bind(to: viewModel.usage).disposed(by: bag)
            
            let vehicleUsageItem = CardPartsUtil.generateCenteredItemWithTextField(letfLabelText: "Vehicle Usage", rightTextField: vehicleUsageTF)
            
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
            mainSVVertical.addArrangedSubview(vehicleUsageItem as! UIView)
            mainSVVertical.addArrangedSubview(vehicleNameItem as! UIView)
            mainSVVertical.addArrangedSubview(averageLocalItem as! UIView)
            mainSVVertical.addArrangedSubview(averageOutItem as! UIView)
            
            setupCardParts([titlePart, seperator, mainSVVertical])
        }
    }
    
    class OverallDetailVC : BaseCardPartsViewController {
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
            
            let overall = CardPartTextView(type: .title)
            overall.label.font = CardParts.theme.headerTextFont
            overall.label.text = "Overall"
            
            let seperator = CardPartSeparatorView()
            let mainSVVertical = CardPartStackView()
            mainSVVertical.spacing = 10
            mainSVVertical.distribution = .fill
            mainSVVertical.axis = .vertical
        
            let vehicleTypeLabel = CardPartTextView(type: .normal)
            let bodyTypeLabel = CardPartTextView(type: .normal)
            let engineTypeLabel = CardPartTextView(type: .normal)
            let enginePowerLabel = CardPartTextView(type: .normal)
            let productionYearLabel = CardPartTextView(type: .normal)
            let transmissionLabel = CardPartTextView(type: .normal)
            self.viewModel.vehicleType.asObservable().bind(to: vehicleTypeLabel.rx.text).disposed(by: bag)
            self.viewModel.bodyType.asObservable().bind(to: bodyTypeLabel.rx.text).disposed(by: bag)
            self.viewModel.engineType.asObservable().bind(to: engineTypeLabel.rx.text).disposed(by: bag)
            self.viewModel.enginePower.asObservable().bind(to: enginePowerLabel.rx.text).disposed(by: bag)
            self.viewModel.productionYear.asObservable().bind(to: productionYearLabel.rx.text).disposed(by: bag)
            self.viewModel.transmission.asObservable().bind(to: transmissionLabel.rx.text).disposed(by: bag)
            mainSVVertical.addArrangedSubview(CardPartsUtil.generateCenteredItem(letfLabelText: "Vehicle Type", rightLabel: vehicleTypeLabel))
            mainSVVertical.addArrangedSubview(CardPartsUtil.generateCenteredItem(letfLabelText: "Body Type / Door Number", rightLabel: bodyTypeLabel))
            mainSVVertical.addArrangedSubview(CardPartsUtil.generateCenteredItem(letfLabelText: "Engine Type", rightLabel: engineTypeLabel))
            mainSVVertical.addArrangedSubview(CardPartsUtil.generateCenteredItem(letfLabelText: "Engine Power", rightLabel: enginePowerLabel))
            mainSVVertical.addArrangedSubview(CardPartsUtil.generateCenteredItem(letfLabelText: "Year Of Production(Begin/End)", rightLabel: productionYearLabel))
            mainSVVertical.addArrangedSubview(CardPartsUtil.generateCenteredItem(letfLabelText: "Transmission", rightLabel: transmissionLabel))
                        
            setupCardParts([overall, seperator, mainSVVertical])
        }
    }
    
    class EnginePerformanceDetailVC : BaseCardPartsViewController {
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
            
            let title = CardPartTextView(type: .title)
            title.label.font = CardParts.theme.headerTextFont
            title.label.text = "Engine & Performance"
            
            let seperator = CardPartSeparatorView()
            let mainSVVertical = CardPartStackView()
            mainSVVertical.spacing = 10
            mainSVVertical.distribution = .fill
            mainSVVertical.axis = .vertical
            
            let engineTypeLabel = CardPartTextView(type: .normal)
            let engineCapacityLabel = CardPartTextView(type: .normal)
            let maximumPowerLabel = CardPartTextView(type: .normal)
            let maximumTorkLabel = CardPartTextView(type: .normal)
            let accelerationLabel = CardPartTextView(type: .normal)
            let topSpeedLabel = CardPartTextView(type: .normal)
            self.viewModel.engineType.asObservable().bind(to: engineTypeLabel.rx.text).disposed(by: bag)
            self.viewModel.engineCapacity.asObservable().bind(to: engineCapacityLabel.rx.text).disposed(by: bag)
            self.viewModel.maximumPower.asObservable().bind(to: maximumPowerLabel.rx.text).disposed(by: bag)
            self.viewModel.maximumTork.asObservable().bind(to: maximumTorkLabel.rx.text).disposed(by: bag)
            self.viewModel.acceleration.asObservable().bind(to: accelerationLabel.rx.text).disposed(by: bag)
            self.viewModel.topSpeed.asObservable().bind(to: topSpeedLabel.rx.text).disposed(by: bag)
            mainSVVertical.addArrangedSubview(CardPartsUtil.generateCenteredItem(letfLabelText: "Engine Type", rightLabel: engineTypeLabel))
            mainSVVertical.addArrangedSubview(CardPartsUtil.generateCenteredItem(letfLabelText: "Engine Capacity", rightLabel: engineCapacityLabel))
            mainSVVertical.addArrangedSubview(CardPartsUtil.generateCenteredItem(letfLabelText: "Maximum Power", rightLabel: maximumPowerLabel))
            mainSVVertical.addArrangedSubview(CardPartsUtil.generateCenteredItem(letfLabelText: "Maximum Tork", rightLabel: maximumTorkLabel))
            mainSVVertical.addArrangedSubview(CardPartsUtil.generateCenteredItem(letfLabelText: "Acceleration(0-100 km/h)", rightLabel: accelerationLabel))
            mainSVVertical.addArrangedSubview(CardPartsUtil.generateCenteredItem(letfLabelText: "Top Speed", rightLabel: topSpeedLabel))
            
            setupCardParts([title, seperator, mainSVVertical])
        }
    }
    
    class FuelConsumptionDetailVC : BaseCardPartsViewController {
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
            
            let title = CardPartTextView(type: .title)
            title.label.font = CardParts.theme.headerTextFont
            title.label.text = "Fuel Consumption"
            
            let seperator = CardPartSeparatorView()
            let mainSVVertical = CardPartStackView()
            mainSVVertical.spacing = 10
            mainSVVertical.distribution = .fill
            mainSVVertical.axis = .vertical
            
            let fuelTypeLabel = CardPartTextView(type: .normal)
            let udcLabel = CardPartTextView(type: .normal)
            let eudcLabel = CardPartTextView(type: .normal)
            let nedcLabel = CardPartTextView(type: .normal)
            let fuelCapLabel = CardPartTextView(type: .normal)
            self.viewModel.fuelType.asObservable().bind(to: fuelTypeLabel.rx.text).disposed(by: bag)
            self.viewModel.udc.asObservable().bind(to: udcLabel.rx.text).disposed(by: bag)
            self.viewModel.eudc.asObservable().bind(to: eudcLabel.rx.text).disposed(by: bag)
            self.viewModel.nedc.asObservable().bind(to: nedcLabel.rx.text).disposed(by: bag)
            self.viewModel.fuelCap.asObservable().bind(to: fuelCapLabel.rx.text).disposed(by: bag)
            mainSVVertical.addArrangedSubview(CardPartsUtil.generateCenteredItem(letfLabelText: "Fuel Type", rightLabel: fuelTypeLabel))
            mainSVVertical.addArrangedSubview(CardPartsUtil.generateCenteredItem(letfLabelText: "Local (100 km/h)", rightLabel: udcLabel))
            mainSVVertical.addArrangedSubview(CardPartsUtil.generateCenteredItem(letfLabelText: "Out (100 km/h)", rightLabel: eudcLabel))
            mainSVVertical.addArrangedSubview(CardPartsUtil.generateCenteredItem(letfLabelText: "Average (100 km/h)", rightLabel: nedcLabel))
            mainSVVertical.addArrangedSubview(CardPartsUtil.generateCenteredItem(letfLabelText: "Fuel Depot Capacity", rightLabel: fuelCapLabel))
            
            setupCardParts([title, seperator, mainSVVertical])
        }
    }
    
    class DimensionsDetailVC : BaseCardPartsViewController {
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
            
            let title = CardPartTextView(type: .title)
            title.label.font = CardParts.theme.headerTextFont
            title.label.text = "Dimensions"
            
            let seperator = CardPartSeparatorView()
            let mainSVVertical = CardPartStackView()
            mainSVVertical.spacing = 10
            mainSVVertical.distribution = .fill
            mainSVVertical.axis = .vertical
            
            let numberOfSeatsLabel = CardPartTextView(type: .normal)
            let lengthLabel = CardPartTextView(type: .normal)
            let widthLabel = CardPartTextView(type: .normal)
            let heightLabel = CardPartTextView(type: .normal)
            let loadedWeightLabel = CardPartTextView(type: .normal)
            let unloadedWeightLabel = CardPartTextView(type: .normal)
            let luggageLabel = CardPartTextView(type: .normal)
            let tyresLabel = CardPartTextView(type: .normal)
            self.viewModel.seats.asObservable().bind(to: numberOfSeatsLabel.rx.text).disposed(by: bag)
            self.viewModel.length.asObservable().bind(to: lengthLabel.rx.text).disposed(by: bag)
            self.viewModel.width.asObservable().bind(to: widthLabel.rx.text).disposed(by: bag)
            self.viewModel.height.asObservable().bind(to: heightLabel.rx.text).disposed(by: bag)
            self.viewModel.loadedWeight.asObservable().bind(to: loadedWeightLabel.rx.text).disposed(by: bag)
            self.viewModel.unloadedWeight.asObservable().bind(to: unloadedWeightLabel.rx.text).disposed(by: bag)
            self.viewModel.luggageCapacity.asObservable().bind(to: luggageLabel.rx.text).disposed(by: bag)
            self.viewModel.tyresFront.asObservable().bind(to: tyresLabel.rx.text).disposed(by: bag)
            mainSVVertical.addArrangedSubview(CardPartsUtil.generateCenteredItem(letfLabelText: "Number of Seats", rightLabel: numberOfSeatsLabel))
            mainSVVertical.addArrangedSubview(CardPartsUtil.generateCenteredItem(letfLabelText: "Length", rightLabel: lengthLabel))
            mainSVVertical.addArrangedSubview(CardPartsUtil.generateCenteredItem(letfLabelText: "Width", rightLabel: widthLabel))
            mainSVVertical.addArrangedSubview(CardPartsUtil.generateCenteredItem(letfLabelText: "Height", rightLabel: heightLabel))
            mainSVVertical.addArrangedSubview(CardPartsUtil.generateCenteredItem(letfLabelText: "Net Weight", rightLabel: loadedWeightLabel))
            mainSVVertical.addArrangedSubview(CardPartsUtil.generateCenteredItem(letfLabelText: "Carrying Capacity", rightLabel: unloadedWeightLabel))
            mainSVVertical.addArrangedSubview(CardPartsUtil.generateCenteredItem(letfLabelText: "Luggage Capacity", rightLabel: luggageLabel))
            mainSVVertical.addArrangedSubview(CardPartsUtil.generateCenteredItem(letfLabelText: "Wheel Dimensions", rightLabel: tyresLabel))
            
            setupCardParts([title, seperator, mainSVVertical])
        }
    }
}
