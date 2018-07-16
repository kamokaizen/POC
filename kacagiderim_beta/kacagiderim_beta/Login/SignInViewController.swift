//
//  ViewController.swift
//  kacagiderim_beta
//
//  Created by kamilinal on 7/14/18.
//  Copyright © 2018 kacagiderim. All rights reserved.
//

import UIKit
import TextFieldEffects
import EGFormValidator

class SignInViewController: ValidatorViewController {
        
    @IBOutlet var emailField: HoshiTextField!
    @IBOutlet var passwordField: HoshiTextField!
    @IBOutlet var forgotPasswordButton: UIButton!
    @IBOutlet var signInButton: UIButton!
    var recoverMode:Bool = false
    
    /// Error labels
    @IBOutlet weak var emailErrorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Empty error labels (they have some text in the storyboard)
        self.emailErrorLabel.text = ""
        
        // add validators
        addValidators()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /// Add validators
    func addValidators() {
        // Mandatory validator
        self.addValidatorMandatory(toControl: self.emailField,
                                   errorPlaceholder: self.emailErrorLabel,
                                   errorMessage: "This field is required")
        
        // Email validator
        self.addValidatorEmail(toControl: self.emailField,
                               errorPlaceholder: self.emailErrorLabel,
                               errorMessage: "Email is invalid")
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
        if self.validate() {
            // show success alert
            let alert = UIAlertController(title: "Congratulations!",
                                          message: "All fields are valid",
                                          preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.destructive, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
            
        } else {
            
            
        }
        
//
//        if(recoverMode){
//            // call recover
//            print("recover mode called")
//        }
//        else{
//            // call sign in
//            print("signin mode called")
//            // after loging success, goto main
//            UserDefaults.standard.set(true, forKey: "isLoggedIn")
//            UserDefaults.standard.set(self.emailField.text, forKey: "activeUser")
//            Switcher.updateRootVC()
//        }
    }
}

