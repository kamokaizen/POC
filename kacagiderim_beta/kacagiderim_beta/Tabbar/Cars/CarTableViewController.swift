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

class CarTableViewController: CardPartsViewController, ShadowCardTrait, RoundedCardTrait {
    
    weak var viewModel: CarTableViewModel!
    var titlePart = CardPartTitleView(type: .titleOnly)
    var cardPartSeparatorView = CardPartSeparatorView()
    let cardPartTableView = CardPartTableView()
    
    let loadingTextView = CardPartTextView(type: .normal)
    var loadingIndicator = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 100, height: 100), type: K.Constants.default_spinner, color:UIColor.black , padding: 0)
    var emptyImageView = CardPartImageView(image: UIImage(named: "novehicle.png"))
    let emptyTextView = CardPartTextView(type: .normal)
    
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
        titlePart.label.text = "Vehicles"
        loadingTextView.text = "Vehicles are loading"
        emptyTextView.text = "You have no any vehicles, lets click 'Create New Vehicle' button to add new vehicle into your profile."
        emptyImageView.contentMode = .scaleAspectFit;
        
        cardPartTableView.tableView.register(MyCustomTableViewCell.self, forCellReuseIdentifier: "CarTableViewCell")
        viewModel.state.asObservable().bind(to: self.rx.state).disposed(by: bag)
        
        viewModel.vehicles.asObservable().bind(to: cardPartTableView.tableView.rx.items) { tableView, index, data in
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "CarTableViewCell", for: IndexPath(item: index, section: 0)) as? CarTableViewCell else { return UITableViewCell() }
            
            cell.setData(data:data)
            
            return cell
            }.disposed(by: bag)
        
        let stackLoading = CardPartStackView()
        stackLoading.axis = .vertical
        stackLoading.spacing = 10
        stackLoading.distribution = .equalSpacing
        stackLoading.alignment = UIStackView.Alignment.center
        stackLoading.addArrangedSubview(loadingIndicator);
        stackLoading.addArrangedSubview(loadingTextView);
        loadingIndicator.startAnimating()
        
        let stackEmpty = CardPartStackView()
        stackEmpty.axis = .vertical
        stackEmpty.spacing = 10
        stackEmpty.distribution = .equalSpacing
        stackEmpty.alignment = UIStackView.Alignment.center
        stackEmpty.addArrangedSubview(emptyImageView);
        stackEmpty.addArrangedSubview(emptyTextView);
        
        setupCardParts([titlePart, cardPartSeparatorView, cardPartTableView], forState: .hasData)
        setupCardParts([titlePart, cardPartSeparatorView, stackLoading], forState: .loading)
        setupCardParts([titlePart, cardPartSeparatorView, stackEmpty], forState: .empty)
    }
}
