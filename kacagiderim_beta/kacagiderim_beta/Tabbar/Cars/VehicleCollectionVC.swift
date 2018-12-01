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

class VehicleCollectionVC: CardPartsViewController, CardPartTableViewDelegte {

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
    
    var searchTextField = CardPartTextField()
    var searchTableView = CardPartTableView()
    
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
        
        let screenSize: CGRect = UIScreen.main.bounds
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height - 200
        collectionViewCardPart.collectionView.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)
        
        let selectionMapTextView = CardPartTextView(type: .small)
        viewModel.selectionString.asObservable().bind(to: selectionMapTextView.rx.text).disposed(by: bag)
        
        searchTableView.tableView.register(CarSearchTableViewCell.self, forCellReuseIdentifier: "CarSearchTableViewCell")
        searchTableView.delegate = self
        
        viewModel.searchVehicles.asObservable().bind(to: searchTableView.tableView.rx.items) { tableView, index, detail in
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "CarSearchTableViewCell", for: IndexPath(item: index, section: 0)) as? CarSearchTableViewCell else { return UITableViewCell() }
            
            cell.setData(data:detail)
            
            return cell
            }.disposed(by: bag)
        
        
        setupCardParts(getViews(title: "Choose Vehicle", image: UIImage(named: "novehicle.png")!, text: "No data to shown"), forState: .none)
        setupCardParts(getViews(title: "Choose Vehicle", image: UIImage(named: "novehicle.png")!, text: "No data to shown"), forState: .empty)
        setupCardParts(getLoadingViews(title: "Choose Vehicle", text: "Vehicles are loading..."), forState: .loading)
        setupCardParts([getTitleStack(title: "Choose Vehicle"), CardPartSeparatorView(), selectionMapTextView, CardPartSeparatorView(), collectionViewCardPart], forState: .hasData)
        setupCardParts(getViews(title: "Choose Vehicle", image: UIImage(named: "alert.png")!, text: "Something went wrong while getting vehicles"), forState: .custom("fail"))
        setupCardParts(getSearchViews(showTable: true), forState: .custom("search"))
    }
    
    func getTitleStack(title: String) -> CardPartStackView {
        let titlePart = CardPartTitleView(type: .titleOnly)
        titlePart.label.text = title
        
        let image = Utils.imageWithImage(image: UIImage(named: "back.png")!, scaledToSize: CGSize(width: 20, height: 20))
        let backButton = CardPartButtonView()
        backButton.contentHorizontalAlignment = .right
        backButton.setImage(image, for: .normal)
        backButton.addTarget(self.viewModel, action: #selector(self.viewModel.back), for: .touchUpInside)
        
        let resetImage = Utils.imageWithImage(image: UIImage(named: "reset.png")!, scaledToSize: CGSize(width: 20, height: 20))
        let resetButton = CardPartButtonView()
        resetButton.contentHorizontalAlignment = .right
        resetButton.setImage(resetImage, for: .normal)
        resetButton.addTarget(self.viewModel, action: #selector(self.viewModel.reset), for: .touchUpInside)
        
        let carImage = Utils.imageWithImage(image: UIImage(named: "car.png")!, scaledToSize: CGSize(width: 20, height: 20))
        let carButton = CardPartButtonView()
        carButton.contentHorizontalAlignment = .right
        carButton.setImage(carImage, for: .normal)
        carButton.addTarget(self.viewModel, action: #selector(self.viewModel.chooseVehicleType), for: .touchUpInside)
        
        let searchImage = Utils.imageWithImage(image: UIImage(named: "search.png")!, scaledToSize: CGSize(width: 20, height: 20))
        let searchButton = CardPartButtonView()
        searchButton.contentHorizontalAlignment = .right
        searchButton.setImage(searchImage, for: .normal)
        searchButton.addTarget(self.viewModel, action: #selector(self.viewModel.search), for: .touchUpInside)
        
        let closeImage = Utils.imageWithImage(image: UIImage(named: "close.png")!, scaledToSize: CGSize(width: 20, height: 20))
        let closeButton = CardPartButtonView()
        closeButton.contentHorizontalAlignment = .right
        closeButton.setImage(closeImage, for: .normal)
        closeButton.addTarget(self.viewModel, action: #selector(self.viewModel.dismiss), for: .touchUpInside)
        
        viewModel.isBackButtonHide.asObservable().bind(to: backButton.rx.isHidden).disposed(by: bag)
        viewModel.isBackButtonHide.asObservable().bind(to: resetButton.rx.isHidden).disposed(by: bag)
        
        let sv = CardPartStackView()
        sv.spacing = 1
        sv.distribution = .fill
        sv.alignment = .center
        sv.addArrangedSubview(titlePart)
        sv.addArrangedSubview(resetButton)
        sv.addArrangedSubview(backButton)
        sv.addArrangedSubview(carButton)
        sv.addArrangedSubview(searchButton)
        sv.addArrangedSubview(closeButton)
        
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
    
    func getNoDataStack() -> CardPartView{
        let imageView = CardPartImageView(image: UIImage(named: "novehicle.png"))
        imageView.contentMode = .scaleAspectFit;
        let textView = CardPartTextView(type: .normal)
        textView.text = "No data to shown"
        let stack = CardPartStackView()
        stack.axis = .vertical
        stack.spacing = 10
        stack.distribution = .equalSpacing
        stack.alignment = UIStackView.Alignment.center
        stack.addArrangedSubview(imageView);
        stack.addArrangedSubview(textView);
        return stack
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
        return [stack]
    }
    
    func getSearchViews(showTable: Bool) -> [CardPartView]{
        searchTextField.placeholder = "Type any vehicle..."
        
        let searchTitleView = CardPartTitleView(type:.titleOnly)
        searchTitleView.title = "Vehicle Search"

        let searchResultTitleView = CardPartTitleView(type:.titleOnly)
        searchResultTitleView.title = "Search Results"

        let backImage = Utils.imageWithImage(image: UIImage(named: "back.png")!, scaledToSize: CGSize(width: 50, height: 50))
        let backButton = CardPartButtonView()
        backButton.contentHorizontalAlignment = .right
        backButton.setImage(backImage, for: .normal)
        backButton.addTarget(self.viewModel, action: #selector(self.viewModel.getPreviousPageDetails), for: .touchUpInside)
        
        let nextImage = Utils.imageWithImage(image: UIImage(named: "forward.png")!, scaledToSize: CGSize(width: 50, height: 50))
        let nextButton = CardPartButtonView()
        nextButton.contentHorizontalAlignment = .right
        nextButton.setImage(nextImage, for: .normal)
        nextButton.addTarget(self.viewModel, action: #selector(self.viewModel.getNextPageDetails), for: .touchUpInside)
        
        let stackPage = CardPartStackView()
        stackPage.axis = .horizontal
        stackPage.spacing = 10
        stackPage.distribution = .fill
        stackPage.addArrangedSubview(searchResultTitleView);
        stackPage.addArrangedSubview(backButton);
        stackPage.addArrangedSubview(nextButton);
        
        let stackResultsPage = CardPartStackView()
        stackResultsPage.axis = .vertical
        stackResultsPage.spacing = 10
        stackResultsPage.distribution = .fill
        stackResultsPage.addArrangedSubview(stackPage);
        stackResultsPage.addArrangedSubview(CardPartSeparatorView());
        
        viewModel.searchString.asObservable().bind(to: searchTextField.rx.text).disposed(by: bag)
        viewModel.searchResultString.asObservable().bind(to: searchResultTitleView.rx.title).disposed(by: bag)
        searchTextField.rx.text.orEmpty.bind(to: viewModel.searchString).disposed(by: bag)
        viewModel.isPaginationNextButtonHide.asObservable().bind(to: nextButton.rx.isHidden).disposed(by: bag)
        viewModel.isPaginationBackButtonHide.asObservable().bind(to: backButton.rx.isHidden).disposed(by: bag)
        viewModel.isSearchResultsStackHide.asObservable().bind(to: stackResultsPage.rx.isHidden).disposed(by: bag)
        
        let searchImage = Utils.imageWithImage(image: UIImage(named: "search.png")!, scaledToSize: CGSize(width: 50, height: 50))
        let searchButton = CardPartButtonView()
        searchButton.contentHorizontalAlignment = .right
        searchButton.setImage(searchImage, for: .normal)
        searchButton.addTarget(self.viewModel, action: #selector(self.viewModel.makeSearch), for: .touchUpInside)
        
        let closeImage = Utils.imageWithImage(image: UIImage(named: "close.png")!, scaledToSize: CGSize(width: 50, height: 50))
        let closeButton = CardPartButtonView()
        closeButton.contentHorizontalAlignment = .right
        closeButton.setImage(closeImage, for: .normal)
        closeButton.addTarget(self.viewModel, action: #selector(self.viewModel.dismissSearch), for: .touchUpInside)
        
        let stackTitle = CardPartStackView()
        stackTitle.axis = .horizontal
        stackTitle.spacing = 10
        stackTitle.distribution = .fill
        stackTitle.addArrangedSubview(searchTitleView);
        stackTitle.addArrangedSubview(closeButton);
        
        let stack = CardPartStackView()
        stack.axis = .horizontal
        stack.spacing = 10
        stack.distribution = .fill
        stack.addArrangedSubview(searchTextField);
        stack.addArrangedSubview(searchButton);
        
        return [stackTitle, CardPartSeparatorView(), stack, CardPartSeparatorView(), stackResultsPage, searchTableView]
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
    
    @objc func refreshData(sender: UIButton){
        print("refresh")
        Utils.delayWithSeconds(1, completion: {
            self.collectionViewCardPart.collectionView.refreshControl?.endRefreshing()
        })
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detail = self.viewModel.searchVehicles.value[indexPath.row]
        PopupHandler.showVehicleAddForm(detail: detail, style: .dark, buttonCompletion: {
            vehicleAddForm in
            self.viewModel.addVehicle(detail: detail, options: vehicleAddForm)
        })
    }
}
