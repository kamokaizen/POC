//
//  UserEndpoint.swift
//  kacagiderim_beta
//
//  Created by Comodo on 20.07.2018.
//  Copyright © 2018 kacagiderim. All rights reserved.
//

import Foundation
import Alamofire

enum UserEndpoint: APIConfiguration {
    
    case create(user:User)
    case current()
    
    // MARK: - HTTPMethod
    var method: HTTPMethod {
        switch self {
            case .create:
                return .post
            case .current:
                return .get
        }
    }
    
    // MARK: - Path
    var path: String {
        switch self {
            case .create:
                return "/uaa/users/create"
            case .current:
                return "/uaa/users/current"
        }
    }
    
    // MARK: - Parameters
    var parameters: Parameters? {
        switch self {
            case .create(let user):
                return [K.APIParameterKey.username: user.username, K.APIParameterKey.password: user.password,
                        K.APIParameterKey.name: user.name, K.APIParameterKey.surname: user.surname,
                        K.APIParameterKey.countryId: user.countryId, K.APIParameterKey.homeLatitude: user.homeLatitude!,
                        K.APIParameterKey.homeLongitude: user.homeLongitude, K.APIParameterKey.workLatitude: user.workLatitude!,
                        K.APIParameterKey.workLongitude: user.workLongitude!, K.APIParameterKey.currencyMetric: user.currencyMetric.rawValue,
                        K.APIParameterKey.distanceMetric: user.distanceMetric.rawValue, K.APIParameterKey.volumeMetric: user.volumeMetric.rawValue,
                        K.APIParameterKey.userType: user.userType.rawValue, K.APIParameterKey.socialSecurityNumber: user.socialSecurityNumber!]
            case .current():
                return nil
        }
    }
    
    // MARK: - URLRequestConvertible
    func asURLRequest() throws -> URLRequest {
        let url = try K.ProductionServer.baseURL.asURL()
        
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        
        // HTTP Method
        urlRequest.httpMethod = method.rawValue
        
        // Common Headers
        urlRequest.setValue(ContentType.json.rawValue, forHTTPHeaderField: HTTPHeaderField.acceptType.rawValue)
        urlRequest.setValue(ContentType.json.rawValue, forHTTPHeaderField: HTTPHeaderField.contentType.rawValue)
        let accessToken = UserDefaults.standard.string(forKey: "accessToken")
        if(accessToken != nil){
            urlRequest.setValue("Bearer " + accessToken!, forHTTPHeaderField: HTTPHeaderField.authentication.rawValue);
        }
        
        // Parameters
        if let parameters = parameters {
            do {
                urlRequest.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
            } catch {
                throw AFError.parameterEncodingFailed(reason: .jsonEncodingFailed(error: error))
            }
        }
        
        return urlRequest
    }
}
