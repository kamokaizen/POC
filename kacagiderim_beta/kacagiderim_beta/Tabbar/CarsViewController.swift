//
//  CarsViewController.swift
//  kacagiderim_beta
//
//  Created by Comodo on 16.07.2018.
//  Copyright © 2018 kacagiderim. All rights reserved.
//


import UIKit
import SwiftEntryKit
import CardParts
import RxSwift
import RxCocoa

class CarViewController: CardsViewController {
    
    let cardPartTextView = CardPartTextView(type: .normal)
    let carTableVievModel = CarTableViewModel()
    let carCreateViewModel = CarCreateViewModel()
    var cards: [CardController] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.cards = [CarCreateViewController(viewModel:carCreateViewModel),
                      CarTableViewController(viewModel:carTableVievModel)]
        loadCards(cards: cards)
        
//        // Do any additional setup after loading the view, typically from a nib.
//        let brands = UserDefaults.standard.value(forKeyPath: "brands") as? [Brand];
//        if(brands == nil){
//            APIClient.getBrands(completion: { result in
//                switch result {
//                case .success(let response):
//                    let brands = response.value?.pageResult
//                    UserDefaults.standard.set(try? PropertyListEncoder().encode(brands), forKey: "brands")
////                    if((brands != nil) && (brands?.count)! > 0){
////                        let zeroTypeBrands = brands?.filter { $0.type == 0 }
////                        let oneTypeBrands = brands?.filter { $0.type == 1 }
////                        let twoTypeBrands = brands?.filter { $0.type == 2 }
////                    }
//                case .failure(let error):
//                    print((error as! CustomError).localizedDescription)
//                }
//            })
//        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Do any additional setup after loading the view, typically from a nib.
        carTableVievModel.getVehicles()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
