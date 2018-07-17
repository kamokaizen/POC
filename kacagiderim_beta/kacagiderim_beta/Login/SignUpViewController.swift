//
//  SignupViewController.swift
//  kacagiderim_beta
//
//  Created by Comodo on 16.07.2018.
//  Copyright © 2018 kacagiderim. All rights reserved.
//

import UIKit
import TextFieldEffects
import EGFormValidator

class SignUpViewController : ValidatorViewController, UITextFieldDelegate {
    
    @IBOutlet var emailField: HoshiTextField!
    @IBOutlet var passwordField: HoshiTextField!
    @IBOutlet var confirmPasswordField: HoshiTextField!
    @IBOutlet var createAccountButton: UIButton!
    
    /// Error labels
    @IBOutlet weak var emailErrorLabel: UILabel!
    @IBOutlet weak var passwordErrorLabel: UILabel!
    @IBOutlet weak var confirmPasswordErrorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Empty error labels (they have some text in the storyboard)
        self.emailErrorLabel.text = ""
        self.passwordErrorLabel.text = ""
        self.confirmPasswordErrorLabel.text = ""
        
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
        
        // Mandatory validator
        self.addValidatorMandatory(toControl: self.confirmPasswordField,
                                   errorPlaceholder: self.confirmPasswordErrorLabel,
                                   errorMessage: "This field is required")
        
        // Minlength
        self.addValidatorMinLength(toControl: self.confirmPasswordField,
                                   errorPlaceholder: self.confirmPasswordErrorLabel,
                                   errorMessage: "Password must be minimum %d characters",
                                   minLength: 8)
        
        // Equalty validator
        self.addValidatorEqualTo(toControl: self.passwordField,
                                 errorPlaceholder: self.confirmPasswordErrorLabel,
                                 errorMessage: "The Passwords don't match",
                                 compareWithControl: self.confirmPasswordField)
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
            if(self.confirmPasswordErrorLabel.text != nil){
                self.confirmPasswordField.borderInactiveColor = UIColor.red
                self.confirmPasswordField.borderActiveColor = UIColor.red
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // MARK: - Actions
    
    @IBAction func didCloseTapped(sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func didCreateAccountButtonTapped(sender: UIButton) {
        self.changeFieldValidationColors()
        if !self.validate(){ return }
        
        // call create account
//        API.shared.reportList(for: device ?? currentDevice, failure: { [unowned self] (error) in
//            self.didFailureUpdateData?(error)
//            }, success: { [unowned self] dashboard, device in
//                self.dashboardServices = dashboard
//                self.deviceServices = device
//                self.reloadAllStatistics()
//        })
    }
    
    @IBAction func textFieldDidChange(textField: UITextField) {
        self.emailField.borderInactiveColor = UIColor.white
        self.emailField.borderActiveColor = UIColor.white
        self.passwordField.borderInactiveColor = UIColor.white
        self.passwordField.borderActiveColor = UIColor.white
        self.confirmPasswordField.borderInactiveColor = UIColor.white
        self.confirmPasswordField.borderActiveColor = UIColor.white
        
        self.changeFieldValidationColors()
    }
    
}
