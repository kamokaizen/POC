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
import NVActivityIndicatorView

class SignUpViewController : ValidatorViewController, UITextFieldDelegate {
    
    @IBOutlet var emailField: HoshiTextField!
    @IBOutlet var passwordField: HoshiTextField!
    @IBOutlet var confirmPasswordField: HoshiTextField!
    @IBOutlet var createAccountButton: UIButton!
    @IBOutlet var loadingIndicator: NVActivityIndicatorView!
    
    /// Error labels
    @IBOutlet weak var emailErrorLabel: UILabel!
    @IBOutlet weak var passwordErrorLabel: UILabel!
    @IBOutlet weak var confirmPasswordErrorLabel: UILabel!
    
    var messageHelper = MessageHelper()
    var countries:[Country]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Empty error labels (they have some text in the storyboard)
        self.emailErrorLabel.text = ""
        self.passwordErrorLabel.text = ""
        self.confirmPasswordErrorLabel.text = ""
        
        // get Countries
        APIClient.getAllCountries(completion:{ result in
            switch result {
            case .success(let serverResponse):
                self.countries = serverResponse.value?.countries
                UserDefaults.standard.set(try? PropertyListEncoder().encode(serverResponse.value), forKey: "countries")
            case .failure(let error):
                print(error.localizedDescription)
            }
        })
        
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
        
        self.loadingIndicator.startAnimating()
        var defaultCountryId: String = ""
        
        if(countries != nil){
            for country in self.countries! {
                if(country.countryCode == "tr"){
                    defaultCountryId = country.countryId!
                    break
                }
            }
        }
        
        let user = User(username: emailField.text!, password: passwordField.text!, name: emailField.text!, surname: emailField.text!, countryId: defaultCountryId, currencyMetric: CurrencyMetrics.TRY, distanceMetric: DistanceMetrics.M, volumeMetric: VolumeMetrics.LITER, userType: UserType.INDIVIDUAL, loginType: LoginType.DEFAULT, imageURL: nil)
        
        APIClient.createAccount(user:user, completion:{ result in
            switch result {
            case .success(let createResponse):
                self.loadingIndicator.stopAnimating()
                self.messageHelper.showInfoMessage(text: "New Account Created", view: self.view)
                Utils.delayWithSeconds(5, completion: {
                    self.dismiss(animated: true, completion: nil)
                })
            case .failure(let error):
                self.loadingIndicator.stopAnimating()
                self.messageHelper.showErrorMessage(text: (error as! CustomError).localizedDescription, view: self.view)
            }
        })
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
