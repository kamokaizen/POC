//
//  LogoutManager.swift
//  kacagiderim_beta
//
//  Created by kamilinal on 11/12/18.
//  Copyright © 2018 kacagiderim. All rights reserved.
//

import Foundation
import GoogleSignIn
import Kingfisher
import FacebookLogin
import SwiftEntryKit

class AuthManager {
    static func logout(){
        TokenController.deleteUserFromUserDefaults()
        
        // Google Logout
        GIDSignIn.sharedInstance().signOut()
        
        // Facebook logout
        let loginManager = LoginManager()
        loginManager.logOut()
        
        // Update root views
        Switcher.updateRootVC()
        
        // From both memory and disk
        ImageCache.default.removeImage(forKey: "profile_image")
    }
}
