//
//  NewVehicleCreateController.swift
//  kacagiderim_beta
//
//  Created by Comodo on 31.10.2018.
//  Copyright © 2018 kacagiderim. All rights reserved.
//

import UIKit
import CardParts
import RxSwift
import RxSwift
import RxDataSources
import RxCocoa
import Kingfisher

class NewVehicleCreateController : CardsViewController {
    
    var cards: [CardController] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.cards = [Toolbar(), BrandSelection()]
        loadCards(cards: cards)
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Do any additional setup after loading the view, typically from a nib.
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func didCloseTapped(sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func search(sender: UIButton) {
        self.dismiss(animated: true, completion: {})
    }
}

class Toolbar: CardPartsViewController {
    
    public init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required public init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let cancelImage = Utils.imageWithImage(image: UIImage(named: "close.png")!, scaledToSize: CGSize(width: 50, height: 50))
        let cancelPart = CardPartButtonView()
        cancelPart.setImage(cancelImage, for: UIControl.State.normal)
        cancelPart.contentHorizontalAlignment = .left
        cancelPart.addTarget(self, action: #selector(dismissTapped), for: .touchUpInside)
        
        let title = CardPartTitleView(type: .titleOnly)
        title.title = "NEW VEHICLE"
        title.titleColor = K.Constants.kacagiderimColor
        title.titleFont = CardParts.theme.titleFont
        
        let image = Utils.imageWithImage(image: UIImage(named: "search.png")!, scaledToSize: CGSize(width: 50, height: 50))
        let searchButton = CardPartButtonView()
        searchButton.contentHorizontalAlignment = .right
        searchButton.setImage(image, for: UIControl.State.normal)
        searchButton.addTarget(self, action: #selector(search), for: .touchUpInside)
        
        let sv = CardPartStackView()
        sv.spacing = 10
        sv.distribution = .fillEqually
        sv.alignment = .center
        sv.addArrangedSubview(cancelPart)
        sv.addArrangedSubview(title)
        sv.addArrangedSubview(searchButton)
    
        setupCardParts([sv])
    }
    
    @objc func dismissTapped(sender: UIButton) {
        self.dismiss(animated: true, completion: {})
    }
    
    @objc func search(sender: UIButton) {
        self.dismiss(animated: true, completion: {})
    }
}

struct SectionOfCustomStruct {
    var header: String
    var items: [Item]
}

extension SectionOfCustomStruct: SectionModelType {
    
    typealias Item = Brand
    
    init(original: SectionOfCustomStruct, items: [Item]) {
        self = original
        self.items = items
    }
}

class BrandSelection: CardPartsViewController {
    
    var titlePart = CardPartTitleView(type: .titleOnly)
    var cardPartSeparatorView = CardPartSeparatorView()
    
    var cardPartSeparatorView2 = CardPartSeparatorView()
    var collectionViewLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 5
        layout.minimumLineSpacing = 5
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: 100, height: 100)
        return layout
    }()
    lazy var collectionViewCardPart = CardPartCollectionView(collectionViewLayout: collectionViewLayout)
    let viewModel = BrandCollectionViewModel()
    
    public init() {
        super.init(nibName: nil, bundle: nil)
    }

    required public init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titlePart.label.text = "Choose Vehicle Type"
        
