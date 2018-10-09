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
    case createGoogleUser(token:String)
    case createFacebookUser(user:FacebookUser)
    case current()
    case update(user:User)
    case changePassword(current:String, new:String, confirmed:String)
    
    // MARK: - HTTPMethod
    var method: HTTPMethod {
        switch self {
            case .create, .createGoogleUser, .createFacebookUser, .update, .changePassword:
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
            case .createGoogleUser:
                return "/uaa/users/create/google"
            case .createFacebookUser:
                return "uaa/users/create/facebook"
            case .current:
                return "/uaa/users/profile"
            case .update:
                return "/uaa/users/update"
            case .changePassword:
                return "/uaa/users/changepassword"
        }
    }
    
    // MARK: - Parameters
    var parameters: Parameters? {
        switch self {
            case .create(let user):
                return [K.APIParameterKey.username: user.username,
                        K.APIParameterKey.password: user.password as Any,
                        K.APIParameterKey.name: user.name as Any,
                        K.APIParameterKey.surname: user.surname as Any,
                        K.APIParameterKey.countryId: user.countryId,
                        K.APIParameterKey.homeLatitude: user.homeLatitude as Any,
                        K.APIParameterKey.homeLongitude: user.homeLongitude as Any,
                        K.APIParameterKey.workLatitude: user.workLatitude!,
                        K.APIParameterKey.workLongitude: user.workLongitude as Any,
                        K.APIParameterKey.currencyMetric: user.currencyMetric.rawValue,
                        K.APIParameterKey.distanceMetric: user.distanceMetric.rawValue,
                        K.APIParameterKey.volumeMetric: user.volumeMetric.rawValue,
                        K.APIParameterKey.userType: user.userType.rawValue,
                        K.APIParameterKey.socialSecurityNumber: user.socialSecurityNumber as Any,
                        K.APIParameterKey.loginType: user.loginType.rawValue,
                        K.APIParameterKey.imageURL: user.imageURL as Any]
            case .createGoogleUser(let token):
                return [K.APIParameterKey.token: token]
            case .createFacebookUser(let user):
                return [K.APIParameterKey.userId: user.userId as Any,
                        K.APIParameterKey.name: user.name as Any,
                        K.APIParameterKey.surname: user.surname as Any,
                        K.APIParameterKey.token: user.authenticationToken as Any,
                        K.APIParameterKey.expirationDate: user.expirationDate,
                        K.APIParameterKey.imageURL: user.imageURL as Any]
            case .update(let user):
                return [K.APIParameterKey.username: user.username,
                        K.APIParameterKey.name: user.name as Any,
                        K.APIParameterKey.surname: user.surname as Any,
                        K.APIParameterKey.countryId: user.countryId,
                        K.APIParameterKey.homeLatitude: user.homeLatitude as Any,
                        K.APIParameterKey.homeLongitude: user.homeLongitude as Any,
                        K.APIParameterKey.workLatitude: user.workLatitude!,
                        K.APIParameterKey.workLongitude: user.workLongitude as Any,
                        K.APIParameterKey.currencyMetric: user.currencyMetric.rawValue,
                        K.APIParameterKey.distanceMetric: user.distanceMetric.rawValue,
                        K.APIParameterKey.volumeMetric: user.volumeMetric.rawValue,
                        K.APIParameterKey.userType: user.userType.rawValue,
                        K.APIParameterKey.socialSecurityNumber: user.socialSecurityNumber as Any,
                        K.APIParameterKey.loginType: user.loginType.rawValue,
                        K.APIParameterKey.imageURL: user.imageURL as Any]
            case .changePassword(let current, let new, let confirmed):
                return [K.APIParameterKey.currentPassword: current,
                        K.APIParameterKey.newPassword: new,
                        K.APIParameterKey.confirmedPassword:confirmed]
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
