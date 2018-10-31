//
//  PasswordViewController.swift
//  kacagiderim_beta
//
//  Created by Comodo on 6.09.2018.
//  Copyright © 2018 kacagiderim. All rights reserved.
//

import Foundation
import UIKit
import TextFieldEffects
import EGFormValidator
import NVActivityIndicatorView
import DCKit

class PasswordViewController : ValidatorViewController, UITextFieldDelegate {
 
    @IBOutlet var passwordField: HoshiTextField!
    @IBOutlet var newPasswordField: HoshiTextField!
    @IBOutlet var confirmPasswordField: HoshiTextField!
    @IBOutlet var changePasswordButton: DCBorderedButton!
    @IBOutlet var loadingIndicator: NVActivityIndicatorView!
    
    /// Error labels
    @IBOutlet weak var passwordErrorLabel: UILabel!
    @IBOutlet weak var newPasswordErrorLabel: UILabel!
    @IBOutlet weak var confirmPasswordErrorLabel: UILabel!
    
    var messageHelper = MessageHelper()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Empty error labels (they have some text in the storyboard)
        self.passwordErrorLabel.text = ""
        self.newPasswordErrorLabel.text = ""
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
        self.addValidatorMandatory(toControl: self.passwordField,
                                   errorPlaceholder: self.passwordErrorLabel,
                                   errorMessage: "This field is required")
        
        // Minlength
        self.addValidatorMinLength(toControl: self.passwordField,
                                   errorPlaceholder: self.passwordErrorLabel,
                                   errorMessage: "Password must be minimum %d characters",
                                   minLength: 8)
        
        self.addValidatorMandatory(toControl: self.newPasswordField,
                                   errorPlaceholder: self.newPasswordErrorLabel,
                                   errorMessage: "This field is required")
        
        // Minlength
        self.addValidatorMinLength(toControl: self.newPasswordField,
                                   errorPlaceholder: self.newPasswordErrorLabel,
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
        self.addValidatorEqualTo(toControl: self.newPasswordField,
                                 errorPlaceholder: self.confirmPasswordErrorLabel,
                                 errorMessage: "The Passwords don't match",
                                 compareWithControl: self.confirmPasswordField)
    }
    
    func changeFieldValidationColors(){
        if !self.validate(){
            if(self.newPasswordErrorLabel.text != nil){
                self.newPasswordField.borderInactiveColor = UIColor.red
                self.newPasswordField.borderActiveColor = UIColor.red
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
    
    @IBAction func didChangePasswordButtonTapped(sender: UIButton) {
        self.changeFieldValidationColors()
        if !self.validate(){ return }
        
        self.loadingIndicator.startAnimating()
        
        APIClient.changePassword(current: self.passwordField.text!, new: self.newPasswordField.text!, confirmed: self.confirmPasswordField.text!, completion: { result in
            switch result {
            case .success(let changeResponse):
                self.loadingIndicator.stopAnimating()
                PopupHandler.successPopup(title: "Success", description: changeResponse.reason)
                Utils.delayWithSeconds(5, completion: {
                    self.dismiss(animated: true, completion: nil)
                })
            case .failure(let error):
                print((error as! CustomError).localizedDescription)
                self.loadingIndicator.stopAnimating()
                PopupHandler.errorPopup(title: "Error", description: "Something went wrong. Please try again later")
            }
        })
    }
    
    @IBAction func textFieldDidChange(textField: UITextField) {
        self.newPasswordField.borderInactiveColor = UIColor.white
        self.newPasswordField.borderActiveColor = UIColor.white
        self.passwordField.borderInactiveColor = UIColor.white
        self.passwordField.borderActiveColor = UIColor.white
        self.confirmPasswordField.borderInactiveColor = UIColor.white
        self.confirmPasswordField.borderActiveColor = UIColor.white
        
        self.changeFieldValidationColors()
    }
    
}
