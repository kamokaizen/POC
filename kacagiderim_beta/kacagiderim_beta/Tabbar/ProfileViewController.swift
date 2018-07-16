//
//  ProfileViewController.swift
//  kacagiderim_beta
//
//  Created by Comodo on 16.07.2018.
//  Copyright © 2018 kacagiderim. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    
    @IBOutlet var activeUserLabel: UILabel!
    @IBOutlet var logoutButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.activeUserLabel.text = UserDefaults.standard.string(forKey: "activeUser")
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
        UserDefaults.standard.set(false, forKey: "isLoggedIn")
        Switcher.updateRootVC()
    }
}
