//
//  User.swift
//  kacagiderim_beta
//
//  Created by Comodo on 18.07.2018.
//  Copyright © 2018 kacagiderim. All rights reserved.
//

import Foundation
import ObjectMapper

enum CurrencyMetrics: String {
    case TRY = "TRY"
    case EUR = "EUR"
    case USD = "USD"
}

enum DistanceMetrics: String {
    case KM = "KM"
    case M = "M"
    case MILE = "MILE"
}

enum VolumeMetrics: String {
    case LITER = "LITER"
    case GALLON = "GALLON"
}

enum UserType: String {
    case INDIVIDUAL = "INDIVIDUAL"
    case COMPANY = "COMPANY"
}

class User: NSObject {
    var username: String?
    var password: String?
    var name: String?
    var surname: String?
    var countryId: String?
    var homeLatitude: String?
    var homeLongitude: String?
    var workLatitude: String?
    var workLongitude: String?
    var currencyMetric: CurrencyMetrics?
    var distanceMetric: DistanceMetrics?
    var volumeMetric: VolumeMetrics?
    var userType: UserType?
    var socialSecurityNumber: String?
    
    required override init() {}
    required init?(map: Map) {}
}

extension User: Mappable {
    func mapping(map: Map) {
        username <- map[.username]
        password <- map[.password]
        name <- map[.name]
        surname <- map[.surname]
        countryId <- map[.countryId]
        homeLatitude <- map[.homeLatitude]
        homeLongitude <- map[.homeLongitude]
        workLatitude <- map[.workLatitude]
        workLongitude <- map[.workLongitude]
        currencyMetric <- map[.currencyMetric]
        distanceMetric <- map[.distanceMetric]
        volumeMetric <- map[.volumeMetric]
        userType <- map[.userType]
        socialSecurityNumber <- map[.socialSecurityNumber]
    }
    
}
