//
//  CloudinaryManager.swift
//  kacagiderim_beta
//
//  Created by kamilinal on 11/5/18.
//  Copyright © 2018 kacagiderim. All rights reserved.
//

import Foundation
import Kingfisher

class ImageManager {
    
    static func getImageFromCloudinary(path: String, completion:@escaping (UIImage?) -> Void){
        let imageURL = K.Constants.cloudinaryBasePath + path
        let imageURLObject = URL(string: imageURL)
        if(imageURLObject == nil){
            return completion(nil)
        }
        print("image URL \(imageURL)")
        ImageCache.default.retrieveImage(forKey: imageURL, options: nil) {
            image, cacheType in
            if let image = image {
                print("Get image \(image), cacheType: \(cacheType).")
                //In this code snippet, the `cacheType` is .disk
                return completion(image)
            } else {
                print("Not exist in cache.")
                ImageDownloader.default.downloadImage(with: imageURLObject!, options: [], progressBlock: nil) {
                    (image, error, url, data) in
                    if let image = image {
                        ImageCache.default.store(image, forKey: imageURL)
                        return completion(image)
                    }
                    else{
                        return completion(nil)
                    }
                }
            }
        }
    }
    
    static func getImage(imageUrl: String?, completion:@escaping (UIImage?) -> Void) {
        if(imageUrl == nil || (imageUrl != nil && imageUrl!.isEmpty)){
            return completion(nil)
        }
        
        ImageCache.default.retrieveImage(forKey: imageUrl!, options: nil) {
            image, cacheType in
            if let image = image {
                print("Get image \(image), cacheType: \(cacheType).")
                //In this code snippet, the `cacheType` is .disk
                return completion(image)
            } else {
                print(imageUrl! + " Not exist in cache.")
                ImageDownloader.default.downloadImage(with: URL(string: imageUrl!)!, options: [], progressBlock: nil) {
                    (image, error, url, data) in
                    if let image = image {
                        ImageCache.default.store(image, forKey: imageUrl!)
                        return completion(image)
                    }
                    else{
                        return completion(nil)
                    }
                }
            }
        }
    }
}