        let vehicleButton = CardPartButtonView()
        vehicleButton.setImage(Utils.imageWithImage(image: UIImage(named: "car.png")!, scaledToSize: CGSize(width: 50, height: 50)), for: .normal)
        vehicleButton.setImage(Utils.imageWithImage(image: UIImage(named: "add.png")!, scaledToSize: CGSize(width: 50, height: 50)), for: .highlighted)
        vehicleButton.addTarget(self, action: #selector(filterBrands), for: .touchUpInside)
        vehicleButton.tag = BrandType.AUTOMOBILE.rawValue

        let vehicleButtonTitle = CardPartTitleView(type: .titleOnly)
        vehicleButtonTitle.title = "Automobile"
        vehicleButtonTitle.titleColor = K.Constants.kacagiderimColor
        vehicleButtonTitle.titleFont = CardParts.theme.normalTextFont
        
        let stackVehicle = CardPartStackView()
        stackVehicle.axis = .vertical
        stackVehicle.spacing = 10
        stackVehicle.distribution = .fillProportionally
        stackVehicle.alignment = .center
        stackVehicle.addArrangedSubview(vehicleButton);
        stackVehicle.addArrangedSubview(vehicleButtonTitle);
        
        let vehicleMinivanButton = CardPartButtonView()
        vehicleMinivanButton.setImage(Utils.imageWithImage(image: UIImage(named: "car.png")!, scaledToSize: CGSize(width: 50, height: 50)), for: .normal)
        vehicleMinivanButton.setImage(Utils.imageWithImage(image: UIImage(named: "add.png")!, scaledToSize: CGSize(width: 50, height: 50)), for: .highlighted)
        vehicleMinivanButton.addTarget(self, action: #selector(filterBrands), for: .touchUpInside)
        vehicleMinivanButton.tag = BrandType.MINIVAN.rawValue
        
        let vehicleMinivanButtonTitle = CardPartTitleView(type: .titleOnly)
        vehicleMinivanButtonTitle.title = "Minivan"
        vehicleMinivanButtonTitle.titleColor = K.Constants.kacagiderimColor
        vehicleMinivanButtonTitle.titleFont = CardParts.theme.normalTextFont
        
        let stackMinivanVehicle = CardPartStackView()
        stackMinivanVehicle.axis = .vertical
        stackMinivanVehicle.spacing = 10
        stackMinivanVehicle.distribution = .fillProportionally
        stackMinivanVehicle.alignment = .center
        stackMinivanVehicle.addArrangedSubview(vehicleMinivanButton);
        stackMinivanVehicle.addArrangedSubview(vehicleMinivanButtonTitle);
        
        let vehicleSuvButton = CardPartButtonView()
        vehicleSuvButton.setImage(Utils.imageWithImage(image: UIImage(named: "car.png")!, scaledToSize: CGSize(width: 50, height: 50)), for: .normal)
        vehicleSuvButton.setImage(Utils.imageWithImage(image: UIImage(named: "add.png")!, scaledToSize: CGSize(width: 50, height: 50)), for: .highlighted)
        vehicleSuvButton.addTarget(self, action: #selector(filterBrands), for: .touchUpInside)
        vehicleSuvButton.tag = BrandType.SUV.rawValue
        
        let vehicleSuvButtonTitle = CardPartTitleView(type: .titleOnly)
        vehicleSuvButtonTitle.title = "SUV"
        vehicleSuvButtonTitle.titleColor = K.Constants.kacagiderimColor
        vehicleSuvButtonTitle.titleFont = CardParts.theme.normalTextFont
        
        let stackSuvVehicle = CardPartStackView()
        stackSuvVehicle.axis = .vertical
        stackSuvVehicle.spacing = 10
        stackSuvVehicle.distribution = .fillProportionally
        stackSuvVehicle.alignment = .center
        stackSuvVehicle.addArrangedSubview(vehicleSuvButton);
        stackSuvVehicle.addArrangedSubview(vehicleSuvButtonTitle);
        
        let stack = CardPartStackView()
        stack.axis = .horizontal
        stack.spacing = 10
        stack.distribution = .fillEqually
        stack.addArrangedSubview(stackVehicle)
        stack.addArrangedSubview(stackMinivanVehicle)
        stack.addArrangedSubview(stackSuvVehicle)
        
        collectionViewCardPart.collectionView.register(MyCustomCollectionViewCell.self, forCellWithReuseIdentifier: "MyCustomCollectionViewCell")
        collectionViewCardPart.collectionView.backgroundColor = .clear
        collectionViewCardPart.collectionView.showsHorizontalScrollIndicator = false
        
        let dataSource = RxCollectionViewSectionedReloadDataSource<SectionOfCustomStruct>(configureCell: {[weak self] (_, collectionView, indexPath, data) -> UICollectionViewCell in
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyCustomCollectionViewCell", for: indexPath) as? MyCustomCollectionViewCell else { return UICollectionViewCell() }
            
            cell.setData(data)
            
            cell.backgroundColor = UIColor.white
            cell.layer.cornerRadius = 5
            cell.layer.borderWidth = 1
            cell.layer.borderColor = UIColor(red: 0.93, green: 0.93, blue: 0.95, alpha: 1.0).cgColor
            
            return cell
        })
        
        viewModel.data.asObservable().bind(to: collectionViewCardPart.collectionView.rx.items(dataSource: dataSource)).disposed(by: bag)
        collectionViewCardPart.collectionView.frame = CGRect(x: 0, y: 0, width: 400, height: 400)
        
        setupCardParts([titlePart, cardPartSeparatorView, stack, cardPartSeparatorView2, collectionViewCardPart])
    }
    
    @objc func filterBrands(sender: UIButton) {
        viewModel.filterBrands(type: sender.tag)
    }
}

class BrandCollectionViewModel {
    
    typealias ReactiveSection = Variable<[SectionOfCustomStruct]>
    var data = ReactiveSection([])
    
    init() {
        let brands = DefaultManager.getBrands()
        data.value = [SectionOfCustomStruct(header: "", items: brands)]
    }
    
    func filterBrands(type: Int){
        let brands = DefaultManager.getBrands()
        if(brands.count < 1){
            APIClient.getBrands(completion: { result in
                switch result {
                case .success(let response):
                    let brands = response.value?.pageResult ?? []
                    DefaultManager.setBrands(brands: brands)
                    self.data.value = [SectionOfCustomStruct(header: "", items: brands.filter { $0.type == type })]
                case .failure(let error):
                    print((error as! CustomError).localizedDescription)
                }
            })
        }
        else{
            data.value = [SectionOfCustomStruct(header: "", items: brands.filter { $0.type == type })]
        }
    }
}

class MyCustomCollectionViewCell: CardPartCollectionViewCardPartsCell {
    let bag = DisposeBag()
    
    let titleCP = CardPartTextView(type: .normal)
    let imageCP = CardPartImageView(image: Utils.imageWithImage(image: UIImage(named: "add.png")!, scaledToSize: CGSize(width: 50, height: 50)))
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
//        titleCP.margins = .init(top: 50, left: 20, bottom: 5, right: 30)
        titleCP.font = CardParts.theme.smallTextFont
        
        let stack = CardPartStackView()
        stack.axis = .vertical
        stack.spacing = 5
        stack.distribution = .fillProportionally
        stack.alignment = .center
        stack.addArrangedSubview(titleCP);
        stack.addArrangedSubview(imageCP);
        
        // stack titleCP height = 0.3 x imageCP
        stack.addConstraint(NSLayoutConstraint(item: titleCP, attribute: .height, relatedBy: .equal, toItem:nil , attribute: .height, multiplier: 0, constant: 25.0))
        stack.addConstraint(NSLayoutConstraint(item: imageCP, attribute: .height, relatedBy: .equal, toItem:nil , attribute: .height, multiplier: 0, constant: 50.0))
        
        setupCardParts([stack])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setData(_ data: Brand) {
        
        titleCP.text = data.name
        titleCP.textAlignment = .center
        titleCP.textColor = .black
        
        let imageURL = data.imageName ?? ""
        
//        // TODO GET IMAGE FROM URL
//        ImageCache.default.retrieveImage(forKey: imageURL, options: nil) {
//            image, cacheType in
//            if let image = image {
//                print("Get image \(image), cacheType: \(cacheType).")
//                //In this code snippet, the `cacheType` is .disk
//                self.imageCP.image = image
//            } else {
//                print("Not exist in cache.")
//                let url = URL(string: imageURL)!
//                ImageDownloader.default.downloadImage(with: url, options: [], progressBlock: nil) {
//                    (image, error, url, data) in
//                    if let image = image {
//                        ImageCache.default.store(image, forKey: imageURL)
//                        self.imageCP.image = image
//                    }
//                }
//            }
//        }
    }
}
