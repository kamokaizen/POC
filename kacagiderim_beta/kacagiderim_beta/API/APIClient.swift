//
//  APIClient.swift
//  kacagiderim_beta
//
//  Created by Comodo on 19.07.2018.
//  Copyright © 2018 kacagiderim. All rights reserved.
//

import Alamofire

class APIClient {
    
    private static func expireTokenCheck<T:Decodable>(route:APIConfiguration, completion:@escaping (Result<T>)->Void){
        TokenController.handleTokenExpire(completion: { value in
            // -1 means something went wrong
            if(value != -1){
                performRequest(route: route, completion: completion)
            }
            else{
                // means that can not refresh token and so delete user from user defaults then go to login page
                TokenController.deleteUserFromUserDefaults()
                Switcher.updateRootVC()
            }
        })
    }
    
    @discardableResult
    private static func performRequest<T:Decodable>(route:APIConfiguration, decoder: JSONDecoder = JSONDecoder(), completion:@escaping (Result<T>)->Void) -> DataRequest {
        
        return Alamofire.request(route)
            .validate()
            .response { (response) in
                print("Request: \(String(describing: response.request))")
                print("Response: \(String(describing: response.response))")
                if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                    print("Data: \(utf8Text)")
                }
                print("Error: \(String(describing: response.error))")
                
                if(response.error != nil){
                    // request is not login and response is 401
                    if(response.response?.statusCode == 401){
                        // try to refresh token
                        let refreshToken = UserDefaults.standard.string(forKey: "refreshToken")
                        if(refreshToken != nil){
                            APIClient.refreshToken(refreshToken: refreshToken!, completion:{ result in
                                switch result {
                                case .success(let loginResponse):
                                    UserDefaults.standard.set(loginResponse.access_token, forKey: "accessToken")
                                    UserDefaults.standard.set(loginResponse.refresh_token, forKey: "refreshToken")
                                case .failure(let error):
                                    print("API refresh token getting unexpected error: \(error).")
                                }
                            })
                        }
                    }
                    
                    do{
                        var customError = CustomError(error:response.error!, reason: (response.error?.localizedDescription)!)
                        
                        switch(route){
                        case LoginEndpoint.login:
                            customError = CustomError(error: response.error!, reason: try decoder.decode(LoginFailResponse.self, from: response.data!).error_description)
                        case UserEndpoint.create:
                            customError = CustomError(error: response.error!, reason: try decoder.decode(ServerResponse<User>.self, from: response.data!).reason)
                        default:
                            customError = CustomError(error:response.error!, reason: (response.error?.localizedDescription)!)
                        }
                        
                        completion(Result<T>.failure(customError))
                        return
                    }
                    catch{
                        print("API Unexpected Parse error: \(error).")
                        completion(Result<T>.failure(CustomError(error: error, reason: (response.error?.localizedDescription)!)))
                    }
                }
                
                do{
                    let decodedResponse = try decoder.decode(T.self, from: response.data!)
                    completion(Result<T>.success(decodedResponse))
                }
                catch{
                    print("API Unexpected Parse error: \(error).")
                    completion(Result<T>.failure(CustomError(error: error, reason: (response.error?.localizedDescription)!)))
                }
        }
    }
    
    static func login(email: String, password: String, completion:@escaping (Result<LoginSuccessResponse>)->Void) {
        // this method do not need access_token
        performRequest(route: LoginEndpoint.login(email: email, password: password), completion: completion)
    }
    
    static func createAccount(user: User, completion:@escaping (Result<ServerResponse<User>>)->Void) {
        // this method do not need access_token
        performRequest(route: UserEndpoint.create(user:user), completion: completion)
    }
    
    static func getCurrentUser(completion:@escaping (Result<CurrentUser>)->Void){
        expireTokenCheck(route: UserEndpoint.current(), completion: completion)
    }

    static func getAllCountries(completion:@escaping (Result<ServerResponse<Countries>>)->Void) {
        // this method do not need access_token
        performRequest(route: NationEndpoint.countries, completion: completion)
    }
    
    static func refreshToken(refreshToken:String, completion:@escaping (Result<LoginSuccessResponse>)->Void){
        // this method do not need access_token
        performRequest(route: LoginEndpoint.refreshToken(refreshToken: refreshToken), completion: completion)
    }
}

