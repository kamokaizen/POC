//
//  Constants.swift
//  kacagiderim_beta
//
//  Created by Comodo on 19.07.2018.
//  Copyright © 2018 kacagiderim. All rights reserved.
//

import Foundation
import UIKit
import NVActivityIndicatorView

struct K {
    struct ProductionServer {
        static let baseURL = "https://kacagiderim.com"
//        static let baseURL = "http://10.100.136.239:4000"
//        static let baseURL = "http://127.0.0.1:4000"
    }
    
    struct APIParameterKey {
        static let userId = "userId"
        static let password = "password"
        static let currentPassword = "currentPassword"
        static let newPassword = "newPassword"
        static let confirmedPassword = "confirmedPassword"
        static let email = "email"
        static let scope = "scope"
        static let grantType = "grant_type"
        static let username = "username"
        static let token = "token"
        static let refreshToken = "refresh_token"
        static let name = "name"
        static let surname = "surname"
        static let countryId = "countryId"
        static let fromCountry = "fromcountry"
        static let fromCity = "fromcity"
        static let fromCities = "fromcities"
        static let homeLatitude = "homeLatitude"
        static let homeLongitude = "homeLongitude"
        static let workLatitude = "workLatitude"
        static let workLongitude = "workLongitude"
        static let currencyMetric = "currencyMetric"
        static let distanceMetric = "distanceMetric"
        static let volumeMetric = "volumeMetric"
        static let userType = "userType"
        static let socialSecurityNumber = "socialSecurityNumber"
        static let loginType = "loginType"
        static let imageURL = "imageURL"
        static let expirationDate = "expirationDate"
        static let brandId = "bid"
        static let modelId = "mid"
        static let engineId = "eid"
        static let versionId = "vid"
        static let vehicleDetailId = "vehicleDetailId"
        static let customVehicle = "customVehicle"
        static let vehiclePlate = "vehiclePlate"
        static let customConsumption = "customConsumption"
        static let averageCustomConsumptionLocal = "averageCustomConsumptionLocal"
        static let averageCustomConsumptionOut = "averageCustomConsumptionOut"
        static let customVehicleName = "customVehicleName"
        static let pageNumber = "pn"
        static let pageSize = "ps"
    }
    
    struct Constants {
        static let googleAPIKey = "AIzaSyCmG39jrBADwZXyq-3h3WSb67zRxXQUUws"
        static let googleSigninClientId = "383413793224-hbqr1tr5qarn89roo5agfi97anp9bfdt.apps.googleusercontent.com"
        static let loginAuthorizationValue = "Basic bW9iaWxlOg=="
        static let cloudinaryBasePath = "https://res.cloudinary.com/kacagiderim/image/upload/v1/"
        static let cloudinaryLogoPath =  "logo/thumb/"
        static let cloudinaryCarPath =  "cars/"
        static let requestTimeoutInterval = 10 // seconds
        static let kacagiderimColor = UIColor(red: 89.0/255.0, green: 151.0/255.0, blue: 181.0/255.0, alpha: 1.0)
        static let kacagiderimColorWarning = UIColor(red: 255/255.0, green: 0/255.0, blue: 0/255.0, alpha: 1.0)
        static let default_spinner = NVActivityIndicatorType.lineScale
        static let DEFAULT_FADE_IN_ANIMATION: FadeInAnimation = { view in
            view.alpha = 0
            UIView.animate(withDuration: 0.25) {
                view.alpha = 1
            }
        }
        static let DEFAULT_FADE_OUT_ANIMATION: FadeOutAnimation = { (view, complete) in
            UIView.animate(withDuration: 0.25,
                           animations: {
                            view.alpha = 0
            },
                           completion: { completed in
                            if completed {
                                complete()
                            }
            })
        }
    }
}

enum HTTPHeaderField: String {
    case authentication = "Authorization"
    case contentType = "Content-Type"
    case acceptType = "Accept"
    case acceptEncoding = "Accept-Encoding"
}

enum TokenControl: Int {
    case success = 1
    case timeout = -2
    case connectionProblem = -3
    case fail = -1
}

enum ContentType: String {
    case json = "application/json"
    case urlencoded = "application/x-www-form-urlencoded"
}

enum CurrencyMetrics: String, Codable {
    case TRY = "TRY"
    case EUR = "EUR"
    case USD = "USD"
}

enum DistanceMetrics: String, Codable {
    case KM = "KM"
    case M = "M"
    case MILE = "MILE"
}

enum VolumeMetrics: String , Codable {
    case LITER = "LITER"
    case GALLON = "GALLON"
}

enum UserType: String , Codable {
    case INDIVIDUAL = "INDIVIDUAL"
    case COMPANY = "COMPANY"
}

enum LoginType: String, Codable {
    case DEFAULT = "DEFAULT"
    case GOOGLE = "GOOGLE"
    case FACEBOOK = "FACEBOOK"
}

enum BrandType: Int, Codable {
    case MINIVAN = 0
    case AUTOMOBILE = 1
    case SUV = 2
}

enum FuelType: Int, Codable {
    case BENZIN = 0
    case DIZEL = 1
    case BENZIN_LPG = 2
    case HIBRIT = 3
}
