//
//  DefaultsManager.swift
//  kacagiderim_beta
//
//  Created by kamilinal on 10/28/18.
//  Copyright © 2018 kacagiderim. All rights reserved.
//

import Foundation
import DefaultsKit

class DefaultManager {
    static let defaults = Defaults()
    
    struct Keys {
        static let user = Key<User>("user")
        static let isLoggedIn = Key<Bool>("isLoggedIn")
        static let activeUser = Key<String>("activeUser")
        static let accessToken = Key<String>("accessToken")
        static let refreshToken = Key<String>("refreshToken")
        static let expireDate = Key<Int>("expireDate")
    }
    
    static func getUser() -> User? {
        return defaults.get(for: Keys.user)
    }
    static func isLoggedIn() -> Bool? {
        return defaults.get(for: Keys.isLoggedIn)
    }
    
    static func setUser(user: User) {
        defaults.set(user, for: Keys.user)
    }
    static func setIsLoggedIn(isLoggedIn: Bool) {
        defaults.set(isLoggedIn, for: Keys.isLoggedIn)
    }
}
