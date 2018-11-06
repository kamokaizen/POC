//
//  ProfileViewController.swift
//  kacagiderim_beta
//
//  Created by Comodo on 16.07.2018.
//  Copyright © 2018 kacagiderim. All rights reserved.
//

import UIKit
import DCKit
import McPicker
import CardParts
import RxSwift
import RxCocoa
import NVActivityIndicatorView
import GoogleMaps
import GoogleSignIn
import Kingfisher
import FacebookLogin
import SwiftEntryKit

class ProfileViewController: CardsViewController {
    
    static let typeList:[String] = [UserType.INDIVIDUAL.rawValue, UserType.COMPANY.rawValue]
    var viewModel: ProfileViewModel!
    var cards: [CardController] = []
    var messageHelper = MessageHelper()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel = ProfileViewModel(rootViewController: self)
        self.cards = [LoggedInCardController(viewModel:viewModel),
                      ProfileCardController(viewModel:viewModel),
                      MetricsCardContoller(viewModel:viewModel),
                      FavouriteCitiesContoller(viewModel:viewModel),
                      LocationController(viewModel: viewModel)]
        loadCards(cards: cards)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.viewModel.refreshLocalData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "mapLocationSelectorSegue"){
            let destinationViewController = segue.destination as? MapLocationSelector
            destinationViewController?.delegate = self.viewModel
        }
    }
}

class LocationController: CardPartsViewController, ShadowCardTrait, RoundedCardTrait, EditableCardTrait {
    weak  var viewModel: ProfileViewModel!
    var titlePart = CardPartTitleView(type: .titleOnly)
    var cardPartSeparatorView = CardPartSeparatorView()
    var homeImage = CardPartImageView(image: UIImage(named: "home.png"))
    var workImage = CardPartImageView(image: UIImage(named: "office.png"))
//    let editImage = CardPartImageView(image: UIImage(named: "edit.png"))
    var latitudeHomeTextView = CardPartTextView(type: .normal)
    var longitudeHomeTextView = CardPartTextView(type: .normal)
    var latitudeWorkTextView = CardPartTextView(type: .normal)
    var longitudeWorkTextView = CardPartTextView(type: .normal)
    
//    let homeEditButton = UIButton(type: UIButtonType.custom)
//    let workEditButton = UIButton(type: UIButtonType.custom)
    
    let homeSeparator = CardPartVerticalSeparatorView()
    let workSeparator = CardPartVerticalSeparatorView()
    var locationSeparator = CardPartSeparatorView()
    
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
        titlePart.label.text = "Locations"
        
        let stack = CardPartStackView()
        stack.axis = .horizontal
        stack.spacing = 10
        stack.distribution = .fillProportionally
        
//        homeEditButton.setImage(editImage.image, for: UIControlState.normal)
//        homeEditButton.addTarget(self, action:#selector(homeEditButtonTapped), for: .touchUpInside)
        
        let stackVertical = CardPartStackView()
        stackVertical.axis = .vertical
        stackVertical.spacing = 0
        stackVertical.distribution = .fillEqually
        
        let homeTextView = CardPartTextView(type: .normal)
        homeTextView.text = "Home"
        homeTextView.textColor = K.Constants.kacagiderimColor
        
        stackVertical.addArrangedSubview(homeTextView)
        let homeItem = CardPartCenteredView(leftView: latitudeHomeTextView, centeredView: homeSeparator, rightView: longitudeHomeTextView)
        stackVertical.addArrangedSubview(homeItem)
        
        stack.addArrangedSubview(homeImage)
        stack.addArrangedSubview(stackVertical)
//        stack.addArrangedSubview(homeEditButton)
        
        stack.addConstraint(NSLayoutConstraint(item: stackVertical, attribute: .width, relatedBy: .equal, toItem: homeImage, attribute: .width, multiplier: 6.0, constant: 0.0))
//        stack.addConstraint(NSLayoutConstraint(item: homeImage, attribute: .width, relatedBy: .equal, toItem: homeEditButton, attribute: .width, multiplier: 3.0, constant: 0.0))
        stack.addConstraint(NSLayoutConstraint(item: stack, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1.0, constant: 50.0))
//        homeEditButton.imageView?.contentMode = .scaleAspectFit;
        homeImage.contentMode = .scaleAspectFit;
        
