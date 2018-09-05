//
//  FuelEndpoint.swift
//  kacagiderim_beta
//
//  Created by kamilinal on 8/11/18.
//  Copyright © 2018 kacagiderim. All rights reserved.
//

import Alamofire

enum FuelEndpoint: APIConfiguration {
    
    case prices(country:String, city:String)
    case priceswithnames(country:String, cities:String)
    
    // MARK: - HTTPMethod
    var method: HTTPMethod {
        switch self {
        case .prices,.priceswithnames:
            return .post
        }
    }
    
    // MARK: - Path
    var path: String {
        switch self {
        case .prices:
            return "/fuels/api/prices"
        case .priceswithnames:
            return "/fuels/api/priceswithcities"
        }
    }
    
    // MARK: - Parameters
    var parameters: Parameters? {
        switch self {
        case .prices(let country, let city):
            return [K.APIParameterKey.fromCountry: country, K.APIParameterKey.fromCity: city]
        case .priceswithnames(let country, let cities):
            return [K.APIParameterKey.fromCountry: country, K.APIParameterKey.fromCities: cities]
        }
    }
    
    // MARK: - URLRequestConvertible
    func asURLRequest() throws -> URLRequest {
        let url = try K.ProductionServer.baseURL.asURL()
        
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        urlRequest.timeoutInterval = TimeInterval(K.Constants.requestTimeoutInterval)
        
        // HTTP Method
        urlRequest.httpMethod = method.rawValue
        
        urlRequest.setValue(ContentType.urlencoded.rawValue, forHTTPHeaderField: HTTPHeaderField.contentType.rawValue)
        let accessToken = UserDefaults.standard.string(forKey: "accessToken")
        if(accessToken != nil){
            urlRequest.setValue("Bearer " + accessToken!, forHTTPHeaderField: HTTPHeaderField.authentication.rawValue);
        }
        
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
