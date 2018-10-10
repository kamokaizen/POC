//
//  Utils.swift
//  kacagiderim_beta
//
//  Created by kamilinal on 7/21/18.
//  Copyright © 2018 kacagiderim. All rights reserved.
//

import Foundation
import UIKit
import NVActivityIndicatorView

class Utils {
    
    static func delayWithSeconds(_ seconds: Double, completion: @escaping () -> ()) {
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
            completion()
        }
    }
    
    static func imageWithImage(image:UIImage, scaledToSize newSize:CGSize) -> UIImage{
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        image.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }
    
    static func showLoadingIndicator(message:String, size:CGSize){
        let activityData = ActivityData(size: size, message: message, type: K.Constants.default_spinner)
        NVActivityIndicatorPresenter.sharedInstance.startAnimating(activityData, K.Constants.DEFAULT_FADE_IN_ANIMATION)
    }
    
    static func dismissLoadingIndicator(){
        NVActivityIndicatorPresenter.sharedInstance.stopAnimating(K.Constants.DEFAULT_FADE_OUT_ANIMATION)
    }
}
