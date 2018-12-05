//
//  SearchVehicleVC.swift
//  kacagiderim_beta
//
//  Created by kamilinal on 12/4/18.
//  Copyright © 2018 kacagiderim. All rights reserved.
//

import Foundation
import CardParts
import NVActivityIndicatorView

class SearchVehicleVC : CardPartsViewController, CardPartTableViewDelegte, GradientCardTrait, UISearchBarDelegate {
    
    var viewModel: SearchVehicleVM!
    var searchTableView = CardPartTableView()
    var loadingIndicator = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50), type: K.Constants.default_spinner, color:UIColor.black , padding: 0)
    
    public init() {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = SearchVehicleVM()
    }
    
    required public init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func gradientColors() -> [UIColor] {
        return [EKColor.Gray.light, EKColor.BlueGradient.light]
    }
    
    func gradientAngle() -> Float {
        return 45.0
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.state.asObservable().bind(to: self.rx.state).disposed(by: bag)
        
        loadingIndicator.startAnimating()
        
        searchTableView.tableView.register(CarSearchTableViewCell.self, forCellReuseIdentifier: "CarSearchTableViewCell")
        searchTableView.delegate = self
        
        viewModel.searchVehicles.asObservable().bind(to: searchTableView.tableView.rx.items) { tableView, index, detail in
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "CarSearchTableViewCell", for: IndexPath(item: index, section: 0)) as? CarSearchTableViewCell else { return UITableViewCell() }
            
            cell.setData(data:detail)
            
            return cell
            }.disposed(by: bag)
        
        setupCardParts([CardPartsUtil.getTitleView(title: "Vehicle Search"),CardPartSeparatorView(), getSearchViews()], forState: .none)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getSearchViews() -> CardPartView{        
        let searchBar = UISearchBar()
        searchBar.delegate = self
        searchBar.backgroundImage = UIImage()
        searchBar.layer.masksToBounds = false
        searchBar.showsCancelButton = true
        searchBar.showsBookmarkButton = false
        searchBar.searchBarStyle = UISearchBar.Style.default
        searchBar.placeholder = "Type a vehicle..."
        searchBar.tintColor = UIColor.black
        
        let searchResultTitleView = CardPartTitleView(type:.titleOnly)
        
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
        
        viewModel.searchString.asObservable().bind(to: searchBar.rx.text).disposed(by: bag)
        viewModel.searchResultString.asObservable().bind(to: searchResultTitleView.rx.title).disposed(by: bag)
        searchBar.rx.text.orEmpty.bind(to: viewModel.searchString).disposed(by: bag)
        viewModel.isPaginationNextButtonHide.asObservable().bind(to: nextButton.rx.isHidden).disposed(by: bag)
        viewModel.isPaginationBackButtonHide.asObservable().bind(to: backButton.rx.isHidden).disposed(by: bag)
        viewModel.isSearchResultsStackHide.asObservable().bind(to: stackPage.rx.isHidden).disposed(by: bag)
        
        let seperator1 = CardPartSeparatorView()
        let seperator2 = CardPartSeparatorView()
        viewModel.isSearchResultsStackHide.asObservable().bind(to: seperator1.rx.isHidden).disposed(by: bag)
        viewModel.isSearchResultsStackHide.asObservable().bind(to: seperator2.rx.isHidden).disposed(by: bag)
        
        let mainStack = CardPartStackView()
        mainStack.axis = .vertical
        mainStack.spacing = 10
        mainStack.distribution = .fill
        mainStack.addArrangedSubview(searchBar)
        mainStack.addArrangedSubview(seperator1);
        mainStack.addArrangedSubview(stackPage);
        mainStack.addArrangedSubview(seperator2);
        mainStack.addArrangedSubview(searchTableView);
        mainStack.addArrangedSubview(loadingIndicator);
        
        viewModel.isLoading.asObservable().map({$0 == true ? false : true}).bind(to: self.loadingIndicator.rx.isHidden).disposed(by:bag)
        viewModel.isLoading.asObservable().bind(to: self.searchTableView.rx.isHidden).disposed(by: bag)
        
        return mainStack
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detail = self.viewModel.searchVehicles.value[indexPath.row]
        PopupHandler.showVehicleAddForm(detail: detail, style: .dark, buttonCompletion: {
            vehicleAddForm in
            self.viewModel.addVehicle(detail: detail, options: vehicleAddForm)
        })
    }
    
    // called whenever text is changed.
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print(searchText)
    }
    
    // called when cancel button is clicked
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.dismiss(animated: true, completion: {})
    }
    
    // called when search button is clicked
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.viewModel.makeSearch()
    }
}
