//
//  LoginViewController.swift
//  kacagiderim_beta
//
//  Created by kamilinal on 7/14/18.
//  Copyright © 2018 kacagiderim. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet var signInButton: UIButton!
    @IBOutlet var createAccountButton: UIButton!
    
    var didFailureUpdateData: ((Error) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // get countries
        API.shared.getAllCountries(failure: { [unowned self] (error) in
            self.didFailureUpdateData?(error)
            }, success: { [unowned self] countries in
                print(countries as Any)
        })
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
    
    @IBAction func didSignInTapped(sender: UIButton) {
        self.performSegue(withIdentifier: "signinSegue", sender:sender)
    }
    
    @IBAction func didCreateAccountTapped(sender: UIButton) {
       self.performSegue(withIdentifier: "signupSegue", sender:sender)
    }
}
