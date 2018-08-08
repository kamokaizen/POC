//
//  LoginEndpoint.swift
//  kacagiderim_beta
//
//  Created by Comodo on 19.07.2018.
//  Copyright © 2018 kacagiderim. All rights reserved.
//

import Alamofire

enum LoginEndpoint: APIConfiguration {
    
    case login(email:String, password:String)
    case refreshToken(refreshToken:String)
    
    // MARK: - HTTPMethod
    var method: HTTPMethod {
        switch self {
        case .login, .refreshToken:
            return .post
        }
    }
    
    // MARK: - Path
    var path: String {
        switch self {
            case .login, .refreshToken:
                return "/uaa/oauth/token"
        }
    }
    
    // MARK: - Parameters
    var parameters: Parameters? {
        switch self {
        case .login(let email, let password):
            return [K.APIParameterKey.username: email, K.APIParameterKey.password: password, K.APIParameterKey.scope: "mobile", K.APIParameterKey.grantType:"password"]
        case .refreshToken(let refreshToken):
            return [K.APIParameterKey.refreshToken: refreshToken, K.APIParameterKey.grantType:"refresh_token"]
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
        urlRequest.setValue(K.Constants.loginAuthorizationValue, forHTTPHeaderField: HTTPHeaderField.authentication.rawValue)
        urlRequest.setValue(ContentType.urlencoded.rawValue, forHTTPHeaderField: HTTPHeaderField.contentType.rawValue)
        
        // Parameters
        if let parameters = parameters {
            do {
                return try URLEncoding.default.encode(urlRequest, with: parameters)
            } catch {
                throw AFError.parameterEncodingFailed(reason: .jsonEncodingFailed(error: error))
            }
        }
        
        return urlRequest
    }
}