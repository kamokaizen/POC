//
//  Utils.swift
//  kacagiderim_beta
//
//  Created by kamilinal on 7/21/18.
//  Copyright © 2018 kacagiderim. All rights reserved.
//

import Foundation

class Utils {
    
    static func delayWithSeconds(_ seconds: Double, completion: @escaping () -> ()) {
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
            completion()
        }
    }
    
}
