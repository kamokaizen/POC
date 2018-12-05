//
//  CarTableViewController.swift
//  kacagiderim_beta
//
//  Created by kamilinal on 10/28/18.
//  Copyright © 2018 kacagiderim. All rights reserved.
//

import Foundation
import CardParts
import NVActivityIndicatorView

class AccountVehicleVC: BaseCardPartsViewController, TableViewDetailClick, CardPartTableViewDelegte {

    weak var viewModel: AccountVehicleVM!
    var cardPartTableView = CardPartTableView()
        
    public init(viewModel: AccountVehicleVM) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
    }
    
    required public init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cardPartTableView.delegate = self
        cardPartTableView.tableView.register(CarTableViewCell.self, forCellReuseIdentifier: "CarTableViewCell")
        
        viewModel.state.asObservable().bind(to: self.rx.state).disposed(by: bag)
        
        viewModel.accountVehicles.asObservable().bind(to: cardPartTableView.tableView.rx.items) { tableView, index, vehicle in
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "CarTableViewCell", for: IndexPath(item: index, section: 0)) as? CarTableViewCell else { return UITableViewCell() }
            
            cell.setData(data:vehicle)
            cell.setRoot(delegate: self)
        
            return cell
            }.disposed(by: bag)
        
        cardPartTableView.tableView.rx.itemDeleted
            .subscribe({indexPath in
                self.viewModel.deleteRow(indexPath: (indexPath.element?.row)!)
            })
            .disposed(by: bag)
        
//        cardPartTableView.tableView.rx
//            .itemSelected
//            .subscribe(onNext: { indexPath in
//                let carDetailViewController = CarDetailViewController()
//                self.navigationController?.pushViewController(carDetailViewController, animated: true)
//            })
//            .disposed(by: bag)

        let title = "Vehicles"
        
//        let stack = CardPartStackView()
//        stack.axis = .vertical
//        stack.spacing = 10
//        stack.distribution = .fill
//        stack.addSubview(searchController as UIView);
//        stack.addArrangedSubview(cardPartTableView);
        
        setupCardParts(getViews(title: title, image: UIImage(named: "novehicle.png")!, text: "You have no any vehicles"), forState: .none)
        setupCardParts(getViews(title: title, image: UIImage(named: "novehicle.png")!, text: "You have no any vehicles"), forState: .empty)
        setupCardParts(getLoadingViews(title: title, text: "Vehicles are loading..."), forState: .loading)
        setupCardParts([getTitleViews(title: title) , CardPartSeparatorView(), cardPartTableView], forState: .hasData)
        setupCardParts(getViews(title: title, image: UIImage(named: "alert.png")!, text: "Something went wrong while getting vehicles"), forState: .custom("fail"))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.getAccountVehicles()
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
        return [getTitleViews(title: title), CardPartSeparatorView(), stack]
    }
    
    func getTitleViews(title: String) -> CardPartView {
        let buttonStack = CardPartTitleView(type: .titleWithMenu)
        buttonStack.menuTitle = "Actions"
        buttonStack.menuOptions = ["New", "Refresh", "Search"]
        buttonStack.menuOptionObserver  = {[weak self] (title, index) in
            if index == 0 {
                let storyboard = UIStoryboard(name: "NewVehicleRootVC", bundle: nil)
                let vc = storyboard.instantiateInitialViewController() as? NewVehicleRootVC
                self?.present(vc!, animated: true, completion: {})
            }
            else if index == 1 {
                self?.viewModel.refreshAccountVehicles()
            }
            else if index == 2 {
                let storyboard = UIStoryboard(name: "SearchVehicleRootVC", bundle: nil)
                let vc = storyboard.instantiateInitialViewController() as? SearchVehicleRootVC
                self?.present(vc!, animated: true, completion: {})
            }
        }
        let titlePart = CardPartsUtil.titleWithMenu(leftTitleText: title, menu: buttonStack)
        return titlePart
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
        return [getTitleViews(title: title), CardPartSeparatorView(), stack]
    }
        
    func didDetailButtonClicked(item: AccountVehicle) {
        let accountVehicleDetailController = AccountVehicleDetailVC(accountVehicle: item)
        self.navigationController?.pushViewController(accountVehicleDetailController, animated: true)
    }
    
//    @objc func editItemTapped(sender: UIButton) {
//        cardPartTableView.tableView.setEditing(!cardPartTableView.tableView.isEditing, animated: true)
//    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedAccountVehicle = self.viewModel.accountVehicles.value[indexPath.row]
        let accountVehicleDetailController = AccountVehicleDetailVC(accountVehicle: selectedAccountVehicle)
        self.navigationController?.pushViewController(accountVehicleDetailController, animated: true)
    }
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
//        return 100
//    }
}

protocol TableViewDetailClick{
    func didDetailButtonClicked(item:AccountVehicle)
}
