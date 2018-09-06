//
//  ProfileViewController.swift
//  kacagiderim_beta
//
//  Created by Comodo on 16.07.2018.
//  Copyright © 2018 kacagiderim. All rights reserved.
//

import UIKit
import DCKit
import Dodo
import McPicker
import CardParts
import RxSwift
import RxCocoa
import NVActivityIndicatorView

class ProfileViewController: CardsViewController {
    
    static let typeList:[String] = [UserType.INDIVIDUAL.rawValue, UserType.COMPANY.rawValue]
    var viewModel: ProfileViewModel!
    var cards: [CardController] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel = ProfileViewModel(rootViewController: self)
        self.cards = [LoggedInCardController(viewModel:viewModel),
                      ProfileCardController(viewModel:viewModel),
                      MetricsCardContoller(viewModel:viewModel),
                      FavouriteCitiesContoller(viewModel:viewModel),
                      UpdateController(viewModel: viewModel)]
        loadCards(cards: cards)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.viewModel.refreshLocalData()
        self.viewModel.getProfileData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

class UpdateController: CardPartsViewController, NVActivityIndicatorViewable, ShadowCardTrait, RoundedCardTrait{
    
    var viewModel: ProfileViewModel!
    var updateButton: DCBorderedButton! = DCBorderedButton()
    var stack = CardPartStackView()
    
