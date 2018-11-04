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

class CarTableViewController: CardPartsViewController, ShadowCardTrait, RoundedCardTrait, TableViewDetailClick {

    weak var viewModel: CarTableViewModel!
    let cardPartTableView = CardPartTableView()
    
    public init(viewModel: CarTableViewModel) {
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
        cardPartTableView.tableView.register(CarTableViewCell.self, forCellReuseIdentifier: "CarTableViewCell")
        viewModel.state.asObservable().bind(to: self.rx.state).disposed(by: bag)
        
        viewModel.accountVehicles.asObservable().bind(to: cardPartTableView.tableView.rx.items) { tableView, index, vehicle in
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "CarTableViewCell", for: IndexPath(item: index, section: 0)) as? CarTableViewCell else { return UITableViewCell() }
            
            cell.setData(data:vehicle)
            cell.setRoot(delegate: self)
        
            return cell
            }.disposed(by: bag)
        
//        cardPartTableView.tableView.rx
//            .itemSelected
//            .subscribe(onNext: { indexPath in
//                let carDetailViewController = CarDetailViewController()
//                self.navigationController?.pushViewController(carDetailViewController, animated: true)
//            })
//            .disposed(by: bag)

        let title = "Vehicles"
        let titlePart = CardPartTitleView(type: .titleOnly)
        titlePart.label.text = title
        
        setupCardParts(getViews(title: title, image: UIImage(named: "novehicle.png")!, text: "You have no any vehicles, lets click 'Create New Vehicle' button to add new vehicle into your profile."), forState: .none)
        setupCardParts(getViews(title: title, image: UIImage(named: "novehicle.png")!, text: "You have no any vehicles, lets click 'Create New Vehicle' button to add new vehicle into your profile."), forState: .empty)
        setupCardParts(getLoadingViews(title: title, text: "Vehicles are loading..."), forState: .loading)
        setupCardParts([titlePart , CardPartSeparatorView(), cardPartTableView], forState: .hasData)
        setupCardParts(getViews(title: title, image: UIImage(named: "alert.png")!, text: "Something went wrong while getting vehicles"), forState: .custom("fail"))
    }
    
    func getViews(title: String, image: UIImage, text: String) -> [CardPartView] {
        let titlePart = CardPartTitleView(type: .titleOnly)
        titlePart.label.text = title
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
        return [titlePart, CardPartSeparatorView(), stack]
    }
    
    func getLoadingViews(title: String, text: String) -> [CardPartView]{
        let titlePart = CardPartTitleView(type: .titleOnly)
        titlePart.label.text = title
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
        return [titlePart, CardPartSeparatorView(), stack]
    }
    
    func didDetailButtonClicked(item: AccountVehicle) {
        let carDetailViewController = CarDetailViewController()
        self.navigationController?.pushViewController(carDetailViewController, animated: true)
    }
}

protocol TableViewDetailClick{
    func didDetailButtonClicked(item:AccountVehicle)
}
