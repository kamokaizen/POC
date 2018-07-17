//
//  BaseAPI.swift
//  cDome
//
//  Created by Pavel Vilbik on 06.10.2017.
//  Copyright © 2017 Comodo. All rights reserved.
//

import UIKit
import AlamofireObjectMapper
import Alamofire
import ObjectMapper
import AlamofireActivityLogger
import KeychainSwift

private class ServerTrustPolicyManagerForDevelop: ServerTrustPolicyManager {
    
    init() {
        super.init(policies: [APIConstants.domainDev: .disableEvaluation])
    }
    
    override func serverTrustPolicy(forHost host: String) -> ServerTrustPolicy? {
        return .disableEvaluation
    }
}
class BaseAPI: NSObject {

    let listner = Alamofire.NetworkReachabilityManager()

    internal var session: Alamofire.SessionManager {
        let sessionAl = Alamofire.SessionManager(serverTrustPolicyManager: ServerTrustPolicyManagerForDevelop())
        sessionAl.delegate.sessionDidReceiveChallenge = { session, challenge in
            var disposition: URLSession.AuthChallengeDisposition = .performDefaultHandling
            var credential: URLCredential?
            
            if challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust,
                let trust = challenge.protectionSpace.serverTrust {
                disposition = URLSession.AuthChallengeDisposition.useCredential
                credential = URLCredential(trust: trust)
            } else {
                if challenge.previousFailureCount > 0 {
                    disposition = .cancelAuthenticationChallenge
                } else {
                    credential = sessionAl.session.configuration.urlCredentialStorage?.defaultCredential(for: challenge.protectionSpace)
                    
                    if credential != nil {
                        disposition = .useCredential
                    }
                }
            }
            
            return (disposition, credential)
            
        }
        return sessionAl
    }
    
    internal func process<T>(_ response: DataResponse<ServerResponse<T>>, with failure: ((Error) -> Void)? = nil, or success: @escaping (T) -> Void) {
        switch response.result {
        case .success(let serverResponse):
            if let error = serverResponse.error {
                failure?(error)
            } else {
                if let result = serverResponse.result {
                    success(result)
                } else {
                    failure?(RestApiError.emptyResult)
                }
            }
        case .failure(let error):
            failure?(error)
        }
    }
    
    internal func authHeader() -> HTTPHeaders? {
        return nil
    }
    
    internal func clean(string: String) -> String {
        let controlChars = CharacterSet.controlCharacters
        var range = (string as NSString).rangeOfCharacter(from: controlChars)
        if range.location != NSNotFound {
            let mutableString = NSMutableString(string: string)
            while range.location != NSNotFound {
                mutableString.deleteCharacters(in: range)
                range = mutableString.rangeOfCharacter(from: controlChars)
            }
            return (mutableString.copy() as? String) ?? string
        }
        return string
    }
}

extension Date {
    var milisecondsSince1970: Int64 {
        return Int64(timeIntervalSince1970 * 1000)
    }
}