        let workStack = CardPartStackView()
        workStack.axis = .horizontal
        workStack.spacing = 10
        workStack.distribution = .fillProportionally
        
//        workEditButton.setImage(editImage.image, for: UIControlState.normal)
//        workEditButton.addTarget(self, action:#selector(workEditButtonTapped), for: .touchUpInside)
        
        let workStackVertical = CardPartStackView()
        workStackVertical.axis = .vertical
        workStackVertical.spacing = 0
        workStackVertical.distribution = .fillEqually
        
        let workTextView = CardPartTextView(type: .normal)
        workTextView.text = "Work"
        workTextView.textColor = K.Constants.kacagiderimColor
        
        workStackVertical.addArrangedSubview(workTextView)
        let workItem = CardPartCenteredView(leftView: latitudeWorkTextView, centeredView: workSeparator, rightView: longitudeWorkTextView)
        workStackVertical.addArrangedSubview(workItem)
        
        workStack.addArrangedSubview(workImage)
        workStack.addArrangedSubview(workStackVertical)
//        workStack.addArrangedSubview(workEditButton)
        
        workStack.addConstraint(NSLayoutConstraint(item: workStackVertical, attribute: .width, relatedBy: .equal, toItem: workImage, attribute: .width, multiplier: 6.0, constant: 0.0))
//        workStack.addConstraint(NSLayoutConstraint(item: workImage, attribute: .width, relatedBy: .equal, toItem: workEditButton, attribute: .width, multiplier: 3.0, constant: 0.0))
        workStack.addConstraint(NSLayoutConstraint(item: workStack, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1.0, constant: 50.0))
//        workEditButton.imageView?.contentMode = .scaleAspectFit;
        workImage.contentMode = .scaleAspectFit;
        
        viewModel.homeLatitude.asObservable().bind(to: latitudeHomeTextView.rx.text).disposed(by:bag)
        viewModel.homeLongitude.asObservable().bind(to: longitudeHomeTextView.rx.text).disposed(by:bag)
        viewModel.workLatitude.asObservable().bind(to: latitudeWorkTextView.rx.text).disposed(by:bag)
        viewModel.workLongitude.asObservable().bind(to: longitudeWorkTextView.rx.text).disposed(by:bag)
        
        setupCardParts([titlePart, cardPartSeparatorView, stack, locationSeparator, workStack])
    }
    
    func onEditButtonTap(){
        self.viewModel.rootViewController?.performSegue(withIdentifier:"mapLocationSelectorSegue", sender:self.view)
    }
}

class FavouriteCitiesContoller: CardPartsViewController, EditableCardTrait, ShadowCardTrait, RoundedCardTrait {
    
    weak var viewModel: ProfileViewModel!
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
    weak var viewModel: ProfileViewModel!
    
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
        activeUser.text = DefaultManager.getActiveUsername()
        activeUser.textColor = K.Constants.kacagiderimColor
        
//        let image = UIImage(named: "profile.png")
//        let url = URL(string: self.viewModel.imageURL.value)
//        let processor = RoundCornerImageProcessor(cornerRadius: 20)
//        logoImage.kf.setImage(with: url, placeholder: image, options: [.processor(processor), .transition(.fade(0.2))])
        
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
        
        viewModel.profileImage.asObservable().bind(to: logoImage.rx.image).disposed(by: bag)
        
        setupCardParts([titlePart, cardPartSeparatorView, centeredView])
    }
    
    // change password button action
    @objc func logoutButtonTapped() {
        let attributes = Utils.getAttributes(element: EKAttributes.centerFloat,
                                             duration: .infinity,
                                             entryBackground: .color(color: .white),
                                             screenBackground: .color(color: .dimmedLightBackground),
                                             roundCorners: .all(radius: 25))
        
        // Ok Button - Make transition to a new entry when the button is tapped
        let okButtonLabelStyle = EKProperty.LabelStyle(font: MainFont.medium.with(size: 16), color: EKColor.Teal.a600)
        let okButtonLabel = EKProperty.LabelContent(text: "Sign out", style: okButtonLabelStyle)
        let okButton = EKProperty.ButtonContent(label: okButtonLabel, backgroundColor: .clear, highlightedBackgroundColor:  EKColor.Teal.a600.withAlphaComponent(0.05)) {
            SwiftEntryKit.dismiss()
            TokenController.deleteUserFromUserDefaults()

            // Google Logout
            GIDSignIn.sharedInstance().signOut()

            // Facebook logout
            let loginManager = LoginManager()
            loginManager.logOut()

            Switcher.updateRootVC()
            // From both memory and disk
            ImageCache.default.removeImage(forKey: "profile_image")
        }
        
        Utils.showAlertView(attributes: attributes, title: "Confirmation", desc: "Are you sure you want to sign out?", textColor: .black, imageName: "logo.png", imagePosition: .left, customButton: okButton)
    }
}

