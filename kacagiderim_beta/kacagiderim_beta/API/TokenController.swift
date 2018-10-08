//
//  TokenController.swift
//  kacagiderim_beta
//
//  Created by Comodo on 8.08.2018.
//  Copyright © 2018 kacagiderim. All rights reserved.
//

import Foundation

class TokenController {

    static func saveUserToUserDefaults(response:LoginSuccessResponse, user:String?){
        // after loging success, goto main
        UserDefaults.standard.set(true, forKey: "isLoggedIn")
        UserDefaults.standard.set(user, forKey: "activeUser")
        UserDefaults.standard.set(response.access_token, forKey: "accessToken")
        UserDefaults.standard.set(response.refresh_token, forKey: "refreshToken")
        // Get the Unix timestamp
        let currentTimestamp = (Int)(NSDate().timeIntervalSince1970.rounded())
        // expires in is seconds so, calculate currentTimestamp with expires_in
        let expireTimestamp = currentTimestamp + response.expires_in
        UserDefaults.standard.set(expireTimestamp, forKey: "expireDate")
    }
    
    static func deleteUserFromUserDefaults(){
        UserDefaults.standard.set(false, forKey: "isLoggedIn")
        UserDefaults.standard.set(nil, forKey: "activeUser")
        UserDefaults.standard.set(nil, forKey: "accessToken")
        UserDefaults.standard.set(nil, forKey: "refreshToken")
        UserDefaults.standard.set(nil, forKey: "userProfile")
        UserDefaults.standard.set(nil, forKey: "selectedCities")
        UserDefaults.standard.set(-1, forKey: "expireDate")
    }
    
    static func getAndPersistCurrentUser(){
        if (UserDefaults.standard.value(forKey:"userProfile") as? Data) != nil {
            print("no need to fetch current user")
            return
        }
        else{
            APIClient.getCurrentUser(completion:{ result in
                switch result {
                case .success(let userResponse):
                    UserDefaults.standard.set(try? PropertyListEncoder().encode(userResponse.value), forKey: "userProfile")
                case .failure(let error):
                    print((error as! CustomError).localizedDescription)
                }
            })
        }
    }
    
    static func getAndPersistCountries(){
        if (UserDefaults.standard.value(forKey:"countries") as? Data) != nil {
            print("no need to fetch countries")
            return
        }
        else{
            APIClient.getAllCountries(completion:{ result in
                switch result {
                case .success(let serverResponse):
                    UserDefaults.standard.set(try? PropertyListEncoder().encode(serverResponse.value), forKey: "countries")
                case .failure(let error):
                    print(error.localizedDescription)
                }
            })
        }
    }
    
    static func handleTokenExpire(completion:@escaping (TokenControl) -> ()){
        let activeUser = UserDefaults.standard.string(forKey: "activeUser")
        let refreshToken = UserDefaults.standard.string(forKey: "refreshToken")
        let expireDate = UserDefaults.standard.integer(forKey: "expireDate")
        let currentTimestamp = (Int)(NSDate().timeIntervalSince1970.rounded())
        
        if(refreshToken != nil){
            // existing access token expired, need to refresh token then continue
            if(currentTimestamp >= expireDate){
                APIClient.refreshToken(refreshToken: refreshToken!, completion:{ result in
                    switch result {
                    case .success(let loginResponse):
                        TokenController.saveUserToUserDefaults(response: loginResponse, user: activeUser)
                        completion(TokenControl.success);
                    case .failure(let error):
                        print("API refresh token getting unexpected error: \(error).")
                        (error as! CustomError).isRequestTimeout ? completion(TokenControl.timeout) : completion(TokenControl.connectionProblem)
                    }
                })
            }
            else{
                print("Current token is alive. No need to refresh")
                completion(TokenControl.success);
            }
        }
        else{
            print("API refresh token not exist. Need to re login")
            completion(TokenControl.fail);
        }
    }
}
