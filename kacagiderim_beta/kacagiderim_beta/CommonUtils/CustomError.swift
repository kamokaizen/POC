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
    var statusCode: Int
    
    init(error:Error, reason:String, timeout:Bool, statusCode:Int) {
        self.error = error;
        self.localizedDescription = reason
        self.isRequestTimeout = timeout
        self.statusCode = statusCode
    }
    
    func getErrorMessage() -> String {
        switch(self.statusCode){
        case 400:
            return "Bad Request"
        case 409:
            return "Conflict"
        default:
            return "Something went wrong, Please Try again later"
        }
    }
}
