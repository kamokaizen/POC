//
//  APIRouter.swift
//  kacagiderim_beta
//
//  Created by Comodo on 19.07.2018.
//  Copyright © 2018 kacagiderim. All rights reserved.
//

import Alamofire

enum NationEndpoint: APIConfiguration {
    
    case countries
    case cities(countryId:String)
    
    // MARK: - HTTPMethod
    var method: HTTPMethod {
        switch self {
        case .countries, .cities:
            return .get
        }
    }
    
    // MARK: - Path
    var path: String {
        switch self {
        case .countries:
            return "/nations/api/country/all"
        case .cities(let countryId):
            return "/nations/api/country/cities/id/" + countryId
        }
    }
    
    // MARK: - Parameters
    var parameters: Parameters? {
        switch self {
        case .countries:
            return nil
        case .cities:
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
        
        
        let accessToken = DefaultManager.getAccessToken()
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
