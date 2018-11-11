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

class VehicleCollectionVC: CardPartsViewController {
    
    var collectionViewLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 5
        layout.minimumLineSpacing = 5
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: 100, height: 100)
        return layout
    }()
    lazy var collectionViewCardPart = CardPartCollectionView(collectionViewLayout: collectionViewLayout)
    
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

        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = UIColor.darkGray
        refreshControl.addTarget(self, action: #selector(self.refreshData), for: .valueChanged)
        collectionViewCardPart.collectionView.refreshControl = refreshControl
        
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
        collectionViewCardPart.collectionView.frame = CGRect(x: 0, y: 0, width: 400, height: 400)
        
        let selectionMapTextView = CardPartTextView(type: .small)
        viewModel.selectionString.asObservable().bind(to: selectionMapTextView.rx.text).disposed(by: bag)
        
        setupCardParts(getViews(title: "Choose Vehicle", image: UIImage(named: "novehicle.png")!, text: "No data to shown"), forState: .none)
        setupCardParts(getViews(title: "Choose Vehicle", image: UIImage(named: "novehicle.png")!, text: "No data to shown"), forState: .empty)
        setupCardParts(getLoadingViews(title: "Choose Vehicle", text: "Vehicles are loading..."), forState: .loading)
        setupCardParts([getTitleStack(title: "Choose Vehicle"), CardPartSeparatorView(), selectionMapTextView, CardPartSeparatorView(), collectionViewCardPart], forState: .hasData)
        setupCardParts(getViews(title: "Choose Vehicle", image: UIImage(named: "alert.png")!, text: "Something went wrong while getting vehicles"), forState: .custom("fail"))
    }
    
    func getTitleStack(title: String) -> CardPartStackView {
        let titlePart = CardPartTitleView(type: .titleOnly)
        titlePart.label.text = title
        
        let image = Utils.imageWithImage(image: UIImage(named: "back.png")!, scaledToSize: CGSize(width: 20, height: 20))
        let backButton = CardPartButtonView()
        backButton.contentHorizontalAlignment = .right
        backButton.setImage(image, for: .normal)
        backButton.setTitle("Back", for: .normal)
        backButton.titleLabel?.font = CardParts.theme.normalTextFont
        backButton.setTitleColor(UIColor.darkDefault, for: .normal)
        backButton.addTarget(self.viewModel, action: #selector(self.viewModel.back), for: .touchUpInside)
        
        let resetImage = Utils.imageWithImage(image: UIImage(named: "back.png")!, scaledToSize: CGSize(width: 20, height: 20))
        let resetButton = CardPartButtonView()
        resetButton.contentHorizontalAlignment = .right
        resetButton.setImage(resetImage, for: .normal)
        resetButton.setTitle("Reset", for: .normal)
        resetButton.titleLabel?.font = CardParts.theme.normalTextFont
        resetButton.setTitleColor(UIColor.darkDefault, for: .normal)
        resetButton.addTarget(self.viewModel, action: #selector(self.viewModel.reset), for: .touchUpInside)
        let seperator = CardPartVerticalSeparatorView()
        
        let centeredView = CardPartCenteredView(leftView: resetButton, centeredView: seperator, rightView: backButton)
        viewModel.isBackButtonHide.asObservable().bind(to: centeredView.rx.isHidden).disposed(by: bag)
        
        let sv = CardPartStackView()
        sv.spacing = 1
        sv.distribution = .fillProportionally
        sv.alignment = .center
        sv.addArrangedSubview(titlePart)
        sv.addArrangedSubview(centeredView)
        
        sv.addConstraint(NSLayoutConstraint(item: titlePart, attribute: .width, relatedBy: .equal, toItem:centeredView , attribute: .width, multiplier: 1.2, constant: 0.0))
        
        return sv
    }
    
    func getViews(title: String, image: UIImage, text: String) -> [CardPartView] {
        let imageView = CardPartImageView(image: image)
        imageView.contentMode = .scaleAspectFit;
        let textView = CardPartTextView(type: .normal)
        textView.text = text
        let stack = CardPartStackView()
        stack.axis = .vertical
        stack.spacing = 10
        stack.distribution = .equalSpacing
        stack.alignment = UIStackView.Alignment.center
        stack.addArrangedSubview(imageView);
        stack.addArrangedSubview(textView);
        
        let selectionMapTextView = CardPartTextView(type: .small)
        viewModel.selectionString.asObservable().bind(to: selectionMapTextView.rx.text).disposed(by: bag)
        
        return [getTitleStack(title: title),CardPartSeparatorView(), selectionMapTextView, CardPartSeparatorView(), stack]
    }
    
    func getLoadingViews(title: String, text: String) -> [CardPartView]{
        let loadingIndicator = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 100, height: 100), type: K.Constants.default_spinner, color:UIColor.black , padding: 0)
        let loadingTextView = CardPartTextView(type: .normal)
        loadingTextView.text = text
        loadingIndicator.startAnimating()
        let stack = CardPartStackView()
        stack.axis = .vertical
        stack.spacing = 10
        stack.distribution = .equalSpacing
        stack.alignment = UIStackView.Alignment.center
        stack.addArrangedSubview(loadingIndicator);
        stack.addArrangedSubview(loadingTextView);
        return [getTitleStack(title: title), CardPartSeparatorView(), stack]
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
                viewModel.getDetails(version: nil, engine: (cell.data as! Engine))
            }
        }
        else if(cell.data != nil && cell.data is Version){
            viewModel.getDetails(version: (cell.data as! Version), engine: nil)
        }
        else if(cell.data != nil && cell.data is Detail){
            let detail = cell.data as! Detail
            PopupHandler.showVehicleAddForm(detail: detail, style: .dark, buttonCompletion: {
                vehicleAddForm in
                    self.viewModel.addVehicle(detail: detail, options: vehicleAddForm)
            })
        }
    }
    
    @objc func refreshData(sender: UIButton){
        print("refresh")
        Utils.delayWithSeconds(1, completion: {
            self.collectionViewCardPart.collectionView.refreshControl?.endRefreshing()
        })
    }
}
