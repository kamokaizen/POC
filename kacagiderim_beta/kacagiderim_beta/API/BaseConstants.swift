//
//  BaseConstants.swift
//  kacagiderim_beta
//
//  Created by Comodo on 17.07.2018.
//  Copyright © 2018 kacagiderim. All rights reserved.
//

import Foundation
import ObjectMapper
import KeychainSwift

struct APIConstants {
    
    //VPN Settings
    static let certificateName = "strongSwan CA"
    
    //Headers
    static let authHeaderKey = "Authorization"
    static let authHeaderKeyValue = "Basic"
    
    static let uuidDidUpdate = Notification.Name("UUID did  update")
    static let didLogin = Notification.Name("User did login")
    static let deviceDidUpdate = Notification.Name("Device did update")
    static let launchKey = "notFirstLaunch"
}

enum APIKey: String {
    case surname
    case countryId
    case countryName
    case countryCode
    case countryCrawlerPath
    case homeLatitude
    case homeLongitude
    case workLatitude
    case workLongitude
    case currencyMetric
    case distanceMetric 
    case volumeMetric
    case userType
    case socialSecurityNumber
    case username
    case email
    case password
    case countries
    case uuid
    case type
    case id
    case eapId = "eap_id"
    case p12
    case p12Password = "p12_password"
    case cert
    case addr
    case name
    case remote
    case local
    case status
    case statusCode
    case result
    case message
    case title
    case description
    case servicetype
    case version
    case services
    case totime
    case fromtime
    case keys
    case values
    case details
    case shieldmobile
    case charttype
    case deviceId = "device_id"
    case deviceName = "device_name"
    case isAdmin = "is_admin"
    case devices
    case dashboardReports = "dashboard_reports"
    case deviceReports = "device_reports"
    case cwatchmobile
    case deviceToken = "device_token"
    case deviceOS = "device_os"
    case pass
    case websitesBlocked = "websites_blocked"
    case websitesVisited = "websites_visited"
    case attacksBlocked = "attacks_blocked"
    case mostVisitedWebsite = "most_visited_website"
    case mostBlockedCategory = "most_blocked_category"
    case lastSeen = "last_seen"
}

extension String {
    static func == (left: String, right: APIKey) -> Bool {
        return left == right.rawValue
    }
}

extension KeychainSwift {
    func get(_ key: APIKey) -> String? {
        return get(key.rawValue)
    }
    
    func set(_ value: String, for key: APIKey) {
        set(value, forKey: key.rawValue)
    }
}

extension Map {
    subscript(key: APIKey) -> Map {
        return self[key.rawValue]
    }
}

extension UIImage {
    func resizedImage(newSize: CGSize) -> UIImage {
        // Guard newSize is different
        guard self.size != newSize else { return self }
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        self.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }
    
    func resizedImageWithinRect(rectSize: CGSize) -> UIImage {
        let widthFactor = size.width / rectSize.width
        let heightFactor = size.height / rectSize.height
        
        var resizeFactor = widthFactor
        if size.height > size.width {
            resizeFactor = heightFactor
        }
        
        let newSize = CGSize(width: size.width/resizeFactor, height: size.height/resizeFactor)
        let resized = resizedImage(newSize: newSize)
        return resized
    }
}

