//
//  TokenController.swift
//  kacagiderim_beta
//
//  Created by Comodo on 8.08.2018.
//  Copyright © 2018 kacagiderim. All rights reserved.
//

import Foundation

class TokenController {

    static func saveUserToUserDefaults(response:LoginSuccessResponse, user:String){
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
        UserDefaults.standard.set(-1, forKey: "expireDate")
    }
    
    static func handleTokenExpire(completion:@escaping (Int) -> ()){
        let activeUser = UserDefaults.standard.string(forKey: "activeUser")
        let refreshToken = UserDefaults.standard.string(forKey: "refreshToken")
        let expireDate = UserDefaults.standard.integer(forKey: "expireDate")
        let currentTimestamp = (Int)(NSDate().timeIntervalSince1970.rounded())
        
        if(refreshToken != nil){
            // existing access token expired, need to refresh token then continue
            if(currentTimestamp > expireDate){
                APIClient.refreshToken(refreshToken: refreshToken!, completion:{ result in
                    switch result {
                    case .success(let loginResponse):
                        TokenController.saveUserToUserDefaults(response: loginResponse, user: activeUser!)
                        completion(1);
                    case .failure(let error):
                        print("API refresh token getting unexpected error: \(error).")
                        completion(-1);
                    }
                })
            }
            else{
                print("Current token is alive. No need to refresh")
                completion(1);
            }
        }
        else{
            print("API refresh token not exist. Need to re login")
            completion(-1);
        }
    }
}
