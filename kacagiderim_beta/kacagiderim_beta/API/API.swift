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
    
    // MARK: - Reports
    
//    func reportList(for device: Device, failure: ((Error) -> Void)? = nil, success: @escaping (_ dashboard: [Service], _ device: [Service]) -> Void) {
//        guard let deviceIdentifier = device.identifier else {
//            failure?(RestApiError.emptyDeviceId)
//            return
//        }
//        
//        session
//            .request(URLs.reportList,
//                     method: .post,
//                     parameters: [APIKey.deviceId.rawValue: deviceIdentifier],
//                     encoding: JSONEncoding.default,
//                     headers: authHeader())
//            .log()
//            .responseObject { [unowned self] (response: DataResponse<ServerResponse<Services>>) in
//                self.process(response, with: failure) { services in
//                    success(services.dashboard ?? [], services.device ?? [])
//                }
//        }
//    }
    
    private func randomDelay() -> TimeInterval {
        return Double(arc4random_uniform(200)) / 100.0
    }
}
