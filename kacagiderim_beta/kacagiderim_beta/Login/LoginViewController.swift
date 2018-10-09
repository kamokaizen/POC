//
//  LoginViewController.swift
//  kacagiderim_beta
//
//  Created by kamilinal on 7/14/18.
//  Copyright © 2018 kacagiderim. All rights reserved.
//

import UIKit
import GoogleSignIn
import FacebookCore
import FacebookLogin

class LoginViewController: UIViewController, GIDSignInUIDelegate, GIDSignInDelegate {
    
    @IBOutlet var signInButton: UIButton!
    @IBOutlet var createAccountButton: UIButton!
    @IBOutlet weak var googleSignInButton: UIButton!
    @IBOutlet weak var facebookSignInButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().delegate = self
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
    
    // MARK: - Google Signin Delegates
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!,
              withError error: Error!) {
        if let error = error {
            print("\(error.localizedDescription)")
        } else {
            let idToken = user.authentication.idToken // Safe to send to the server
            let email = user.profile.email
            
            APIClient.createAccountFromGoogle(token:idToken!, completion:{ result in
                switch result {
                case .success(let createResponse):
                    if(createResponse.value != nil){
                        TokenController.saveUserToUserDefaults(response: createResponse.value!, user: email)
                        Switcher.updateRootVC()
                        TokenController.getAndPersistCurrentUser()
                        TokenController.getAndPersistCountries()
                    }
                    else{
                        print("value must be not nil");
                    }
                case .failure(let error):
                    print((error as! CustomError).localizedDescription)
                    //                    self.loadingIndicator.stopAnimating()
                    //                    self.messageHelper.showErrorMessage(text: (error as! CustomError).localizedDescription, view: self.view)
                }
            })
        }
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!,
              withError error: Error!) {
        // Perform any operations when the user disconnects from app here.
    }
    
    // MARK: - Actions
    
    @IBAction func didSignInTapped(sender: UIButton) {
        self.performSegue(withIdentifier: "signinSegue", sender:sender)
    }
    
    @IBAction func didCreateAccountTapped(sender: UIButton) {
       self.performSegue(withIdentifier: "signupSegue", sender:sender)
    }
    
    @IBAction func googleLoginButtonTapped(_ sender: Any) {
        GIDSignIn.sharedInstance().signIn()
    }
    
    @IBAction func facebookLoginButtonTapped() {
        let loginManager = LoginManager()
        loginManager.logIn(readPermissions:[ .publicProfile, .email ], viewController: self, completion: ((LoginResult) -> Void)? { loginResult in
            switch loginResult {
            case .failed(let error):
                print(error)
            case .cancelled:
                print("User cancelled login.")
            case .success(let grantedPermissions, let declinedPermissions, let accessToken):
                let request = GraphRequest.init(graphPath: "me", parameters: ["fields":"first_name, last_name, email, picture.type(large)"], accessToken: AccessToken.current, httpMethod: .GET, apiVersion: FacebookCore.GraphAPIVersion.defaultVersion)
                request.start({ (response, requestResult) in
                    switch requestResult{
                    case .success(let response):
                        if let responseDictionary = response.dictionaryValue {
                            let firstName = responseDictionary["first_name"] as? String
                            let lastName = responseDictionary["last_name"] as? String
                            let email = responseDictionary["email"] as? String
                            let socialId = responseDictionary["id"] as? String
                            let pictureUrl = responseDictionary["picture"] as? [String:Any]
                            let photoData = pictureUrl!["data"] as? [String:Any]
                            let photoUrl = photoData!["url"] as? String
                            let accessToken = AccessToken.current
                            let authenticationToken = accessToken?.authenticationToken
                            let expirationDate = accessToken?.expirationDate
                            let expirationDateMs =  (Int)((expirationDate?.timeIntervalSince1970.rounded())!) * 1000 // multiply with 1000 to convert seconds to ms
                            print(authenticationToken, expirationDate, firstName, lastName, email, socialId, photoUrl)
                            
//                            let resp = LoginSuccessResponse(accessToken: "1231", tokenType: "bearer", refreshToken: "123131", expiresIn: 2344, scope: "mobile")
//                            TokenController.saveUserToUserDefaults(response: resp, user: email)
//                            Switcher.updateRootVC()
                            
                            let user = FacebookUser(userId: socialId, name: firstName, surname: lastName, email: email, imageURL: photoUrl, authenticationToken: authenticationToken, expirationDate: expirationDateMs)
                            
                            APIClient.createAccountFromFacebook(user: user, completion:{ result in
                                switch result {
                                case .success(let createResponse):
                                    if(createResponse.value != nil){
                                        TokenController.saveUserToUserDefaults(response: createResponse.value!, user: email)
                                        Switcher.updateRootVC()
                                        TokenController.getAndPersistCurrentUser()
                                        TokenController.getAndPersistCountries()
                                    }
                                    else{
                                        print("value must be not nil");
                                    }
                                case .failure(let error):
                                    print((error as! CustomError).localizedDescription)
                                    //                    self.loadingIndicator.stopAnimating()
                                    //                    self.messageHelper.showErrorMessage(text: (error as! CustomError).localizedDescription, view: self.view)
                                }
                            })
                        }
                    case .failed(let error):
                        print(error.localizedDescription)
                    }
                })
            }
        })
    }
}
