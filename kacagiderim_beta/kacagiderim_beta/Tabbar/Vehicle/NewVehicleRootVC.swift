//
//  NewVehicleCreateController.swift
//  kacagiderim_beta
//
//  Created by Comodo on 31.10.2018.
//  Copyright © 2018 kacagiderim. All rights reserved.
//

import UIKit
import CardParts

class NewVehicleRootVC : CardsViewController {
    
    var cards: [CardController] = []
    var viewModel: NewVehicleVM!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.viewModel = NewVehicleVM()
        
        self.cards = [NewVehicleVC(viewModel: self.viewModel)]
        loadCards(cards: cards)
        
        viewModel.filterBrands(type: BrandType.AUTOMOBILE.rawValue)
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
}
