//
//  API.swift
//  kacagiderim_beta
//
//  Created by Comodo on 17.07.2018.
//  Copyright © 2018 kacagiderim. All rights reserved.
//

import UIKit

import AlamofireObjectMapper
import Alamofire
import ObjectMapper
import AlamofireActivityLogger
import KeychainSwift

class API: BaseAPI {
    static let shared: API = {
        let instance = API()
        return instance
    }()
    
    private func authValue() -> String {
        return isDev ? "Y29mZmljZW1vYmlsZWFwcDpjb2ZmaWNlX3A0Q0JDTDJEN2VURmNTS3Rfc3RhZ2U=" :
        "Y29mZmljZW1vYmlsZWFwcDpjb2ZmaWNlX2E0VEJTTDJEN2ZURmNTS2d3ZWdmYWd0"
    }
    
    override func authHeader() -> HTTPHeaders? {
        return [APIConstants.authHeaderKey: "\(APIConstants.authHeaderKeyValue) \(authValue())"]
    }
    
    var isLogged: Bool {
        return KeychainSwift().get(.deviceId) != nil
    }
    
    // MARK: - create user
    
    func createUser(user: User, failure: ((Error) -> Void)? = nil, success: @escaping (_ response: User) -> Void) {
        guard let username = user.username else {
            failure?(RestApiError.emptyDeviceId)
            return
        }
        
        guard let password = user.password else {
            failure?(RestApiError.emptyDeviceId)
            return
        }
        
        session.request(URLs.createUser,
                     method: .post,
                     parameters: [APIKey.username.rawValue: username,
                                  APIKey.password.rawValue: password],
                     encoding: JSONEncoding.default,
                     headers: authHeader())
            .log()
            .responseObject { [unowned self] (response: DataResponse<ServerResponse<User>>) in
                self.process(response, with: failure) { user in
                    success(user)
                }
            }
    }
    
    // MARK: - get All Countries
    
    func getAllCountries(failure: ((Error) -> Void)? = nil, success: @escaping ([Country]?) -> Void) {
        session
            .request(URLs.getAllCountries,
                     method: .get,
                     encoding: URLEncoding.default,
                     headers: authHeader())
            .log()
            .responseObject { [unowned self] (response: DataResponse<ServerResponse<Countries>>) in
                self.process(response, with: failure) { countries in
                     success(countries.countries ?? [])
                }
        }
    }
    
    private func randomDelay() -> TimeInterval {
        return Double(arc4random_uniform(200)) / 100.0
    }
}
