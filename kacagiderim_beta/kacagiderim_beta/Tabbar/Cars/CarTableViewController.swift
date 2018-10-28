//
//  CarTableViewController.swift
//  kacagiderim_beta
//
//  Created by kamilinal on 10/28/18.
//  Copyright © 2018 kacagiderim. All rights reserved.
//

import Foundation
import CardParts

class CarTableViewController: CardPartsViewController, ShadowCardTrait, RoundedCardTrait {
    
    weak var viewModel: CarTableViewModel!
    var titlePart = CardPartTitleView(type: .titleOnly)
    var cardPartSeparatorView = CardPartSeparatorView()
    let cardPartTableView = CardPartTableView()
    
    let loadingTextView = CardPartTextView(type: .header)
    var loadingImageView = CardPartImageView(image: UIImage(named: "home.png"))
    var emptyImageView = CardPartImageView(image: UIImage(named: "novehicle.png"))
    let emptyTextView = CardPartTextView(type: .header)
    
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
        titlePart.label.text = "Your Vehicles"
        loadingTextView.label.text = "Your Vehicles are loading"
        emptyTextView.label.text = "You have no any vehicles"
        
        loadingImageView.contentMode = .scaleAspectFit;
        emptyImageView.contentMode = .scaleAspectFit;
        
        cardPartTableView.tableView.register(MyCustomTableViewCell.self, forCellReuseIdentifier: "CarTableViewCell")
        viewModel.state.asObservable().bind(to: self.rx.state).disposed(by: bag)
        
        viewModel.vehicles.asObservable().bind(to: cardPartTableView.tableView.rx.items) { tableView, index, data in
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "CarTableViewCell", for: IndexPath(item: index, section: 0)) as? CarTableViewCell else { return UITableViewCell() }
            
            cell.setData(data:data)
            
            return cell
            }.disposed(by: bag)
        
        setupCardParts([titlePart, cardPartSeparatorView, cardPartTableView], forState: .hasData)
        setupCardParts([loadingTextView,cardPartSeparatorView, loadingImageView], forState: .loading)
        setupCardParts([emptyTextView,cardPartSeparatorView, emptyImageView], forState: .empty)
    }
}
