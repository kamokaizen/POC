//
//  Countries.swift
//  kacagiderim_beta
//
//  Created by kamilinal on 7/22/18.
//  Copyright © 2018 kacagiderim. All rights reserved.
//

import Foundation

struct Countries: Codable {
    let countries: [Country]?
    
    init(countries: [Country]) {
        self.countries = countries
    }
}