    public init(viewModel: ProfileViewModel) {
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
    
    // The value can be from 0.0 to 1.0.
    // 0.0 => lighter shadow
    // 1.0 => darker shadow
    func shadowOpacity() -> Float {
        return 1.0
    }
    
    func cornerRadius() -> CGFloat {
        return 10.0
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        stack.axis = .vertical
        stack.spacing = 0
    
        updateButton.setTitle("Save All Changes", for: UIControlState.normal)
        updateButton.setTitleColor(UIColor.red, for: UIControlState.normal)
        updateButton.backgroundColor = UIColor.clear
        updateButton.highlightedBackgroundColor = UIColor.clear
        updateButton.normalBackgroundColor = UIColor.clear
        updateButton.selectedBorderColor = UIColor.clear
        updateButton.normalBorderColor = UIColor.clear
//        updateButton.cornerRadius = 10
        updateButton.addTarget(self, action: #selector(updateButtonTapped), for: .touchUpInside)
        
        stack.addArrangedSubview(updateButton)
        setupCardParts([stack])
    }
    
    @objc func updateButtonTapped() {
        self.viewModel.updateProfileData(viewController:self)
    }
}

class FavouriteCitiesContoller: CardPartsViewController, EditableCardTrait, ShadowCardTrait, RoundedCardTrait {
    
    var viewModel: ProfileViewModel!
    var titlePart = CardPartTitleView(type: .titleOnly)
    var cardPartSeparatorView = CardPartSeparatorView()
    let cardPartTableView = CardPartTableView()
    
    public init(viewModel: ProfileViewModel) {
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
    
    // The value can be from 0.0 to 1.0.
    // 0.0 => lighter shadow
    // 1.0 => darker shadow
    func shadowOpacity() -> Float {
        return 1.0
    }
    
    func cornerRadius() -> CGFloat {
        return 10.0
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titlePart.label.text = "Favourite Cities"
        
        cardPartTableView.tableView.register(MyCustomTableViewCell.self, forCellReuseIdentifier: "MyCustomTableViewCell")

        viewModel.favouriteCities.asObservable().bind(to: cardPartTableView.tableView.rx.items) { tableView, index, data in
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "MyCustomTableViewCell", for: IndexPath(item: index, section: 0)) as? MyCustomTableViewCell else { return UITableViewCell() }
            
            cell.setData(data:data, viewModel: self.viewModel)
            
            return cell
        }.disposed(by: bag)
        
        setupCardParts([titlePart, cardPartSeparatorView, cardPartTableView])
    }
    
    func onEditButtonTap(){
        print("Editable Mode:", isEditable())
        self.viewModel.getCitiesOfCountryPopoper(countryId: self.viewModel.countryId.value, viewController: self, sourceView: self.titlePart);
    }
}

class LoggedInCardController: CardPartsViewController, ShadowCardTrait, RoundedCardTrait{
    var titlePart = CardPartTitleView(type: .titleOnly)
    var activeUser = CardPartTextView(type: .normal)
    var cardPartSeparatorView = CardPartSeparatorView()
    var loggedOutButton = CardPartButtonView()
    var logoImage = CardPartImageView(image: UIImage(named: "profile.png"))
    
    var leftStack = CardPartStackView()
    var rightStack = CardPartStackView()
    var separator = CardPartVerticalSeparatorView()
    var viewModel: ProfileViewModel!
    
    public init(viewModel: ProfileViewModel) {
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
    
    // The value can be from 0.0 to 1.0.
    // 0.0 => lighter shadow
    // 1.0 => darker shadow
    func shadowOpacity() -> Float {
        return 1.0
    }
    
    func cornerRadius() -> CGFloat {
        return 10.0
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titlePart.label.text = "Current User"
        activeUser.text = UserDefaults.standard.string(forKey: "activeUser")
        activeUser.textColor = K.Constants.kacagiderimColor
        
        logoImage.addConstraint(NSLayoutConstraint(item: logoImage, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1.0, constant: 30.0))
        logoImage.addConstraint(NSLayoutConstraint(item: logoImage, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1.0, constant: 30.0))
        logoImage.contentMode = .scaleAspectFit;
        
        loggedOutButton.setTitle("Log Out", for: .normal)
        loggedOutButton.addTarget(self, action: #selector(logoutButtonTapped), for: .touchUpInside)
        loggedOutButton.titleLabel?.font = CardParts.theme.normalTextFont
        loggedOutButton.setTitleColor(K.Constants.kacagiderimColorWarning, for: .normal)
        
        leftStack.axis = .vertical
        leftStack.spacing = 10
        
        rightStack.axis = .horizontal
        rightStack.spacing = 10
        
        leftStack.addArrangedSubview(activeUser)
        rightStack.addArrangedSubview(logoImage)
        rightStack.addArrangedSubview(loggedOutButton)
        
        let centeredView = CardPartCenteredView(leftView: leftStack, centeredView: separator, rightView: rightStack)
        
        setupCardParts([titlePart, cardPartSeparatorView, centeredView])
    }
    
    // change password button action
    @objc func logoutButtonTapped() {
        TokenController.deleteUserFromUserDefaults()
        Switcher.updateRootVC()
    }
}

class MetricsCardContoller: CardPartsViewController, ShadowCardTrait, RoundedCardTrait {
    var viewModel : ProfileViewModel!
    var titlePart = CardPartTitleView(type: .titleOnly)
    var cardPartSeparatorView = CardPartSeparatorView()
    var currencyMetricButtonPart = CardPartButtonView()
    var distanceMetricButtonPart = CardPartButtonView()
    var volumeMetricButtonPart = CardPartButtonView()
    
    let seperator = CardPartVerticalSeparatorView()
    let seperator2 = CardPartVerticalSeparatorView()
    let seperator3 = CardPartVerticalSeparatorView()
    
    var volumeList: [[String]] = []
    var distanceList: [[String]] = []
    var currencyList: [[String]] = []
    
    public init(viewModel: ProfileViewModel) {
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
    
    // The value can be from 0.0 to 1.0.
    // 0.0 => lighter shadow
    // 1.0 => darker shadow
    func shadowOpacity() -> Float {
        return 1.0
    }
    
    func cornerRadius() -> CGFloat {
        return 10.0
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titlePart.label.text = "Metrics"
        
        let textView = CardPartTextView(type: .normal)
        let textView2 = CardPartTextView(type: .normal)
        let textView3 = CardPartTextView(type: .normal)
        textView.text = "Currency"
        textView.textColor = K.Constants.kacagiderimColor
        textView2.text = "Distance"
        textView2.textColor = K.Constants.kacagiderimColor
        textView3.text = "Volume"
        textView3.textColor = K.Constants.kacagiderimColor
        
        var list: [String] = []
        list.append(CurrencyMetrics.TRY.rawValue)
        list.append(CurrencyMetrics.EUR.rawValue)
        list.append(CurrencyMetrics.USD.rawValue)
        currencyList.removeAll()
        currencyList.append(list)
        
        list.removeAll()
        list.append(DistanceMetrics.KM.rawValue)
        list.append(DistanceMetrics.M.rawValue)
        list.append(DistanceMetrics.MILE.rawValue)
        distanceList.removeAll()
        distanceList.append(list)
        
        list.removeAll()
        list.append(VolumeMetrics.LITER.rawValue)
        list.append(VolumeMetrics.GALLON.rawValue)
        volumeList.removeAll()
        volumeList.append(list)
        
        currencyMetricButtonPart.setTitle("", for: .normal)
        currencyMetricButtonPart.addTarget(self, action: #selector(currencyButtonTapped), for: .touchUpInside)
        currencyMetricButtonPart.titleLabel?.font = CardParts.theme.normalTextFont
        currencyMetricButtonPart.setTitleColor(K.Constants.kacagiderimColorWarning, for: .normal)
        
        distanceMetricButtonPart.setTitle("", for: .normal)
        distanceMetricButtonPart.addTarget(self, action: #selector(distanceButtonTapped), for: .touchUpInside)
        distanceMetricButtonPart.titleLabel?.font = CardParts.theme.normalTextFont
        distanceMetricButtonPart.setTitleColor(K.Constants.kacagiderimColorWarning, for: .normal)
        
        volumeMetricButtonPart.setTitle("", for: .normal)
        volumeMetricButtonPart.addTarget(self, action: #selector(volumeButtonTapped), for: .touchUpInside)
        volumeMetricButtonPart.titleLabel?.font = CardParts.theme.normalTextFont
        volumeMetricButtonPart.setTitleColor(K.Constants.kacagiderimColorWarning, for: .normal)
        
        let centeredCardPart = CardPartCenteredView(leftView: textView, centeredView: seperator, rightView: currencyMetricButtonPart)
        let centeredCardPart2 = CardPartCenteredView(leftView: textView2, centeredView: seperator2, rightView: distanceMetricButtonPart)
        let centeredCardPart3 = CardPartCenteredView(leftView: textView3, centeredView: seperator3, rightView: volumeMetricButtonPart)
        
        viewModel.currencyMetric.asObservable().bind(to: currencyMetricButtonPart.rx.title()).disposed(by: bag)
        viewModel.distanceMetric.asObservable().bind(to: distanceMetricButtonPart.rx.title()).disposed(by: bag)
        viewModel.volumeMetric.asObservable().bind(to: volumeMetricButtonPart.rx.title()).disposed(by: bag)
        
        setupCardParts([titlePart, cardPartSeparatorView, centeredCardPart, centeredCardPart2, centeredCardPart3])
    }
    
    @objc func distanceButtonTapped(sender: UIButton) {
        let mcPicker = McPicker(data: self.distanceList)
        let fixedSpace = McPickerBarButtonItem.fixedSpace(width: 20.0)
        let flexibleSpace = McPickerBarButtonItem.flexibleSpace()
        let fireButton = McPickerBarButtonItem.done(mcPicker: mcPicker, title: "Ok")
        let cancelButton = McPickerBarButtonItem.cancel(mcPicker: mcPicker, barButtonSystemItem: .cancel)
        mcPicker.setToolbarItems(items: [fixedSpace, cancelButton, flexibleSpace, fireButton, fixedSpace])
        mcPicker.showAsPopover(fromViewController: self, sourceView: sender, cancelHandler: {
            print("cancelled")
        }, doneHandler: { (selections: [Int : String]) -> Void in
            if let name = selections[0] {
                print("Selected:" + name)
                self.viewModel.distanceMetric.value = name
            }})
    }
    
    @objc func volumeButtonTapped(sender: UIButton) {
        let mcPicker = McPicker(data: self.volumeList)
        let fixedSpace = McPickerBarButtonItem.fixedSpace(width: 20.0)
        let flexibleSpace = McPickerBarButtonItem.flexibleSpace()
        let fireButton = McPickerBarButtonItem.done(mcPicker: mcPicker, title: "Ok")
        let cancelButton = McPickerBarButtonItem.cancel(mcPicker: mcPicker, barButtonSystemItem: .cancel)
        mcPicker.setToolbarItems(items: [fixedSpace, cancelButton, flexibleSpace, fireButton, fixedSpace])
        mcPicker.showAsPopover(fromViewController: self, sourceView: sender, cancelHandler: {
            print("cancelled")
        }, doneHandler: { (selections: [Int : String]) -> Void in
            if let name = selections[0] {
                print("Selected:" + name)
                self.viewModel.volumeMetric.value = name
            }})
    }
    
    @objc func currencyButtonTapped(sender: UIButton) {
        let mcPicker = McPicker(data: self.currencyList)
        let fixedSpace = McPickerBarButtonItem.fixedSpace(width: 20.0)
        let flexibleSpace = McPickerBarButtonItem.flexibleSpace()
        let fireButton = McPickerBarButtonItem.done(mcPicker: mcPicker, title: "Ok")
        let cancelButton = McPickerBarButtonItem.cancel(mcPicker: mcPicker, barButtonSystemItem: .cancel)
        mcPicker.setToolbarItems(items: [fixedSpace, cancelButton, flexibleSpace, fireButton, fixedSpace])
        mcPicker.showAsPopover(fromViewController: self, sourceView: sender, cancelHandler: {
            print("cancelled")
        }, doneHandler: { (selections: [Int : String]) -> Void in
            if let name = selections[0] {
                print("Selected:" + name)
                self.viewModel.currencyMetric.value = name
            }})
    }
}

class ProfileCardController: CardPartsViewController, ShadowCardTrait, RoundedCardTrait {
    
    var viewModel : ProfileViewModel!
    var titlePart = CardPartTitleView(type: .titleOnly)
    var cardPartSeparatorView = CardPartSeparatorView()
    var usernameTextFieldPart = CardPartTextField(format: .none)
    var nameTextFieldPart = CardPartTextField(format: .none)
    var surnameTextFieldPart = CardPartTextField(format: .none)
    var passwordChangeButtonPart = CardPartButtonView()
    var ssnTextFieldPart = CardPartTextField(format: .none)
    var countryViewButtonPart = CardPartButtonView()
    var typeSegmentedControl = UISegmentedControl(items: ProfileViewController.typeList)
    
    let separator = CardPartVerticalSeparatorView()
    let separator2 = CardPartVerticalSeparatorView()
    let separator3 = CardPartVerticalSeparatorView()
    let separator4 = CardPartVerticalSeparatorView()
    let separator5 = CardPartVerticalSeparatorView()
    let separator6 = CardPartVerticalSeparatorView()
    let separator7 = CardPartVerticalSeparatorView()
    
    var countryList: [[String]] = []
    
    public init(viewModel: ProfileViewModel) {
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
    
    // The value can be from 0.0 to 1.0.
    // 0.0 => lighter shadow
    // 1.0 => darker shadow
    func shadowOpacity() -> Float {
        return 1.0
    }
    
    func cornerRadius() -> CGFloat {
        return 10.0
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titlePart.label.text = "Profile"
        
        var list: [String] = []
        for country in (self.viewModel.countries?.countries)! {
            list.append(country.countryName!)
        }
        countryList.removeAll()
        countryList.append(list.sorted(by: <))
        
        let textView = CardPartTextView(type: .normal)
        let textView2 = CardPartTextView(type: .normal)
        let textView3 = CardPartTextView(type: .normal)
        let textView4 = CardPartTextView(type: .normal)
        let textView5 = CardPartTextView(type: .normal)
        let textView6 = CardPartTextView(type: .normal)
        let textView7 = CardPartTextView(type: .normal)
        textView.text = "Username"
        textView.textColor = K.Constants.kacagiderimColor
        textView2.text = "Name"
        textView2.textColor = K.Constants.kacagiderimColor
        textView3.text = "Surname"
        textView3.textColor = K.Constants.kacagiderimColor
        textView4.text = "Password"
        textView4.textColor = K.Constants.kacagiderimColor
        textView5.text = "SSN"
        textView5.textColor = K.Constants.kacagiderimColor
        textView6.text = "Country"
        textView6.textColor = K.Constants.kacagiderimColor
        textView7.text = "User Type"
        textView7.textColor = K.Constants.kacagiderimColor
        
        usernameTextFieldPart.keyboardType = .default
        usernameTextFieldPart.placeholder = "Type a username"
        usernameTextFieldPart.font = CardParts.theme.normalTextFont
        usernameTextFieldPart.textColor = CardParts.theme.normalTextColor
        usernameTextFieldPart.addTarget(self, action: #selector(self.usernameTextFieldDidChange(_:)), for: UIControlEvents.editingChanged)
        
        nameTextFieldPart.keyboardType = .default
        nameTextFieldPart.placeholder = "Type a name"
        nameTextFieldPart.font = CardParts.theme.normalTextFont
        nameTextFieldPart.textColor = CardParts.theme.normalTextColor
        nameTextFieldPart.addTarget(self, action: #selector(self.nameTextFieldDidChange(_:)), for: UIControlEvents.editingChanged)
        
        surnameTextFieldPart.keyboardType = .default
        surnameTextFieldPart.placeholder = "Type a surname"
        surnameTextFieldPart.font = CardParts.theme.normalTextFont
        surnameTextFieldPart.textColor = CardParts.theme.normalTextColor
        surnameTextFieldPart.addTarget(self, action: #selector(self.surnameTextFieldDidChange(_:)), for: UIControlEvents.editingChanged)
        
        passwordChangeButtonPart.setTitle("Change", for: .normal)
        passwordChangeButtonPart.setTitleColor(K.Constants.kacagiderimColorWarning, for: .normal)
        passwordChangeButtonPart.addTarget(self, action: #selector(passwordButtonTapped), for: .touchUpInside)
        passwordChangeButtonPart.titleLabel?.font = CardParts.theme.normalTextFont
        
        countryViewButtonPart.setTitle("", for: .normal)
        countryViewButtonPart.addTarget(self, action: #selector(countryButtonTapped), for: .touchUpInside)
        countryViewButtonPart.titleLabel?.font = CardParts.theme.normalTextFont
        countryViewButtonPart.setTitleColor(K.Constants.kacagiderimColorWarning, for: .normal)
        
        ssnTextFieldPart.keyboardType = .default
        ssnTextFieldPart.placeholder = "Type your SSN"
        ssnTextFieldPart.font = CardParts.theme.normalTextFont
        ssnTextFieldPart.textColor = CardParts.theme.normalTextColor
        ssnTextFieldPart.addTarget(self, action: #selector(self.ssnTextFieldDidChange(_:)), for: UIControlEvents.editingChanged)
        
        typeSegmentedControl.addTarget(self, action: #selector(typeValueChanged), for:UIControlEvents.valueChanged)
        
        let centeredCardPart = CardPartCenteredView(leftView: textView, centeredView: separator, rightView: usernameTextFieldPart)
        let centeredCardPart2 = CardPartCenteredView(leftView: textView2, centeredView: separator2, rightView: nameTextFieldPart)
        let centeredCardPart3 = CardPartCenteredView(leftView: textView3, centeredView: separator3, rightView: surnameTextFieldPart)
        let centeredCardPart4 = CardPartCenteredView(leftView: textView4, centeredView: separator4, rightView: passwordChangeButtonPart)
        let centeredCardPart5 = CardPartCenteredView(leftView: textView5, centeredView: separator5, rightView: ssnTextFieldPart)
        let centeredCardPart6 = CardPartCenteredView(leftView: textView6, centeredView: separator6, rightView: countryViewButtonPart)
        let stackView = CardPartStackView()
        stackView.addArrangedSubview(typeSegmentedControl)
        let centeredCardPart7 = CardPartCenteredView(leftView: textView7, centeredView: separator7, rightView: stackView)
        
        viewModel.usernameText.asObservable().bind(to: usernameTextFieldPart.rx.text).disposed(by: bag)
        viewModel.nameText.asObservable().bind(to: nameTextFieldPart.rx.text).disposed(by: bag)
        viewModel.surnameText.asObservable().bind(to: surnameTextFieldPart.rx.text).disposed(by: bag)
        viewModel.ssnText.asObservable().bind(to: ssnTextFieldPart.rx.text).disposed(by: bag)
        viewModel.countryName.asObservable().bind(to: countryViewButtonPart.rx.title()).disposed(by: bag)
        viewModel.type.asObservable().bind(to: typeSegmentedControl.rx.selectedSegmentIndex).disposed(by:bag)
        
        setupCardParts([titlePart, cardPartSeparatorView, centeredCardPart,centeredCardPart2,centeredCardPart3,centeredCardPart4,centeredCardPart5,centeredCardPart6,centeredCardPart7])
    }
    
    @objc func usernameTextFieldDidChange(_ textField: UITextField) {
        self.viewModel.usernameText.value = textField.text!
    }
    
    @objc func nameTextFieldDidChange(_ textField: UITextField) {
        self.viewModel.nameText.value = textField.text!
    }
    
    @objc func surnameTextFieldDidChange(_ textField: UITextField) {
        self.viewModel.surnameText.value = textField.text!
    }
    
    @objc func ssnTextFieldDidChange(_ textField: UITextField) {
        self.viewModel.ssnText.value = textField.text!
    }
    
    @objc func typeValueChanged(sender: UISegmentedControl) {
       self.viewModel.type.value = sender.selectedSegmentIndex
    }
    
    // change password button action
    @objc func passwordButtonTapped(sender: UIButton) {
        self.viewModel.rootViewController.performSegue(withIdentifier:"passwordChangeSegue", sender:sender)
    }
    
    @objc func countryButtonTapped(sender: UIButton) {
        let mcPicker = McPicker(data: self.countryList)
        let fixedSpace = McPickerBarButtonItem.fixedSpace(width: 20.0)
        let flexibleSpace = McPickerBarButtonItem.flexibleSpace()
        let fireButton = McPickerBarButtonItem.done(mcPicker: mcPicker, title: "Ok")
        let cancelButton = McPickerBarButtonItem.cancel(mcPicker: mcPicker, barButtonSystemItem: .cancel)
        mcPicker.setToolbarItems(items: [fixedSpace, cancelButton, flexibleSpace, fireButton, fixedSpace])
        mcPicker.showAsPopover(fromViewController: self, sourceView: sender, cancelHandler: {
            print("cancelled")
        }, doneHandler: { (selections: [Int : String]) -> Void in
            if let name = selections[0] {
                print("Selected:" + name)
                self.viewModel.countryName.value = name
                self.viewModel.setCountryId(countryName: name)
            }})
    }
}

class ProfileViewModel {
    var usernameText = Variable("")
    var nameText = Variable("")
    var surnameText = Variable("")
    var ssnText = Variable("")
    var countryId = Variable("")
    var countryName = Variable("")
    var type = Variable<Int>(0)
    
    var currencyMetric = Variable("")
    var distanceMetric = Variable("")
    var volumeMetric = Variable("")

    var countries:Countries?
    var cities: Cities?
    var citySelectionData: [[String]] = []
    let favouriteCities: Variable<[String]> = Variable([])
    
    var messageHelper = MessageHelper()
    var rootViewController:UIViewController
    
    init(rootViewController: UIViewController) {
        self.rootViewController = rootViewController
        refreshLocalData()
        getProfileData()
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
    
    func setCountryId(countryName: String) -> Void {
        if(self.countries != nil){
            for country in (self.countries?.countries)! {
                if(country.countryName == countryName){
                    self.countryId.value = country.countryId!
                    break;
                }
            }
        }
    }
    
    func getCitiesOfCountryPopoper(countryId: String, viewController: UIViewController, sourceView: UIView){
        APIClient.getCitiesOfCountry(countryId: countryId, completion:{ result in
        switch result {
            case .success(let citiesResponse):
                self.cities = citiesResponse.value;
                var list: [String] = []
                for city in (self.cities?.cities!)! {
                    list.append(city.cityName!)
                }
                self.citySelectionData.removeAll()
                self.citySelectionData.append(list.sorted(by: <))
            
                if(list.count > 0){
                    let mcPicker = McPicker(data: self.citySelectionData)
                    let fixedSpace = McPickerBarButtonItem.fixedSpace(width: 20.0)
                    let flexibleSpace = McPickerBarButtonItem.flexibleSpace()
                    let fireButton = McPickerBarButtonItem.done(mcPicker: mcPicker, title: "Ok")
                    let cancelButton = McPickerBarButtonItem.cancel(mcPicker: mcPicker, barButtonSystemItem: .cancel)
                    mcPicker.setToolbarItems(items: [fixedSpace, cancelButton, flexibleSpace, fireButton, fixedSpace])
                    
                    mcPicker.showAsPopover(fromViewController: viewController, sourceView: sourceView, cancelHandler: {
                        print("cancelled")
                    }, doneHandler: { (selections: [Int : String]) -> Void in
                        if let name = selections[0] {
                            print("Selected:" + name)
                            var selectedCities = UserDefaults.standard.value(forKeyPath: "selectedCities") as? [String];
                            if(selectedCities == nil){
                                selectedCities = []
                            }
                            selectedCities!.append(name)
                            selectedCities = Array(Set(selectedCities!))
                            UserDefaults.standard.set(selectedCities, forKey: "selectedCities");
                            self.favouriteCities.value = (selectedCities?.sorted(by:<))!;
                        }})
                }
                else{
                    // show error
                }
            case .failure(let error):
            print((error as! CustomError).localizedDescription)
        }
        })
    }
    
    func deleteCityFromSelectedCities(cityName: String) -> Void {
        // remove from userdefaults
        var selectedCities = UserDefaults.standard.value(forKeyPath: "selectedCities") as? [String];
        if(selectedCities == nil){
            selectedCities = []
        }
        if let indexInSelectedCities = selectedCities!.index(of:cityName) {
            selectedCities!.remove(at: indexInSelectedCities)
        }
        print(selectedCities!)
        UserDefaults.standard.set(selectedCities, forKey: "selectedCities");
        self.favouriteCities.value = (selectedCities?.sorted(by: <))!
    }
    
    func refreshLocalData(){
        if let data = UserDefaults.standard.value(forKey:"countries") as? Data {
            self.countries = try? PropertyListDecoder().decode(Countries.self, from: data)
        }
        if let selectedCities:[String] = UserDefaults.standard.value(forKeyPath: "selectedCities") as? [String]{
            self.favouriteCities.value = selectedCities.sorted(by: <)
        }
    }
    
    func getProfileData(){
        APIClient.getCurrentUser(completion:{ result in
            switch result {
            case .success(let userResponse):
                let profile:User = (userResponse.value as User?)!
                UserDefaults.standard.set(try? PropertyListEncoder().encode(profile), forKey: "userProfile")
                self.usernameText.value = profile.username
                self.nameText.value = profile.name
                self.surnameText.value = profile.surname
                if(profile.socialSecurityNumber != nil){
                    self.ssnText.value = profile.socialSecurityNumber!
                }
                self.currencyMetric.value = profile.currencyMetric.rawValue
                self.distanceMetric.value = profile.distanceMetric.rawValue
                self.volumeMetric.value = profile.volumeMetric.rawValue
                self.type.value = ProfileViewController.typeList.index(of: profile.userType.rawValue)!
                
                self.countryId.value = profile.countryId
                self.countryName.value = self.getCountryName(countryId: profile.countryId)
            case .failure(let error):
                print((error as! CustomError).localizedDescription)
            }
        })
    }
    
    func updateProfileData(viewController: UpdateController){
        let user = User(username: self.usernameText.value,
                        name: self.nameText.value,
                        surname: self.surnameText.value,
                        countryId: self.countryId.value,
                        currencyMetric: CurrencyMetrics(rawValue: self.currencyMetric.value)!,
                        distanceMetric: DistanceMetrics(rawValue: self.distanceMetric.value)!,
                        volumeMetric: VolumeMetrics(rawValue: self.volumeMetric.value)!,
                        userType: UserType(rawValue: ProfileViewController.typeList[self.type.value])!,
                        socialSecurityNumber: self.ssnText.value)
        viewController.startAnimating(CGSize(width: 100, height: 100),message: "Profile Updating...", type: NVActivityIndicatorType.lineScale)
        APIClient.updateAccount(user: user, completion: { result in
            switch result {
            case .success(let updateResponse):
                viewController.stopAnimating()
                self.messageHelper.showInfoMessage(text: updateResponse.reason, view: self.rootViewController.view)
                self.getProfileData()
            case .failure(let error):
                print((error as! CustomError).localizedDescription)
                viewController.stopAnimating()
                self.messageHelper.showErrorMessage(text: (error as! CustomError).getErrorMessage(), view:self.rootViewController.view)
            }
        })
    }
}

