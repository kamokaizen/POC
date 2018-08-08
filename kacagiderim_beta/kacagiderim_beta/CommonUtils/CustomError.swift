//
//  CustomError.swift
//  kacagiderim_beta
//
//  Created by kamilinal on 7/21/18.
//  Copyright © 2018 kacagiderim. All rights reserved.
//

import Foundation

class CustomError: Error {
    var error:Error
    var localizedDescription: String
    var isRequestTimeout: Bool
    
    init(error:Error, reason:String, timeout:Bool) {
        self.error = error;
        self.localizedDescription = reason
        self.isRequestTimeout = timeout
    }
}
