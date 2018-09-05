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
    case update(user:User)
    
    // MARK: - HTTPMethod
    var method: HTTPMethod {
        switch self {
            case .create, .update:
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
                return "/uaa/users/profile"
            case .update:
                return "/uaa/users/update"
        }
    }
    
    // MARK: - Parameters
    var parameters: Parameters? {
        switch self {
            case .create(let user):
                return [K.APIParameterKey.username: user.username,
                        K.APIParameterKey.password: user.password as Any,
                        K.APIParameterKey.name: user.name,
                        K.APIParameterKey.surname: user.surname,
                        K.APIParameterKey.countryId: user.countryId,
                        K.APIParameterKey.homeLatitude: user.homeLatitude as Any,
                        K.APIParameterKey.homeLongitude: user.homeLongitude as Any,
                        K.APIParameterKey.workLatitude: user.workLatitude!,
                        K.APIParameterKey.workLongitude: user.workLongitude as Any,
                        K.APIParameterKey.currencyMetric: user.currencyMetric.rawValue,
                        K.APIParameterKey.distanceMetric: user.distanceMetric.rawValue,
                        K.APIParameterKey.volumeMetric: user.volumeMetric.rawValue,
                        K.APIParameterKey.userType: user.userType.rawValue,
                        K.APIParameterKey.socialSecurityNumber: user.socialSecurityNumber as Any]
        case .update(let user):
            return [K.APIParameterKey.username: user.username,
                    K.APIParameterKey.name: user.name,
                    K.APIParameterKey.surname: user.surname,
                    K.APIParameterKey.countryId: user.countryId,
                    K.APIParameterKey.homeLatitude: user.homeLatitude as Any,
                    K.APIParameterKey.homeLongitude: user.homeLongitude as Any,
                    K.APIParameterKey.workLatitude: user.workLatitude!,
                    K.APIParameterKey.workLongitude: user.workLongitude as Any,
                    K.APIParameterKey.currencyMetric: user.currencyMetric.rawValue,
                    K.APIParameterKey.distanceMetric: user.distanceMetric.rawValue,
                    K.APIParameterKey.volumeMetric: user.volumeMetric.rawValue,
                    K.APIParameterKey.userType: user.userType.rawValue,
                    K.APIParameterKey.socialSecurityNumber: user.socialSecurityNumber as Any]
        case .current():
            return nil
        }
    }
    
    // MARK: - URLRequestConvertible
    func asURLRequest() throws -> URLRequest {
        let url = try K.ProductionServer.baseURL.asURL()
        
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        urlRequest.timeoutInterval = TimeInterval(K.Constants.requestTimeoutInterval)
        
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