class MetricsCardContoller: CardPartsViewController, ShadowCardTrait, RoundedCardTrait, EditableCardTrait {
    weak var viewModel : ProfileViewModel!
    var titlePart = CardPartTitleView(type: .titleOnly)
    var cardPartSeparatorView = CardPartSeparatorView()
    var currencyMetricButtonPart = CardPartButtonView()
    var distanceMetricButtonPart = CardPartButtonView()
    var volumeMetricButtonPart = CardPartButtonView()
    
    var currencyImageView = CardPartImageView()
    var distanceImageView = CardPartImageView()
    
    let seperator = CardPartVerticalSeparatorView()
    let seperator2 = CardPartVerticalSeparatorView()
    let seperator3 = CardPartVerticalSeparatorView()
    
    var volumeList: [[String]] = []
    var distanceList: [[String]] = []
    var currencyList: [[String]] = []
    
    var editableMode: Bool = false
    
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
        
        currencyMetricButtonPart.setTitle("Change", for: .normal)
        currencyMetricButtonPart.addTarget(self, action: #selector(currencyButtonTapped), for: .touchUpInside)
        currencyMetricButtonPart.titleLabel?.font = CardParts.theme.normalTextFont
        currencyMetricButtonPart.setTitleColor(K.Constants.kacagiderimColorWarning, for: .normal)
        currencyImageView.frame = CGRect(x: 0, y: 0, width: 25, height: 25)
        currencyImageView.contentMode = .scaleAspectFit;
        
        let seperatorCurrency = CardPartVerticalSeparatorView()
        let centeredCardPartCurrency = CardPartCenteredView(leftView: currencyMetricButtonPart, centeredView: seperatorCurrency, rightView: currencyImageView)
        
        distanceMetricButtonPart.setTitle("Change", for: .normal)
        distanceMetricButtonPart.addTarget(self, action: #selector(distanceButtonTapped), for: .touchUpInside)
        distanceMetricButtonPart.titleLabel?.font = CardParts.theme.normalTextFont
        distanceMetricButtonPart.setTitleColor(K.Constants.kacagiderimColorWarning, for: .normal)
        distanceImageView.frame = CGRect(x: 0, y: 0, width: 25, height: 25)
        distanceImageView.contentMode = .scaleAspectFit;
        
        let seperatorDistance = CardPartVerticalSeparatorView()
        let centeredCardPartDistance = CardPartCenteredView(leftView: distanceMetricButtonPart, centeredView: seperatorDistance, rightView: distanceImageView)
        
        volumeMetricButtonPart.setTitle("Change Volume Metric", for: .normal)
        volumeMetricButtonPart.addTarget(self, action: #selector(volumeButtonTapped), for: .touchUpInside)
        volumeMetricButtonPart.titleLabel?.font = CardParts.theme.normalTextFont
        volumeMetricButtonPart.setTitleColor(K.Constants.kacagiderimColorWarning, for: .normal)
        
        let centeredCardPart = CardPartCenteredView(leftView: textView, centeredView: seperator, rightView: centeredCardPartCurrency)
        let centeredCardPart2 = CardPartCenteredView(leftView: textView2, centeredView: seperator2, rightView: centeredCardPartDistance)
        let centeredCardPart3 = CardPartCenteredView(leftView: textView3, centeredView: seperator3, rightView: volumeMetricButtonPart)
        
        viewModel.currencyMetric.asObservable().bind(to: currencyMetricButtonPart.rx.title()).disposed(by: bag)
        viewModel.distanceMetric.asObservable().bind(to: distanceMetricButtonPart.rx.title()).disposed(by: bag)
        viewModel.volumeMetric.asObservable().bind(to: volumeMetricButtonPart.rx.title()).disposed(by: bag)
        viewModel.currencyMetricImage.asObservable().bind(to: currencyImageView.rx.image).disposed(by: bag)
        viewModel.distanceMetricImage.asObservable().bind(to: distanceImageView.rx.image).disposed(by: bag)
        
        setComponents(editableMode: self.editableMode)
        
        setupCardParts([titlePart, cardPartSeparatorView, centeredCardPart, centeredCardPart2, centeredCardPart3])
    }
    
    func setComponents(editableMode:Bool){
        self.currencyMetricButtonPart.isUserInteractionEnabled = editableMode
        self.currencyMetricButtonPart.setTitleColor(editableMode == false ? CardParts.theme.normalTextColor : K.Constants.kacagiderimColorWarning, for: .normal)
        self.currencyMetricButtonPart.setTitle(editableMode == true ? "Change" : self.viewModel.currencyMetric.value, for: .normal)
        self.distanceMetricButtonPart.isUserInteractionEnabled = editableMode
        self.distanceMetricButtonPart.setTitleColor(editableMode == false ? CardParts.theme.normalTextColor : K.Constants.kacagiderimColorWarning, for: .normal)
        self.distanceMetricButtonPart.setTitle(editableMode == true ? "Change" : self.viewModel.distanceMetric.value, for: .normal)
        self.volumeMetricButtonPart.isUserInteractionEnabled = editableMode
        self.volumeMetricButtonPart.setTitleColor(editableMode == false ? CardParts.theme.normalTextColor : K.Constants.kacagiderimColorWarning, for: .normal)
        self.volumeMetricButtonPart.setTitle(editableMode == true ? "Change Volume Metric" : self.viewModel.volumeMetric.value, for: .normal)
    }
    
    @objc func distanceButtonTapped(sender: UIButton) {
        let mcPicker = McPicker(data: self.distanceList)
        let fixedSpace = McPickerBarButtonItem.fixedSpace(width: 20.0)
        let flexibleSpace = McPickerBarButtonItem.flexibleSpace()
        let fireButton = McPickerBarButtonItem.done(mcPicker: mcPicker, title: "Ok")
        let cancelButton = McPickerBarButtonItem.cancel(mcPicker: mcPicker, barButtonSystemItem: .cancel)
        mcPicker.setToolbarItems(items: [fixedSpace, cancelButton, flexibleSpace, fireButton, fixedSpace])
        
        mcPicker.showAsPopover(fromViewController: self, sourceView: sender,  doneHandler: { (selections: [Int : String]) -> Void in
            if let name = selections[0] {
                print("Selected:" + name)
                self.viewModel.distanceMetric.value = name
                self.distanceImageView.imageName = "\(name)"
                self.distanceImageView.image = Utils.imageWithImage(image: self.distanceImageView.image!, scaledToSize: CGSize(width: 25.0, height: 25.0))
                self.distanceImageView.contentMode = .scaleAspectFit;
            }})
    }
    
    @objc func volumeButtonTapped(sender: UIButton) {
        let mcPicker = McPicker(data: self.volumeList)
        let fixedSpace = McPickerBarButtonItem.fixedSpace(width: 20.0)
        let flexibleSpace = McPickerBarButtonItem.flexibleSpace()
        let fireButton = McPickerBarButtonItem.done(mcPicker: mcPicker, title: "Ok")
        let cancelButton = McPickerBarButtonItem.cancel(mcPicker: mcPicker, barButtonSystemItem: .cancel)
        mcPicker.setToolbarItems(items: [fixedSpace, cancelButton, flexibleSpace, fireButton, fixedSpace])
        mcPicker.showAsPopover(fromViewController: self,sourceView: sender, doneHandler: { (selections: [Int : String]) -> Void in
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
        mcPicker.showAsPopover(fromViewController: self,sourceView: sender, doneHandler: { (selections: [Int : String]) -> Void in
            if let name = selections[0] {
                print("Selected:" + name)
                self.viewModel.currencyMetric.value = name
                self.currencyImageView.imageName = "\(name)"
                self.currencyImageView.image = Utils.imageWithImage(image: self.currencyImageView.image!, scaledToSize: CGSize(width: 25.0, height: 25.0))
                self.currencyImageView.contentMode = .scaleAspectFit;
            }})
    }
    
    func onEditButtonTap(){
        if(editableMode){
            self.editableMode = false
            setComponents(editableMode: self.editableMode)
            
            // TODO ask user to update or cancel
            //            Utils.delayWithSeconds(0.5, completion: {
            //                self.viewModel.updateProfileData()
            //            })
        }
        else{
            PopupHandler.infoPopup(title: "Edit mode enabled", description: "Now you can edit your metrics. Just click the change buttons, then update each metric indivudually.")
            self.editableMode = true
            setComponents(editableMode: self.editableMode)
        }
    }
}

class ProfileCardController: CardPartsViewController, ShadowCardTrait, RoundedCardTrait, EditableCardTrait {
    
    weak var viewModel : ProfileViewModel!
    var titlePart = CardPartTitleView(type: .titleOnly)
    var cardPartSeparatorView = CardPartSeparatorView()
    var usernameTextFieldPart = CardPartTextField(format: .none)
    var nameTextFieldPart = CardPartTextField(format: .none)
    var surnameTextFieldPart = CardPartTextField(format: .none)
    var passwordTextView = CardPartTextField(format: .none)
    var passwordChangeButtonPart = CardPartButtonView()
    var ssnTextFieldPart = CardPartTextField(format: .none)
    var countryViewButtonPart = CardPartButtonView()
    var countryTextView = CardPartTextView(type: .normal)
    var typeSegmentedControl = UISegmentedControl(items: ProfileViewController.typeList)
    var typeTextView = CardPartTextView(type: .normal)
    
    let separator = CardPartVerticalSeparatorView()
    let separator2 = CardPartVerticalSeparatorView()
    let separator3 = CardPartVerticalSeparatorView()
    let separator4 = CardPartVerticalSeparatorView()
    let separator5 = CardPartVerticalSeparatorView()
    let separator6 = CardPartVerticalSeparatorView()
    let separator7 = CardPartVerticalSeparatorView()
    
    var countryList: [[String]] = []
    
    var editableMode: Bool = false
    
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
        if(self.viewModel.countries != nil && self.viewModel.countries?.countries != nil){
            for country in (self.viewModel.countries?.countries)! {
                list.append(country.countryName!)
            }
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
        usernameTextFieldPart.addTarget(self, action: #selector(self.usernameTextFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        
        nameTextFieldPart.keyboardType = .default
        nameTextFieldPart.placeholder = "Type a name"
        nameTextFieldPart.font = CardParts.theme.normalTextFont
        nameTextFieldPart.textColor = CardParts.theme.normalTextColor
        nameTextFieldPart.addTarget(self, action: #selector(self.nameTextFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        
        surnameTextFieldPart.keyboardType = .default
        surnameTextFieldPart.placeholder = "Type a surname"
        surnameTextFieldPart.font = CardParts.theme.normalTextFont
        surnameTextFieldPart.textColor = CardParts.theme.normalTextColor
        surnameTextFieldPart.addTarget(self, action: #selector(self.surnameTextFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        
        passwordChangeButtonPart.setTitle("Change Password", for: .normal)
        passwordChangeButtonPart.setTitleColor(K.Constants.kacagiderimColorWarning, for: .normal)
        passwordChangeButtonPart.addTarget(self, action: #selector(passwordButtonTapped), for: .touchUpInside)
        passwordChangeButtonPart.titleLabel?.font = CardParts.theme.normalTextFont
        
        passwordTextView.text = "12345678"
        passwordTextView.isSecureTextEntry = true
        
        let passwordStackView = CardPartStackView()
        passwordStackView.axis = .horizontal
        passwordStackView.spacing = 0
        passwordStackView.distribution = .equalSpacing
        passwordStackView.addArrangedSubview(passwordTextView)
        passwordStackView.addArrangedSubview(passwordChangeButtonPart)
        
        countryViewButtonPart.setTitle("Change Country", for: .normal)
        countryViewButtonPart.addTarget(self, action: #selector(countryButtonTapped), for: .touchUpInside)
        countryViewButtonPart.titleLabel?.font = CardParts.theme.normalTextFont
        countryViewButtonPart.setTitleColor(K.Constants.kacagiderimColorWarning, for: .normal)
        
        let countryStackView = CardPartStackView()
        countryStackView.axis = .horizontal
        countryStackView.spacing = 0
        passwordStackView.distribution = .equalSpacing
        countryStackView.addArrangedSubview(countryTextView)
        countryStackView.addArrangedSubview(countryViewButtonPart)
        
        ssnTextFieldPart.keyboardType = .default
        ssnTextFieldPart.placeholder = "Type your SSN"
        ssnTextFieldPart.font = CardParts.theme.normalTextFont
        ssnTextFieldPart.textColor = CardParts.theme.normalTextColor
        ssnTextFieldPart.addTarget(self, action: #selector(self.ssnTextFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        
        typeSegmentedControl.addTarget(self, action: #selector(typeValueChanged), for:UIControl.Event.valueChanged)
        let stackView = CardPartStackView()
        stackView.axis = .horizontal
        stackView.spacing = 0
        stackView.distribution = .equalSpacing
        stackView.addArrangedSubview(typeTextView)
        stackView.addArrangedSubview(typeSegmentedControl)
        
        let centeredCardPart = CardPartCenteredView(leftView: textView, centeredView: separator, rightView: usernameTextFieldPart)
        let centeredCardPart2 = CardPartCenteredView(leftView: textView2, centeredView: separator2, rightView: nameTextFieldPart)
        let centeredCardPart3 = CardPartCenteredView(leftView: textView3, centeredView: separator3, rightView: surnameTextFieldPart)
        let centeredCardPart4 = CardPartCenteredView(leftView: textView4, centeredView: separator4, rightView: passwordStackView)
        let centeredCardPart5 = CardPartCenteredView(leftView: textView5, centeredView: separator5, rightView: ssnTextFieldPart)
        let centeredCardPart6 = CardPartCenteredView(leftView: textView6, centeredView: separator6, rightView: countryStackView)
        let centeredCardPart7 = CardPartCenteredView(leftView: textView7, centeredView: separator7, rightView: stackView)
        
        viewModel.usernameText.asObservable().bind(to: usernameTextFieldPart.rx.text).disposed(by: bag)
        viewModel.nameText.asObservable().bind(to: nameTextFieldPart.rx.text).disposed(by: bag)
        viewModel.surnameText.asObservable().bind(to: surnameTextFieldPart.rx.text).disposed(by: bag)
        viewModel.ssnText.asObservable().bind(to: ssnTextFieldPart.rx.text).disposed(by: bag)
        viewModel.countryName.asObservable().bind(to: countryTextView.rx.text).disposed(by: bag)
        viewModel.countryName.asObservable().bind(to: countryViewButtonPart.rx.title()).disposed(by: bag)
        viewModel.type.asObservable().bind(to: typeSegmentedControl.rx.selectedSegmentIndex).disposed(by:bag)
        viewModel.typeText.asObservable().bind(to: typeTextView.rx.text).disposed(by:bag)
        
        setComponents(editableMode: self.editableMode)
        
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
        self.viewModel.typeText.value = ProfileViewController.typeList[sender.selectedSegmentIndex]
    }
    
    @objc func passwordButtonTapped(sender: UIButton) {
        self.viewModel.rootViewController?.performSegue(withIdentifier:"passwordChangeSegue", sender:sender)
    }
    
    func setComponents(editableMode:Bool){
        self.usernameTextFieldPart.isUserInteractionEnabled = editableMode
        self.nameTextFieldPart.isUserInteractionEnabled = editableMode
        self.surnameTextFieldPart.isUserInteractionEnabled = editableMode
        self.ssnTextFieldPart.isUserInteractionEnabled = editableMode
        self.countryViewButtonPart.isHidden = !editableMode
        self.countryViewButtonPart.isUserInteractionEnabled = editableMode
        self.countryViewButtonPart.setTitleColor(editableMode == false ? CardParts.theme.normalTextColor : K.Constants.kacagiderimColorWarning, for: .normal)
        self.countryViewButtonPart.setTitle(editableMode == true ? "Change Country" : "", for: .normal)
        self.countryTextView.isHidden = editableMode
        self.countryTextView.isUserInteractionEnabled = editableMode
        self.passwordChangeButtonPart.isUserInteractionEnabled = editableMode
        self.passwordChangeButtonPart.isHidden = !editableMode
        self.passwordChangeButtonPart.setTitleColor(editableMode == false ? CardParts.theme.normalTextColor : K.Constants.kacagiderimColorWarning, for: .normal)
        self.passwordTextView.isHidden = editableMode
        self.passwordTextView.isUserInteractionEnabled = editableMode
        self.typeTextView.isHidden = editableMode
        self.typeSegmentedControl.isHidden = !editableMode
        self.typeSegmentedControl.isUserInteractionEnabled = editableMode
    }
    
    func onEditButtonTap(){
        if(editableMode){
            self.editableMode = false
            setComponents(editableMode: self.editableMode)

            // TODO ask user to update or cancel
//            Utils.delayWithSeconds(0.5, completion: {
//                self.viewModel.updateProfileData()
//            })
        }
        else{
            PopupHandler.infoPopup(title: "Edit mode enabled", description: "Now you can edit your profile. Change your country, change your password etc.")
            self.editableMode = true
            setComponents(editableMode: self.editableMode)
        }
    }
    
    @objc func countryButtonTapped(sender: UIButton) {
        let mcPicker = McPicker(data: self.countryList)
        let fixedSpace = McPickerBarButtonItem.fixedSpace(width: 20.0)
        let flexibleSpace = McPickerBarButtonItem.flexibleSpace()
        let fireButton = McPickerBarButtonItem.done(mcPicker: mcPicker, title: "Ok")
        let cancelButton = McPickerBarButtonItem.cancel(mcPicker: mcPicker, barButtonSystemItem: .cancel)
        mcPicker.setToolbarItems(items: [fixedSpace, cancelButton, flexibleSpace, fireButton, fixedSpace])
        mcPicker.showAsPopover(fromViewController: self,sourceView: sender, doneHandler: { (selections: [Int : String]) -> Void in
            if let name = selections[0] {
                print("Selected:" + name)
                self.viewModel.countryName.value = name
                self.viewModel.setCountryId(countryName: name)
            }})
    }
}

protocol LocationUpdateDelegate: class {
    func homePositionChanged(lat:Double, lon:Double)
    func workPositionChanged(lat:Double, lon:Double)
    func getHomePosition() -> CLLocationCoordinate2D
    func getWorkPosition() -> CLLocationCoordinate2D
    func saveAll()
}

class ProfileViewModel : LocationUpdateDelegate {
    var usernameText = Variable("")
    var nameText = Variable("")
    var surnameText = Variable("")
    var ssnText = Variable("")
    var countryId = Variable("")
    var countryName = Variable("")
    var type = Variable<Int>(0)
    var typeText = Variable("")
    
    var homeLatitude = Variable("")
    var homeLongitude = Variable("")
    var workLatitude = Variable("")
    var workLongitude = Variable("")
    
    var currencyMetric = Variable("")
    var currencyMetricImage = Variable<UIImage>(UIImage())
    var distanceMetric = Variable("")
    var distanceMetricImage = Variable<UIImage>(UIImage())
    var volumeMetric = Variable("")

    var countries:Countries?
    var cities: Cities?
    var citySelectionData: [[String]] = []
    let favouriteCities: Variable<[String]> = Variable([])
    
    var imageURL = Variable("")
    var profileImage  = Variable<UIImage>(UIImage())
    var loginType = Variable("")
    
    let defaultProfileImage = UIImage(named: "profile.png")
    
    weak var rootViewController:ProfileViewController?
    
    init(rootViewController: ProfileViewController) {
        self.rootViewController = rootViewController
        refreshLocalData()
        getProfileData()
    }
    
    func homePositionChanged(lat:Double, lon:Double){
        self.homeLatitude.value = String(format: "%.04f", lat)
        self.homeLongitude.value = String(format: "%.04f", lon)
    }
    
    func workPositionChanged(lat:Double, lon:Double){
        self.workLatitude.value = String(format: "%.04f", lat)
        self.workLongitude.value = String(format: "%.04f", lon)
    }
    
    func getHomePosition() -> CLLocationCoordinate2D {
        let homeLatitude = Double(self.homeLatitude.value) ?? nil
        let homelongitude = Double(self.homeLongitude.value) ?? nil
        let position = homeLatitude != nil && homelongitude != nil ? CLLocationCoordinate2D(latitude: homeLatitude!, longitude: homelongitude!) : kCLLocationCoordinate2DInvalid
        return position
    }
    
    func getWorkPosition() -> CLLocationCoordinate2D {
        let workLatitude = Double(self.workLatitude.value) ?? nil
        let worklongitude = Double(self.workLongitude.value) ?? nil
        let position = workLatitude != nil && worklongitude != nil ? CLLocationCoordinate2D(latitude: workLatitude!, longitude: worklongitude!) : kCLLocationCoordinate2DInvalid
        return position
    }
    
    func saveAll() {
        self.updateProfileData()
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
                    
                    mcPicker.showAsPopover(fromViewController: viewController,sourceView: sourceView, doneHandler: { (selections: [Int : String]) -> Void in
                        if let name = selections[0] {
                            print("Selected:" + name)
                            var selectedCities = DefaultManager.getSelectedCities()
                            selectedCities.append(name)
                            selectedCities = Array(Set(selectedCities))
                            DefaultManager.setSelectedCities(cities: selectedCities)
                            self.favouriteCities.value = selectedCities.sorted(by:<);
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
        var selectedCities = DefaultManager.getSelectedCities()
        if let indexInSelectedCities = selectedCities.index(of:cityName) {
            selectedCities.remove(at: indexInSelectedCities)
        }
        DefaultManager.setSelectedCities(cities: selectedCities)
        self.favouriteCities.value = selectedCities.sorted(by: <)
    }
    
    func refreshLocalData(){
        self.countries = DefaultManager.getCountries()
        let selectedCities = DefaultManager.getSelectedCities()
        self.favouriteCities.value = selectedCities.sorted(by: <)
    }
    
    func getProfileData(){
        APIClient.getCurrentUser(completion:{ result in
            switch result {
            case .success(let userResponse):
                let profile:User = (userResponse.value as User?)!
                DefaultManager.setUser(user: profile)
                self.usernameText.value = profile.username
                self.nameText.value = profile.name ?? ""
                self.surnameText.value = profile.surname ?? ""
                if(profile.socialSecurityNumber != nil){
                    self.ssnText.value = profile.socialSecurityNumber!
                }
                self.currencyMetric.value = profile.currencyMetric.rawValue
                self.currencyMetricImage.value = Utils.imageWithImage(image: UIImage(named: profile.currencyMetric.rawValue)!, scaledToSize: CGSize(width: 25.0, height: 25.0))
                
                self.distanceMetric.value = profile.distanceMetric.rawValue
                self.distanceMetricImage.value = Utils.imageWithImage(image: UIImage(named: profile.distanceMetric.rawValue)!, scaledToSize: CGSize(width: 25.0, height: 25.0))
                
                self.volumeMetric.value = profile.volumeMetric.rawValue
                self.type.value = ProfileViewController.typeList.index(of: profile.userType.rawValue)!
                self.typeText.value = profile.userType.rawValue
                
                self.homeLatitude.value = "\(profile.homeLatitude!)"
                self.homeLongitude.value = "\(profile.homeLongitude!)"
                self.workLatitude.value = "\(profile.workLatitude!)"
                self.workLongitude.value = "\(profile.workLongitude!)"
                
                self.countryId.value = profile.countryId
                self.countryName.value = self.getCountryName(countryId: profile.countryId)
                
                self.imageURL.value = profile.imageURL ?? ""
                
                ImageManager.getImage(imageUrl: self.imageURL.value, completion: { (response) in
                    if(response != nil){
                        self.profileImage.value = response!
                    }
                    else{
                        self.profileImage.value = self.defaultProfileImage!
                    }
                })
                self.loginType.value = profile.loginType.rawValue
            case .failure(let error):
                print((error as! CustomError).localizedDescription)
            }
        })
    }
    
    func updateProfileData(){
        let user = User(username: self.usernameText.value,
                        name: self.nameText.value,
                        surname: self.surnameText.value,
                        countryId: self.countryId.value,
                        homeLatitude: Double(self.homeLatitude.value) ?? nil,
                        homeLongitude: Double(self.homeLongitude.value) ?? nil,
                        workLatitude: Double(self.workLatitude.value) ?? nil,
                        workLongitude: Double(self.workLongitude.value) ?? nil,
                        currencyMetric: CurrencyMetrics(rawValue: self.currencyMetric.value)!,
                        distanceMetric: DistanceMetrics(rawValue: self.distanceMetric.value)!,
                        volumeMetric: VolumeMetrics(rawValue: self.volumeMetric.value)!,
                        userType: UserType(rawValue: ProfileViewController.typeList[self.type.value])!,
                        socialSecurityNumber: self.ssnText.value,
                        loginType: LoginType(rawValue: self.loginType.value)!,
                        imageURL: self.imageURL.value)
        
        Utils.showLoadingIndicator(message: "Profile Updating", size: CGSize(width: 100, height: 100))
        
        APIClient.updateAccount(user: user, completion: { result in
            switch result {
            case .success(let updateResponse):
                Utils.dismissLoadingIndicator()
                PopupHandler.successPopup(title: "Success", description: updateResponse.reason)
                self.getProfileData()
            case .failure(let error):
                print((error as! CustomError).localizedDescription)
                Utils.dismissLoadingIndicator()
                PopupHandler.errorPopup(title: "Error", description: "Something went wrong")
            }
        })
    }
}

