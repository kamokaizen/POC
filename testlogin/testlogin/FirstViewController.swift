//
//  FirstViewController.swift
//  testlogin
//
//  Created by Comodo on 13.07.2018.
//  Copyright © 2018 comodo. All rights reserved.
//

import UIKit
import Alamofire

class FirstViewController: UIViewController {

    @IBOutlet weak var resultStackView: UIStackView!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var loginLabel: UILabel!
    @IBOutlet weak var companyLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.resultStackView.isHidden = true
        self.loadingIndicator.isHidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func searchButtonClicked(sender: UIButton) {
        searchGithubUser(username: searchTextField.text!)
    }
    
    func searchGithubUser(username: String) {
        self.loadingIndicator.isHidden = false
        self.loadingIndicator.startAnimating()
        self.clearResponseStack()
        let encodedUsername = username.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
        let stringURL = "https://api.github.com/users/\(encodedUsername)"

        Alamofire.request(URL(string: stringURL)!)
            .validate()
            .response { (response) in
                self.loadingIndicator.isHidden = true
                print("Request: \(String(describing: response.request))")
                print("Response: \(String(describing: response.response))")
                print("Error: \(String(describing: response.error))")
                
                // Try to decode a GithubProfile struct
                do{
                    let profile = try JSONDecoder().decode(GithubProfile.self, from: response.data!)
                    self.setResponseStack(profile: profile)
                    self.downloadProfilePhoto(url: profile.avatarUrl)
                    
                    if(response.error == nil){
                        self.resultStackView.isHidden = false
                    }
                    else{
                        self.resultStackView.isHidden = true
                    }
                }
                catch{
                    print("Unexpected error: \(error).")
                    self.resultStackView.isHidden = true
                }
        }
    }
    
    func downloadProfilePhoto(url: URL?) {
        
        if url == nil{
            return
        }
        
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            guard let data = data else {
                print("Invalid image request data: \(String(describing: error))")
                return
            }
            
            let image = UIImage.init(data: data)
            print(String(describing: image))
            // Display in UI
            DispatchQueue.main.async {
                self.avatarImageView.image = image
            }
            
            }.resume()  // MUST call resume() to start the URL request
    }
    
    func setResponseStack(profile: GithubProfile){
        self.nameLabel.text = profile.name
        self.locationLabel.text = profile.location
        self.loginLabel.text = profile.login
        self.companyLabel.text = profile.company
        self.emailLabel.text = profile.email
        self.typeLabel.text = profile.type
    }
    
    func clearResponseStack(){
        self.nameLabel.text = nil
        self.locationLabel.text = nil
        self.loginLabel.text = nil
        self.companyLabel.text = nil
        self.emailLabel.text = nil
        self.typeLabel.text = nil
        self.avatarImageView.image = nil
    }
}

