//
//  APIClient.swift
//  kacagiderim_beta
//
//  Created by Comodo on 19.07.2018.
//  Copyright © 2018 kacagiderim. All rights reserved.
//

import Alamofire

class APIClient {
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
        performRequest(route: LoginEndpoint.login(email: email, password: password), completion: completion)
    }
    
    static func createAccount(user: User, completion:@escaping (Result<ServerResponse<User>>)->Void) {
        performRequest(route: UserEndpoint.create(user:user), completion: completion)
    }
    
    static func getAllCountries(completion:@escaping (Result<ServerResponse<Countries>>)->Void) {
        performRequest(route: NationEndpoint.countries, completion: completion)
    }
}

