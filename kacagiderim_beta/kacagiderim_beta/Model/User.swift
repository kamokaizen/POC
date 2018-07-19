//
//  User.swift
//  kacagiderim_beta
//
//  Created by Comodo on 18.07.2018.
//  Copyright © 2018 kacagiderim. All rights reserved.
//

import Foundation

struct User: Codable {
    let firstName: String
    let lastName: String
    let email: String
    let image: URL
}

//struct User: Codable {
//    let username: String?
//    let password: String?
//    let name: String?
//    let surname: String?
//    let countryId: String?
//    let homeLatitude: String?
//    let homeLongitude: String?
//    let workLatitude: String?
//    let workLongitude: String?
//    let currencyMetric: CurrencyMetrics?
//    let distanceMetric: DistanceMetrics?
//    let volumeMetric: VolumeMetrics?
//    let userType: UserType?
//    let socialSecurityNumber: String?
//}

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
