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
        let status = DefaultManager.isLoggedIn()
        var rootVC : UIViewController?
        
        if(status == true){
            rootVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "mainTabbarVC") as! MainTabbarController
        }else{
            rootVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "loginVC") as! LoginViewController
        }
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.navigationController = UINavigationController(rootViewController: rootVC!)
        appDelegate.window?.rootViewController = appDelegate.navigationController
    }
    
}
