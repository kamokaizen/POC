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
//    let carCreateViewModel = CarCreateViewModel()
    var cards: [CardController] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.cards = [CarTableViewController(viewModel:carTableVievModel)]
        loadCards(cards: cards)
        carTableVievModel.getVehicles()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Do any additional setup after loading the view, typically from a nib.
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
