//
//  ProfileViewController.swift
//  kacagiderim_beta
//
//  Created by Comodo on 16.07.2018.
//  Copyright © 2018 kacagiderim. All rights reserved.
//

import UIKit
import Dodo
import CardParts

class ProfileViewController: CardsViewController {
    
    @IBOutlet var activeUserLabel: UILabel!
    @IBOutlet var logoutButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        self.activeUserLabel.text = UserDefaults.standard.string(forKey: "activeUser")
        APIClient.getCurrentUser(completion:{ result in
            switch result {
            case .success(let userResponse):
                UserDefaults.standard.set(try? PropertyListEncoder().encode(userResponse.principal.userDto), forKey: "userProfile")
            case .failure(let error):
                print((error as! CustomError).localizedDescription)
            }
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Actions
    
    @IBAction func didLogoutTapped(sender: UIButton) {
        TokenController.deleteUserFromUserDefaults()
        Switcher.updateRootVC()
    }
}

