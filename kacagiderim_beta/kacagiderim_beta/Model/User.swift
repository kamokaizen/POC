//
//  User.swift
//  kacagiderim_beta
//
//  Created by Comodo on 18.07.2018.
//  Copyright © 2018 kacagiderim. All rights reserved.
//

import Foundation

struct User: Codable {
    let username: String
    let password: String
    let name: String
    let surname: String
    let countryId: String
    let homeLatitude: String?
    let homeLongitude: String?
    let workLatitude: String?
    let workLongitude: String?
    let currencyMetric: CurrencyMetrics
    let distanceMetric: DistanceMetrics
    let volumeMetric: VolumeMetrics
    let userType: UserType
    let socialSecurityNumber: String?
    
    init(username: String,
         password: String,
         name: String,
         surname: String,
         countryId: String,
         homeLatitude: String? = nil,
         homeLongitude: String? = nil,
         workLatitude: String? = nil,
         workLongitude: String? = nil,
         currencyMetric: CurrencyMetrics,
         distanceMetric: DistanceMetrics,
         volumeMetric: VolumeMetrics,
         userType: UserType,
         socialSecurityNumber: String? = nil) {
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
    }
}
