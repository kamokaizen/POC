//
//  CarDetailViewController.swift
//  kacagiderim_beta
//
//  Created by Comodo on 30.10.2018.
//  Copyright © 2018 kacagiderim. All rights reserved.
//

import Foundation
import CardParts

class AccountVehicleDetailVC: CardsViewController {
    
    var cards: [CardController] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.cards = []
        loadCards(cards: cards)
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
