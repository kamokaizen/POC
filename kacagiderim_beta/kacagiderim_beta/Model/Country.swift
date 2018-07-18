//
//  Country.swift
//  kacagiderim_beta
//
//  Created by Comodo on 18.07.2018.
//  Copyright © 2018 kacagiderim. All rights reserved.
//

import Foundation
import ObjectMapper

class Country: NSObject {
    var countryId: String?
    var countryName: String?
    var countryCode: String?
    var countryCrawlerPath: String?
    
    required override init() {}
    required init?(map: Map) {}
}

extension Country: Mappable {
    func mapping(map: Map) {
        countryId <- map[.countryId]
        countryName <- map[.countryName]
        countryCode <- map[.countryCode]
        countryCrawlerPath <- map[.countryCrawlerPath]
    }
    
}

class Countries: NSObject {
    var countries: [Country]?
    
    required init?(map: Map) {}
}

extension Countries: Mappable {
    func mapping(map: Map) {
        countries <- map[.countries]
    }
}
