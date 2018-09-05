//
//  APIClient.swift
//  kacagiderim_beta
//
//  Created by Comodo on 19.07.2018.
//  Copyright © 2018 kacagiderim. All rights reserved.
//

import Alamofire

class APIClient {
        
    private static func checkTokenExpired<T:Decodable>(route:APIConfiguration, completion:@escaping (Result<T>)->Void){
        TokenController.handleTokenExpire(completion: { value in
            // equal to 1 is all is well, equal to -1 means something went wrong
            switch value {
            case .success:
                performRequest(route: route, completion: completion)
            case .timeout, .connectionProblem:
                // nothing can do
                print("there is a connection problem between your device and server")
            case .fail:
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
                
                let timeout = response.error?._code == NSURLErrorTimedOut ? true : false
                let statusCode = response.response?.statusCode
                
                if(response.error != nil){                    
                    do{
                        var customError = CustomError(error:response.error!, reason: (response.error?.localizedDescription)!, timeout:timeout, statusCode:statusCode!)
                        
                        switch(route){
                        case LoginEndpoint.login:
                            customError = CustomError(error: response.error!, reason: try decoder.decode(LoginFailResponse.self, from: response.data!).error_description, timeout:timeout,statusCode:statusCode!)
                        case UserEndpoint.create:
                            customError = CustomError(error: response.error!, reason: try decoder.decode(ServerResponse<User>.self, from: response.data!).reason, timeout:timeout,statusCode:statusCode!)
                        default:
                            customError = CustomError(error:response.error!, reason: (response.error?.localizedDescription)!, timeout:timeout,statusCode:statusCode!)
                        }
                        
                        completion(Result<T>.failure(customError))
                        return
                    }
                    catch{
                        print("API Unexpected Parse error: \(error).")
                        completion(Result<T>.failure(CustomError(error: error, reason: (response.error?.localizedDescription)!, timeout:timeout,statusCode:statusCode!)))
                        return
                    }
                }
                
                do{
                    let decodedResponse = try decoder.decode(T.self, from: response.data!)
                    completion(Result<T>.success(decodedResponse))
                    return
                }
                catch{
                    print("API Unexpected Parse error: \(error).")
                    completion(Result<T>.failure(CustomError(error: error, reason: (response.error?.localizedDescription)!, timeout:timeout, statusCode:statusCode!)))
                    return
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
    
    static func updateAccount(user: User, completion:@escaping (Result<ServerResponse<User>>)->Void) {
        checkTokenExpired(route: UserEndpoint.update(user:user), completion: completion)
    }
    
    static func getCurrentUser(completion:@escaping (Result<ServerResponse<User>>)->Void){
        checkTokenExpired(route: UserEndpoint.current(), completion: completion)
    }

    static func getAllCountries(completion:@escaping (Result<ServerResponse<Countries>>)->Void) {
        // this method do not need access_token
        performRequest(route: NationEndpoint.countries, completion: completion)
    }
    
    static func getCitiesOfCountry(countryId: String, completion:@escaping (Result<ServerResponse<Cities>>)->Void) {
        checkTokenExpired(route: NationEndpoint.cities(countryId: countryId), completion: completion)
    }
    
    static func refreshToken(refreshToken:String, completion:@escaping (Result<LoginSuccessResponse>)->Void){
        // this method do not need access_token
        performRequest(route: LoginEndpoint.refreshToken(refreshToken: refreshToken), completion: completion)
    }
    
    static func getFuelPrices(country: String, city: String, completion:@escaping (Result<ServerResponse<FuelPrice>>)->Void){
        checkTokenExpired(route: FuelEndpoint.prices(country: country, city: city), completion: completion)
    }
    
    static func getFuelPricesWithNames(country: String, cities: String, completion:@escaping (Result<ServerResponse<FuelPrices>>)->Void){
        checkTokenExpired(route: FuelEndpoint.priceswithnames(country: country, cities: cities), completion: completion)
    }
}

