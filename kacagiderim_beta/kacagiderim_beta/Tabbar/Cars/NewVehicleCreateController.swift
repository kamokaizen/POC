//
//  NewVehicleCreateController.swift
//  kacagiderim_beta
//
//  Created by Comodo on 31.10.2018.
//  Copyright © 2018 kacagiderim. All rights reserved.
//

import UIKit
import CardParts

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
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
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
