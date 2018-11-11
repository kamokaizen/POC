//
//  AccountEndpoint.swift
//  kacagiderim_beta
//
//  Created by kamilinal on 10/27/18.
//  Copyright © 2018 kacagiderim. All rights reserved.
//

import Foundation
import Alamofire

enum AccountEndpoint: APIConfiguration {
 
    case createVehicle(accountVehicle: AccountVehicle)
    case getVehicles(userId: String)
    
    var method: HTTPMethod {
        switch self {
        case .getVehicles:
            return .get
        case .createVehicle:
            return .post
        }
    }
    
    var path: String {
        switch self {
        case .createVehicle:
            return "/accounts/api/vehicle/create"
        case .getVehicles(let userId):
            return "/accounts/api/vehicle/" + userId
        }
    }
    
    var parameters: Parameters? {
        switch self {
        case .createVehicle(let accountVehicle):
            return [K.APIParameterKey.userId: accountVehicle.userId!,
                    K.APIParameterKey.vehicleDetailId: accountVehicle.vehicleDetailId as Any,
                    K.APIParameterKey.customVehicle: accountVehicle.customVehicle,
                    K.APIParameterKey.vehiclePlate: accountVehicle.vehiclePlate as Any,
                    K.APIParameterKey.customConsumption: accountVehicle.customConsumption,
                    K.APIParameterKey.averageCustomConsumptionLocal: accountVehicle.averageCustomConsumptionLocal,
                    K.APIParameterKey.averageCustomConsumptionOut: accountVehicle.averageCustomConsumptionOut,
                    K.APIParameterKey.customVehicleName: accountVehicle.customVehicleName as Any]
        case .getVehicles:
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
        let accessToken = DefaultManager.getAccessToken()
        if(accessToken != nil){
            urlRequest.setValue("Bearer " + accessToken!, forHTTPHeaderField: HTTPHeaderField.authentication.rawValue);
        }
        
        // Parameters
        if let parameters = parameters {
            do {
                urlRequest.setValue(ContentType.json.rawValue, forHTTPHeaderField: HTTPHeaderField.acceptType.rawValue)
                urlRequest.setValue(ContentType.json.rawValue, forHTTPHeaderField: HTTPHeaderField.contentType.rawValue)
                urlRequest.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
            } catch {
                throw AFError.parameterEncodingFailed(reason: .jsonEncodingFailed(error: error))
            }
        }
        
        return urlRequest
    }
}
