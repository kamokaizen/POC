//
//  FuelPrice.swift
//  kacagiderim_beta
//
//  Created by kamilinal on 8/11/18.
//  Copyright © 2018 kacagiderim. All rights reserved.
//

import Foundation

struct FuelPrice: Codable {
    let fuelPriceItem: FuelPriceItem
}

struct FuelPriceItem: Codable {
    let avgFLPrc, avgDSLPrc, avgLpgPrc: Double
    let cur: String
    let lstUptTime, cityID, countryID, cityName, countryName: String?
    let status: Bool
    
    enum CodingKeys: String, CodingKey {
        case avgFLPrc = "avgFlPrc"
        case avgDSLPrc = "avgDslPrc"
        case avgLpgPrc, cur, lstUptTime
        case cityID = "cityId"
        case countryID = "countryId"
        case cityName, countryName, status
    }
}
