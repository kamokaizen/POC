//
//  CloudinaryManager.swift
//  kacagiderim_beta
//
//  Created by kamilinal on 11/5/18.
//  Copyright © 2018 kacagiderim. All rights reserved.
//

import Foundation
import Cloudinary
import Kingfisher

class ImageManager {
    static let cloudinary = CLDCloudinary(configuration: CLDConfiguration(cloudName: K.Constants.cloudinaryCloudName, secure: true))
    
    static func getImageFromCloudinary(path: String, completion:@escaping (UIImage?) -> Void){
        let imageURL = ImageManager.cloudinary.createUrl().generate(path)
        print("image URL \(imageURL ?? "")")
        ImageCache.default.retrieveImage(forKey: imageURL!, options: nil) {
            image, cacheType in
            if let image = image {
                print("Get image \(image), cacheType: \(cacheType).")
                //In this code snippet, the `cacheType` is .disk
                completion(image)
            } else {
                print("Not exist in cache.")
                ImageDownloader.default.downloadImage(with: URL(string: imageURL!)!, options: [], progressBlock: nil) {
                    (image, error, url, data) in
                    if let image = image {
                        ImageCache.default.store(image, forKey: imageURL!)
                        completion(image)
                    }
                    else{
                        completion(nil)
                    }
                }
            }
        }
    }
    
    static func getImage(imageUrl: String, completion:@escaping (UIImage?) -> Void) {
        ImageCache.default.retrieveImage(forKey: imageUrl, options: nil) {
            image, cacheType in
            if let image = image {
                print("Get image \(image), cacheType: \(cacheType).")
                //In this code snippet, the `cacheType` is .disk
                completion(image)
            } else {
                print("Not exist in cache.")
                ImageDownloader.default.downloadImage(with: URL(string: imageUrl)!, options: [], progressBlock: nil) {
                    (image, error, url, data) in
                    if let image = image {
                        ImageCache.default.store(image, forKey: imageUrl)
                        completion(image)
                    }
                    else{
                        completion(nil)
                    }
                }
            }
        }
    }
}
