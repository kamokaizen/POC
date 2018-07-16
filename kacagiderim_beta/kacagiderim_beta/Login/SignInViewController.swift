//
//  ViewController.swift
//  kacagiderim_beta
//
//  Created by kamilinal on 7/14/18.
//  Copyright © 2018 kacagiderim. All rights reserved.
//

import UIKit
import TextFieldEffects

class SignInViewController: UIViewController {
    
    @IBOutlet var emailField: HoshiTextField!
    @IBOutlet var passwordField: HoshiTextField!
    @IBOutlet var forgotPasswordButton: UIButton!
    @IBOutlet var signInButton: UIButton!
    var recoverMode:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
    
    // MARK: - Actions
    
    @IBAction func didCloseTapped(sender: UIButton) {
        if(recoverMode){
            self.recoverMode = false
            self.passwordField.isHidden = false
            self.forgotPasswordButton.isHidden = false
            self.signInButton.setTitle("Sign In", for: UIControlState.normal)
            self.emailField.placeholder = "Email"
        }
        else{
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func didForgotPasswodTapped(sender: UIButton) {
        self.recoverMode = true
        self.passwordField.isHidden = true
        self.forgotPasswordButton.isHidden = true
        self.signInButton.setTitle("Recover", for: UIControlState.normal)
        self.emailField.placeholder = "Recover Email"
    }
    
    @IBAction func didSignInButtonTapped(sender: UIButton) {
        if(recoverMode){
            // call recover
            print("recover mode called")
        }
        else{
            // call sign in
            print("signin mode called")
            // after loging success, goto main
            UserDefaults.standard.set(true, forKey: "isLoggedIn")
            UserDefaults.standard.set(self.emailField.text, forKey: "activeUser")
            Switcher.updateRootVC()
        }
    }
}

