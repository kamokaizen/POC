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
        DefaultManager.setIsLoggedIn(isLoggedIn: true)
        DefaultManager.setActiveUsername(username: user ?? "")
        DefaultManager.setAccessToken(accessToken: response.access_token)
        DefaultManager.setRefreshToken(refreshToken: response.refresh_token)
        
        // Get the Unix timestamp
        let currentTimestamp = (Int)(NSDate().timeIntervalSince1970.rounded())
        // expires in is seconds so, calculate currentTimestamp with expires_in
        let expireTimestamp = currentTimestamp + response.expires_in
        DefaultManager.setExpireDate(expireDate: expireTimestamp)
    }
    
    static func deleteUserFromUserDefaults(){
        DefaultManager.clear()
    }
    
    static func getAndPersistCurrentUser(){
        let user = DefaultManager.getUser()
        
        if user != nil {
            print("User exist, no need to fetch current user from server")
            return
        }
        
        APIClient.getCurrentUser(completion:{ result in
            switch result {
            case .success(let userResponse):
                DefaultManager.setUser(user: userResponse.value!)
                print("User saved to defaults")
            case .failure(let error):
                print((error as! CustomError).localizedDescription)
            }
        })
    }
    
    static func getAndPersistCountries(){
        let countries = DefaultManager.getCountries()
        
        if(countries.countries!.count > 0){
            print("no need to fetch countries")
            return
        }
        
        APIClient.getAllCountries(completion:{ result in
            switch result {
            case .success(let serverResponse):
                DefaultManager.setCountries(countries: serverResponse.value!)
            case .failure(let error):
                print((error as! CustomError).localizedDescription)
            }
        })
    }
    
    static func handleTokenExpire(completion:@escaping (TokenControl) -> ()){
        let activeUser = DefaultManager.getActiveUsername()
        let refreshToken = DefaultManager.getRefreshToken()
        let expireDate = DefaultManager.getExpireDate()
        let currentTimestamp = (Int)(NSDate().timeIntervalSince1970.rounded())
        
        if(refreshToken != nil){
            // existing access token expired, need to refresh token then continue
            if(currentTimestamp >= expireDate!){
                APIClient.refreshToken(refreshToken: refreshToken!, completion:{ result in
                    switch result {
                    case .success(let loginResponse):
                        TokenController.saveUserToUserDefaults(response: loginResponse, user: activeUser)
                        completion(TokenControl.success);
                    case .failure(let error):
                        print("API refresh token getting unexpected error: \(error).")
                        
                        if((error as! CustomError).statusCode == 400 || (error as! CustomError).statusCode == 401){
                            print("API refresh token invalid. Need to re login")
                            completion(TokenControl.fail);
                        }
                        else{
                            (error as! CustomError).isRequestTimeout ? completion(TokenControl.timeout) : completion(TokenControl.connectionProblem)
                        }
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
