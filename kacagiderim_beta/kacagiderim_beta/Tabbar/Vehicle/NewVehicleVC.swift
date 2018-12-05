//
//  VehicleCollectionViewController.swift
//  kacagiderim_beta
//
//  Created by kamilinal on 11/4/18.
//  Copyright © 2018 kacagiderim. All rights reserved.
//

import Foundation
import CardParts
import RxDataSources
import NVActivityIndicatorView
import SwiftEntryKit

class NewVehicleVC: CardPartsViewController {

    var collectionViewLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 5
        layout.minimumLineSpacing = 5
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: 100, height: 100)
        return layout
    }()
    lazy var collectionViewCardPart = CardPartCollectionView(collectionViewLayout: collectionViewLayout)
    var loadingIndicator = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50), type: K.Constants.default_spinner, color:UIColor.black , padding: 0)
    
    weak  var viewModel: NewVehicleVM!
    
    public init(viewModel: NewVehicleVM) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
    }
    
    required public init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionViewCardPart.collectionView.register(VehicleCollectionViewCell.self, forCellWithReuseIdentifier: "VehicleCollectionViewCell")
        collectionViewCardPart.collectionView.backgroundColor = .clear
        collectionViewCardPart.collectionView.showsHorizontalScrollIndicator = false
        
        let dataSource = RxCollectionViewSectionedReloadDataSource<VehicleCollectionStruct>(configureCell: {[weak self] (_, collectionView, indexPath, data) -> UICollectionViewCell in
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "VehicleCollectionViewCell", for: indexPath) as? VehicleCollectionViewCell else { return UICollectionViewCell() }
            
            cell.setData(data)
            
            cell.backgroundColor = UIColor.white
            cell.layer.cornerRadius = 5
            cell.layer.borderWidth = 1
            cell.layer.borderColor = UIColor(red: 0.93, green: 0.93, blue: 0.95, alpha: 1.0).cgColor
            cell.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self!.handleCellSelected(sender:))))
            
            return cell
        })
        
        viewModel.state.asObservable().bind(to: self.rx.state).disposed(by: bag)
        viewModel.data.asObservable().bind(to: collectionViewCardPart.collectionView.rx.items(dataSource: dataSource)).disposed(by: bag)
        
        let screenSize: CGRect = UIScreen.main.bounds
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height - 200
        collectionViewCardPart.collectionView.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)
        
        let selectionMapTextView = CardPartTextView(type: .small)
        viewModel.selectionString.asObservable().bind(to: selectionMapTextView.rx.text).disposed(by: bag)
        
        let image = Utils.imageWithImage(image: UIImage(named: "back.png")!, scaledToSize: CGSize(width: 40, height: 40))
        let backButton = CardPartButtonView()
        backButton.contentHorizontalAlignment = .right
        backButton.setImage(image, for: .normal)
        backButton.setTitle("Back", for: UIControl.State.normal)
        backButton.addTarget(self.viewModel, action: #selector(self.viewModel.back), for: .touchUpInside)
        
        let selectionStackView = CardPartStackView()
        selectionStackView.spacing = 1
        selectionStackView.distribution = .fill
        selectionStackView.alignment = .center
        selectionStackView.addArrangedSubview(selectionMapTextView)
        selectionStackView.addArrangedSubview(backButton)
        
        loadingIndicator.startAnimating()
        
        let mainStack = CardPartStackView()
        mainStack.axis = .vertical
        mainStack.spacing = 10
        mainStack.distribution = .fill
        mainStack.addArrangedSubview(loadingIndicator);
        mainStack.addArrangedSubview(collectionViewCardPart)
        
        viewModel.isBackButtonHide.asObservable().bind(to: backButton.rx.isHidden).disposed(by: bag)
        viewModel.isLoading.asObservable().map({$0 == true ? false : true}).bind(to: loadingIndicator.rx.isHidden).disposed(by:bag)
//        viewModel.isLoading.asObservable().bind(to: collectionViewCardPart.rx.isHidden).disposed(by: bag)
    
        setupCardParts([getTitleStack(title: "Choose Vehicle"), CardPartSeparatorView(), selectionStackView, CardPartSeparatorView(), mainStack])
    }
    
    func getTitleStack(title: String) -> CardPartStackView {
        let titleView = CardPartsUtil.getTitleView(title: title)
        
        let moreImage = Utils.imageWithImage(image: UIImage(named: "more.png")!, scaledToSize: CGSize(width: 50, height: 50))
        let moreButton = CardPartButtonView()
        moreButton.contentHorizontalAlignment = .right
        moreButton.setImage(moreImage, for: .normal)
        moreButton.addTarget(self, action: #selector(self.more), for: .touchUpInside)
        
        let sv = CardPartStackView()
        sv.spacing = 1
        sv.distribution = .fill
        sv.alignment = .center
        sv.addArrangedSubview(titleView as! UIView)
        sv.addArrangedSubview(moreButton)
        return sv
    }
    
    @objc func filterBrands(sender: UIButton) {
        viewModel.filterBrands(type: sender.tag)
    }
    
    @objc func handleCellSelected(sender: UITapGestureRecognizer){
        let cell = sender.view as! VehicleCollectionViewCell
        if(cell.data != nil && cell.data is Brand){
            viewModel.getModels(brand: cell.data as! Brand)
        }
        else if(cell.data != nil && cell.data is Model){
            viewModel.getEngines(model: cell.data as! Model)
        }
        else if(cell.data != nil && cell.data is Engine){
            let engine = cell.data as! Engine
            if(engine.hasAnyChild()){
                viewModel.getVersions(engine: cell.data as! Engine)
            }
            else{
                viewModel.getDetails(version: nil, engine: (cell.data as! Engine), packet: nil)
            }
        }
        else if(cell.data != nil && cell.data is Version){
            let version = cell.data as! Version
            if(version.hasAnyChild()){
                viewModel.getPackets(version: cell.data as! Version)
            }
            else{
                viewModel.getDetails(version: (cell.data as! Version), engine: nil, packet: nil)
            }
        }
        else if(cell.data != nil && cell.data is Packet){
            viewModel.getDetails(version: nil, engine: nil, packet: (cell.data as! Packet))
        }
        else if(cell.data != nil && cell.data is Detail){
            let detail = cell.data as! Detail
            PopupHandler.showVehicleAddForm(detail: detail, style: .dark, buttonCompletion: {
                vehicleAddForm in
                    self.viewModel.addVehicle(detail: detail, options: vehicleAddForm)
            })
        }
    }
        
    @objc func more(sender: UIButton){
        let attributes = Utils.getAttributes(element: EKAttributes.bottomToast,
                                             duration: .infinity,
                                             entryBackground: .gradient(gradient: .init(colors: [EKColor.Netflix.light, EKColor.Netflix.dark], startPoint: .zero, endPoint: CGPoint(x: 1, y: 1))),
                                             screenBackground: .color(color: .dimmedLightBackground),
                                             roundCorners: .all(radius: 25))
        let buttonLabelStyle = EKProperty.LabelStyle(font: MainFont.medium.with(size: 20), color: EKColor.Netflix.dark)
        
        let resetButton = EKProperty.ButtonContent(label: EKProperty.LabelContent(text: "Reset", style: buttonLabelStyle), backgroundColor: .white, highlightedBackgroundColor:  EKColor.Gray.light) {
            SwiftEntryKit.dismiss()
            Utils.delayWithSeconds(0.5, completion: {
                self.viewModel.reset()
            })
        }
        let typeButton = EKProperty.ButtonContent(label: EKProperty.LabelContent(text: "Change Type", style: buttonLabelStyle), backgroundColor: .white, highlightedBackgroundColor:  EKColor.Gray.light) {
            SwiftEntryKit.dismiss()
            Utils.delayWithSeconds(0.5, completion: {
                self.viewModel.chooseVehicleType()
            })
        }
        let closeButton = EKProperty.ButtonContent(label: EKProperty.LabelContent(text: "Close", style: buttonLabelStyle), backgroundColor: .white, highlightedBackgroundColor:  EKColor.Gray.light) {
            SwiftEntryKit.dismiss()
            Utils.delayWithSeconds(0.5, completion: {
                self.dismiss(animated: true, completion: {})
            })
        }
        
        Utils.showSelectionPopup(attributes: attributes, title: "Actions", titleColor: .white, description: "Plese select an  action from below list", descriptionColor: .white, image: UIImage(named: "ic_success")!, buttons: [resetButton, typeButton, closeButton])
    }
}
