//
//  User.swift
//  kacagiderim_beta
//
//  Created by Comodo on 18.07.2018.
//  Copyright © 2018 kacagiderim. All rights reserved.
//

import Foundation

struct User: Codable {
    let userId: String?
    let username: String
    let password: String?
    let name: String?
    let surname: String?
    let countryId: String
    let homeLatitude: Double?
    let homeLongitude: Double?
    let workLatitude: Double?
    let workLongitude: Double?
    let currencyMetric: CurrencyMetrics
    let distanceMetric: DistanceMetrics
    let volumeMetric: VolumeMetrics
    let userType: UserType
    let socialSecurityNumber: String?
    let loginType: LoginType
    let imageURL: String?
    
    init(userId: String? = nil,
         username: String,
         password: String? = nil,
         name: String? = nil,
         surname: String? = nil,
         countryId: String,
         homeLatitude: Double? = 0.0,
         homeLongitude: Double? = 0.0,
         workLatitude: Double? = 0.0,
         workLongitude: Double? = 0.0,
         currencyMetric: CurrencyMetrics,
         distanceMetric: DistanceMetrics,
         volumeMetric: VolumeMetrics,
         userType: UserType,
         socialSecurityNumber: String? = nil,
         loginType: LoginType,
         imageURL: String? = nil) {
        self.userId = userId
        self.username = username
        self.password = password
        self.name = name
        self.surname = surname
        self.countryId = countryId
        self.homeLatitude = homeLatitude
        self.homeLongitude = homeLongitude
        self.workLatitude = workLatitude
        self.workLongitude = workLongitude
        self.currencyMetric = currencyMetric
        self.distanceMetric = distanceMetric
        self.volumeMetric = volumeMetric
        self.userType = userType
        self.socialSecurityNumber = socialSecurityNumber
        self.loginType = loginType
        self.imageURL = imageURL
    }
}
