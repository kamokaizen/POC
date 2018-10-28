//
//  Switcher.swift
//  kacagiderim_beta
//
//  Created by Comodo on 16.07.2018.
//  Copyright © 2018 kacagiderim. All rights reserved.
//

import Foundation
import UIKit

class Switcher {
    
    static func updateRootVC(){
        
        let status = UserDefaults.standard.bool(forKey: "isLoggedIn")
        let activeUser = UserDefaults.standard.string(forKey: "")
        let accessToken = UserDefaults.standard.string(forKey: "accessToken")
        let refreshToken = UserDefaults.standard.string(forKey: "refreshToken")
        let expireDate = UserDefaults.standard.integer(forKey: "expireDate")
        var rootVC : UIViewController?
        
        print("loggedIn:", status)
        print("active user:", activeUser)
        print("accessToken:", accessToken)
        print("refreshToken:", refreshToken)
        print("expireDate:", expireDate)
        
        if(status == true){
            rootVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "mainTabbarVC") as! MainTabbarController
        }else{
            rootVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "loginVC") as! LoginViewController
        }
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = rootVC
        
    }
    
}
