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
import NVActivityIndicatorView
import Dodo
import SwiftEntryKit

class SignInViewController: ValidatorViewController, UITextFieldDelegate {
        
    @IBOutlet var emailField: HoshiTextField!
    @IBOutlet var passwordField: HoshiTextField!
    @IBOutlet var forgotPasswordButton: UIButton!
    @IBOutlet var signInButton: UIButton!
    @IBOutlet var loadingIndicator: NVActivityIndicatorView!
    var recoverMode:Bool = false
    var messageHelper = MessageHelper()
    
    /// Error labels
    @IBOutlet weak var emailErrorLabel: UILabel!
    @IBOutlet weak var passwordErrorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Empty error labels (they have some text in the storyboard)
        self.emailErrorLabel.text = ""
        self.passwordErrorLabel.text = ""
        
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
        
        // Mandatory validator
        self.addValidatorMandatory(toControl: self.passwordField,
                                   errorPlaceholder: self.passwordErrorLabel,
                                   errorMessage: "This field is required")
        
        // Minlength
        self.addValidatorMinLength(toControl: self.passwordField,
                                   errorPlaceholder: self.passwordErrorLabel,
                                   errorMessage: "Password must be minimum %d characters",
                                   minLength: 8)
    }
    
    func changeFieldValidationColors(){
        if !self.validate(){
            if(self.emailErrorLabel.text != nil){
                self.emailField.borderInactiveColor = UIColor.red
                self.emailField.borderActiveColor = UIColor.red
            }
            if(self.passwordErrorLabel.text != nil){
                self.passwordField.borderInactiveColor = UIColor.red
                self.passwordField.borderActiveColor = UIColor.red
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
        
    // MARK: - Actions
    
    @IBAction func didCloseTapped(sender: UIButton) {
        if(recoverMode){
            self.recoverMode = false
            self.passwordField.isHidden = false
            self.forgotPasswordButton.isHidden = false
            self.passwordErrorLabel.isHidden = false
            self.signInButton.setTitle("Sign In", for: UIControl.State.normal)
            self.emailField.placeholder = "Email"
            self.passwordField.text = ""
        }
        else{
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func didForgotPasswodTapped(sender: UIButton) {
        self.recoverMode = true
        self.passwordField.isHidden = true
        self.passwordErrorLabel.isHidden = true
        self.forgotPasswordButton.isHidden = true
        self.signInButton.setTitle("Recover", for: UIControl.State.normal)
        self.emailField.placeholder = "Recovery Email"
        self.passwordField.text = "dummypassword"
    }
    
    @IBAction func didSignInButtonTapped(sender: UIButton) {
        self.changeFieldValidationColors()
        if !self.validate(){ return }
        
        if(recoverMode){
            // call recover
            print("recover mode called")
            PopupHandler.successPopup(title: "Success", description: "Your password recovery email sent");
        }
        else{
            // call sign in
            self.loadingIndicator.startAnimating()
            
            APIClient.login(email: emailField.text!, password: passwordField.text!, completion:{ result in
                switch result {
                case .success(let loginResponse):
                    self.loadingIndicator.stopAnimating()
                    PopupHandler.showLoginSuccessPopup {
                        TokenController.saveUserToUserDefaults(response: loginResponse, user: self.emailField.text)
                        Switcher.updateRootVC()
                        TokenController.getAndPersistCurrentUser()
                        TokenController.getAndPersistCountries()
                    }
                case .failure(let error):
                    self.loadingIndicator.stopAnimating()
                    PopupHandler.errorPopup(title: "Error", description: (error as! CustomError).localizedDescription);
                }
            })
        }
    }
    
    @IBAction func textFieldDidChange(textField: UITextField) {
        self.emailField.borderInactiveColor = UIColor.white
        self.emailField.borderActiveColor = UIColor.white
        self.passwordField.borderInactiveColor = UIColor.white
        self.passwordField.borderActiveColor = UIColor.white
        
        self.changeFieldValidationColors()
    }
}

