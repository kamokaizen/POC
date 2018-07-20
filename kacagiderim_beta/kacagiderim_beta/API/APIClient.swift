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
//                    let decodedErrorResponse = try decoder.decode(KacagiderimError.self, from: response.data!)
                    completion(Result<T>.failure(response.error!))
                    return
                }
                
                do{
                    let decodedResponse = try decoder.decode(T.self, from: response.data!)
                    completion(Result<T>.success(decodedResponse))
                }
                catch{
                    print("API Unexpected error: \(error).")
                    completion(Result<T>.failure(error))
                }
        }
    }
    
    static func login(email: String, password: String, completion:@escaping (Result<LoginResponse>)->Void) {
        performRequest(route: LoginEndpoint.login(email: email, password: password), completion: completion)
    }
    
    static func createAccount(user: User, completion:@escaping (Result<ServerResponse>)->Void) {
        performRequest(route: UserEndpoint.create(user:user), completion: completion)
    }
    
    static func getAllCountries(completion:@escaping (Result<[Country]>)->Void) {
        performRequest(route: NationEndpoint.countries, completion: completion)
    }
}

