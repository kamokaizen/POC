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

class CarTableViewController: CardPartsViewController, ShadowCardTrait, RoundedCardTrait, TableViewDetailClick, CardPartTableViewDelegte {

    weak var viewModel: CarTableViewModel!
    var cardPartTableView = CardPartTableView()
    
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
        
        cardPartTableView.delegate = self
//        cardPartTableView.tableView.delegate = self
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
        
        setupCardParts(getViews(title: title, image: UIImage(named: "novehicle.png")!, text: "You have no any vehicles, lets click 'New' button to add new vehicle into your profile."), forState: .none)
        setupCardParts(getViews(title: title, image: UIImage(named: "novehicle.png")!, text: "You have no any vehicles, lets click 'New' button to add new vehicle into your profile."), forState: .empty)
        setupCardParts(getLoadingViews(title: title, text: "Vehicles are loading..."), forState: .loading)
        setupCardParts([getTitleViews(title: title) , CardPartSeparatorView(), cardPartTableView], forState: .hasData)
        setupCardParts(getViews(title: title, image: UIImage(named: "alert.png")!, text: "Something went wrong while getting vehicles"), forState: .custom("fail"))
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
    
    func getTitleViews(title: String) -> CardPartStackView {
        let titlePart = CardPartTitleView(type: .titleOnly)
        titlePart.label.text = title
        
        let addImage = Utils.imageWithImage(image: UIImage(named: "add.png")!, scaledToSize: CGSize(width: 20, height: 20))
        let newButton = CardPartButtonView()
        newButton.frame.size = CGSize(width: 30, height: 30);
        newButton.contentHorizontalAlignment = .right
        newButton.setImage(addImage, for: .normal)
        newButton.addTarget(self, action: #selector(self.createButtonTapped), for: .touchUpInside)
       
        let editImage = Utils.imageWithImage(image: UIImage(named: "edit.png")!, scaledToSize: CGSize(width: 20, height: 20))
        let editButton = CardPartButtonView()
        editButton.frame.size = CGSize(width: 30, height: 30);
        editButton.contentHorizontalAlignment = .right
        editButton.setImage(editImage, for: .normal)
        editButton.addTarget(self, action: #selector(self.editItemTapped), for: .touchUpInside)
        
        let refreshImage = Utils.imageWithImage(image: UIImage(named: "refresh.png")!, scaledToSize: CGSize(width: 20, height: 20))
        let refreshButton = CardPartButtonView()
        refreshButton.frame.size = CGSize(width: 30, height: 30);
        refreshButton.contentHorizontalAlignment = .right
        refreshButton.setImage(refreshImage, for: .normal)
        refreshButton.addTarget(self.viewModel, action: #selector(self.viewModel.refreshData(_:)), for: .touchUpInside)
        
        let sv = CardPartStackView()
        sv.spacing = 10
        sv.distribution = .fill
        sv.alignment = .center
        sv.addArrangedSubview(titlePart)
        sv.addArrangedSubview(editButton)
        sv.addArrangedSubview(refreshButton)
        sv.addArrangedSubview(newButton)
        
        return sv
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
        let carDetailViewController = CarDetailViewController()
        self.navigationController?.pushViewController(carDetailViewController, animated: true)
    }
    
    @objc func createButtonTapped(sender: UIButton) {
        let storyboard = UIStoryboard(name: "NewVehicleVC", bundle: nil)
        let vc = storyboard.instantiateInitialViewController() as? NewVehicleVC
        self.present(vc!, animated: true, completion: {})
    }
    
    @objc func editItemTapped(sender: UIButton) {
        cardPartTableView.tableView.setEditing(!cardPartTableView.tableView.isEditing, animated: true)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let carDetailViewController = CarDetailViewController()
        self.navigationController?.pushViewController(carDetailViewController, animated: true)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return 100
    }
    
//    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
//        return true
//    }
//
//    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAtIndexPath: IndexPath){
//        if (editingStyle == .delete) {
//            // handle delete (by removing the data from your array and updating the tableview)
//        }
//    }
}

protocol TableViewDetailClick{
    func didDetailButtonClicked(item:AccountVehicle)
}
