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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
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
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if(segue.identifier == "signupSegue"){
//            let destinationViewController = segue.destination as? SignUpViewController
//            destinationViewController?.countries = self.countries
//        }
//    }
    
    // MARK: - Actions
    
    @IBAction func didSignInTapped(sender: UIButton) {
        self.performSegue(withIdentifier: "signinSegue", sender:sender)
    }
    
    @IBAction func didCreateAccountTapped(sender: UIButton) {
       self.performSegue(withIdentifier: "signupSegue", sender:sender)
    }
}
