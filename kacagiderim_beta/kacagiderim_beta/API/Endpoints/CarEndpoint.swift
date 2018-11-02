//
//  File.swift
//  kacagiderim_beta
//
//  Created by kamilinal on 10/27/18.
//  Copyright © 2018 kacagiderim. All rights reserved.
//

import Alamofire
import Foundation

enum CarEndpoint: APIConfiguration {

    case brands()
    case models(brandId:String, pageNumber:Int, pageSize:Int)
    
    var method: HTTPMethod {
        switch self {
        case .brands, .models:
            return .get
        }
    }
    
    var path: String {
        switch self {
            case .brands:
                return "/cars/api/brand/get"
            case .models:
                return "cars/api/model/get"
        }
    }
    
    // MARK: - Parameters
    var parameters: Parameters? {
        switch self {
            case .brands():
                return nil
            case .models(let brandId, let pageNumber, let pageSize):
                return [K.APIParameterKey.brandId: brandId, K.APIParameterKey.pageNumber: pageNumber, K.APIParameterKey.pageSize: pageSize]
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
        let accessToken = DefaultManager.getAccessToken()
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
