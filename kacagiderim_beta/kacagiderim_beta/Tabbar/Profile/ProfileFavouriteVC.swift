//
//  ProfileFavouriteVC.swift
//  kacagiderim_beta
//
//  Created by kamilinal on 12/6/18.
//  Copyright © 2018 kacagiderim. All rights reserved.
//

import Foundation
import CardParts
import RxSwift
import RxCocoa
import SwiftEntryKit

class ProfileFavouriteVC: BaseCardPartsViewController {
    weak var viewModel: ProfileFavouriteVM!
    var pickerView: UIPickerView?
    
    public init(viewModel: ProfileFavouriteVM) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
    }
    
    required public init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pickerView = UIPickerView()
        pickerView?.backgroundColor = UIColor.white
        pickerView?.showsSelectionIndicator = true
        
        viewModel.cities.asObservable().bind(to: (pickerView?.rx.itemTitles)!) { row, element in
                return element.cityName?.uppercased()
            }
            .disposed(by: bag)
        
        pickerView!.rx.itemSelected.asObservable().bind(to: viewModel.selectedCityIndex).disposed(by: bag)
        
        viewModel.state.asObservable().bind(to: self.rx.state).disposed(by: bag)
        let tableViewPart = CardPartTableView()
        tableViewPart.tableView.register(CardPartTableViewCell.self, forCellReuseIdentifier: "FavouriteCitiesCellIdentifier")
        
        viewModel.favouriteCities.asObservable().bind(to: tableViewPart.tableView.rx.items) { tableView, index, city in
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "FavouriteCitiesCellIdentifier", for: IndexPath(item: index, section: 0)) as? CardPartTableViewCell else { return UITableViewCell() }
            
            cell.leftTitleLabel.text = city.cityName?.uppercased()
            
            return cell
            }.disposed(by: bag)
        
        tableViewPart.tableView.rx.itemDeleted
            .subscribe({indexPath in
                self.viewModel.deleteSelectedCity(index: (indexPath.element?.row)!)
            })
            .disposed(by: bag)
        
        setupCardParts([CardPartsUtil.getTitleView(title: "Favourite Cities"), CardPartSeparatorView(), getAddButton()], forState: .empty)
        setupCardParts([CardPartsUtil.getTitleView(title: "Favourite Cities"), CardPartSeparatorView(), getAddButton(), CardPartSeparatorView(), tableViewPart] , forState: .hasData)
    }
    
    func getAddButton() -> CardPartView {
        let addNewCityButton = CardPartButtonView()
        addNewCityButton.contentHorizontalAlignment = .center
        addNewCityButton.setTitle("Select Your Favourite City", for: UIControl.State.normal)
        addNewCityButton.setImage(Utils.imageWithImage(image: UIImage(named: "add.png")!, scaledToSize: CGSize(width: 50, height: 50)), for: UIControl.State.normal)
        addNewCityButton.addTarget(self, action: #selector(addNewButtonTapped), for: .touchUpInside)
        return addNewCityButton
    }
    
    @objc func addNewButtonTapped(sender: UIButton){
        var attributes: EKAttributes
        attributes = .toast
        attributes.windowLevel = .normal
        attributes.position = .bottom
        attributes.displayDuration = .infinity
        
        attributes.entranceAnimation = .init(translate: .init(duration: 0.65, spring: .init(damping: 1, initialVelocity: 0)))
        attributes.exitAnimation = .init(translate: .init(duration: 0.65, spring: .init(damping: 1, initialVelocity: 0)))
        attributes.popBehavior = .animated(animation: .init(translate: .init(duration: 0.65, spring: .init(damping: 1, initialVelocity: 0))))
        
        attributes.entryInteraction = .absorbTouches
        attributes.screenInteraction = .dismiss
        
        attributes.entryBackground = .gradient(gradient: .init(colors: [EKColor.Netflix.light, EKColor.Netflix.dark], startPoint: .zero, endPoint: CGPoint(x: 1, y: 1)))
        
        attributes.shadow = .active(with: .init(color: .black, opacity: 0.3, radius: 3))
        attributes.screenBackground = .color(color: .dimmedDarkBackground)
        attributes.scroll = .edgeCrossingDisabled(swipeable: true)
        attributes.statusBar = .light
        
        attributes.positionConstraints.keyboardRelation = .bind(offset: .init(bottom: 0, screenEdgeResistance: 0))
        attributes.positionConstraints.maxSize = .init(width: .constant(value: UIScreen.main.minEdge), height: .intrinsic)
        
        let stack = UIStackView()
        stack.axis = .vertical
        
        let toolbar = UIToolbar()
        toolbar.barStyle = UIBarStyle.default
        let titleView = UIBarButtonItem.init(title: "Cities", style: UIBarButtonItem.Style.plain, target: nil, action: nil)
        titleView.tintColor = UIColor.darkDefault
        let doneButton = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: self, action: #selector(doneButtonTapped))
        let cancelButton = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonItem.SystemItem.cancel, target: self, action: #selector(cancelButtonTapped))
        let fixedSpace = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        toolbar.setItems([cancelButton,fixedSpace, titleView, fixedSpace, doneButton], animated: true)
        
        stack.addArrangedSubview(toolbar)
        stack.addArrangedSubview(self.pickerView!)
        
        // Display the view with the configuration
        SwiftEntryKit.display(entry: stack, using: attributes)
    }
    
    @objc func doneButtonTapped(sender: UIButton){
        self.viewModel.addSelectedCity()
        SwiftEntryKit.dismiss()
    }
    
    @objc func cancelButtonTapped(sender: UIButton){
        SwiftEntryKit.dismiss()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.getCities()
        viewModel.getSelectedCities()
    }
}
