//
//  ProfileVC.swift
//  kacagiderim_beta
//
//  Created by kamilinal on 12/5/18.
//  Copyright © 2018 kacagiderim. All rights reserved.
//

import Foundation
import CardParts

class ProfileRootVC: CardsViewController {
    
    let cardPartTextView = CardPartTextView(type: .normal)
    let profileVM = ProfileVM()
    var cards: [CardController] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.cards = [AccountVehicleVC(viewModel:profileVM)]
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
