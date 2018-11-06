//
//  DefaultsManager.swift
//  kacagiderim_beta
//
//  Created by kamilinal on 10/28/18.
//  Copyright © 2018 kacagiderim. All rights reserved.
//

import Foundation
import DefaultsKit

class DefaultManager {
    static let defaults = Defaults()
    
    struct Keys {
        static let user = Key<User>("user")
        static let isLoggedIn = Key<Bool>("isLoggedIn")
        static let activeUsername = Key<String>("activeUsername")
        static let accessToken = Key<String>("accessToken")
        static let refreshToken = Key<String>("refreshToken")
        static let expireDate = Key<Int>("expireDate")
        static let countries = Key<Countries>("countries")
        static let selectedCities = Key<[String]>("selectedCities")
        static let brands = Key<[Brand]>("brands")
        static let models = Key<Dictionary<String, [Model]>>("models")
        static let engines = Key<Dictionary<String, [Engine]>>("engines")
        static let versions = Key<Dictionary<String, [Version]>>("versions")
        static let details = Key<Dictionary<String, [Detail]>>("details")
    }
    
    static func clear(){
        defaults.clear(Keys.user)
        defaults.clear(Keys.isLoggedIn)
        defaults.clear(Keys.activeUsername)
        defaults.clear(Keys.accessToken)
        defaults.clear(Keys.refreshToken)
        defaults.clear(Keys.expireDate)
        defaults.clear(Keys.countries)
        defaults.clear(Keys.selectedCities)
        defaults.clear(Keys.brands)
        defaults.clear(Keys.models)
        defaults.clear(Keys.engines)
        defaults.clear(Keys.versions)
        defaults.clear(Keys.details)
    }
    
    //Mark get methods
    
    static func getUser() -> User? {
        return defaults.get(for: Keys.user)
    }
    static func isLoggedIn() -> Bool {
        return defaults.get(for: Keys.isLoggedIn) ?? false
    }
    static func getActiveUsername() -> String? {
        return defaults.get(for: Keys.activeUsername)
    }
    static func getAccessToken() -> String? {
        return defaults.get(for: Keys.accessToken)
    }
    static func getRefreshToken() -> String? {
        return defaults.get(for: Keys.refreshToken)
    }
    static func getExpireDate() -> Int? {
        return defaults.get(for: Keys.expireDate)
    }
    static func getCountries() -> Countries {
        return defaults.get(for: Keys.countries) ?? Countries(countries: [])
    }
    static func getSelectedCities() -> [String] {
        return defaults.get(for: Keys.selectedCities) ?? []
    }
    static func getBrands() -> [Brand] {
        return defaults.get(for: Keys.brands) ?? []
    }
    static func getModels(brandId: String) -> [Model] {
        let dictionary = defaults.get(for: Keys.models) ?? Dictionary()
        return dictionary[brandId] ?? [] 
    }
    static func getEngines(modelId: String) -> [Engine] {
        let dictionary = defaults.get(for: Keys.engines) ?? Dictionary()
        return dictionary[modelId] ?? []
    }
    static func getVersions(engineId: String) -> [Version] {
        let dictionary = defaults.get(for: Keys.versions) ?? Dictionary()
        return dictionary[engineId] ?? []
    }
    static func getDetails(versionId: String) -> [Detail] {
        let dictionary = defaults.get(for: Keys.details) ?? Dictionary()
        return dictionary[versionId] ?? []
    }
    
    //Mark set methods
    
    static func setUser(user: User) {
        defaults.set(user, for: Keys.user)
    }
    static func setIsLoggedIn(isLoggedIn: Bool) {
        defaults.set(isLoggedIn, for: Keys.isLoggedIn)
    }
    static func setActiveUsername(username: String) {
        defaults.set(username, for: Keys.activeUsername)
    }
    static func setRefreshToken(refreshToken: String) {
        defaults.set(refreshToken, for: Keys.refreshToken)
    }
    static func setAccessToken(accessToken: String) {
        defaults.set(accessToken, for: Keys.accessToken)
    }
    static func setExpireDate(expireDate: Int) {
        defaults.set(expireDate, for: Keys.expireDate)
    }
    static func setCountries(countries: Countries){
        defaults.set(countries, for: Keys.countries)
    }
    static func setSelectedCities(cities: [String]){
        defaults.set(cities, for: Keys.selectedCities)
    }
    static func setBrands(brands: [Brand]){
        defaults.set(brands, for: Keys.brands)
    }
    static func setModels(brandId: String, models:[Model]){
        var dictionary = defaults.get(for: Keys.models) ?? Dictionary()
        dictionary.updateValue(models, forKey: brandId)
        defaults.set(dictionary, for: Keys.models)
    }
    static func setEngines(modelId: String, engines:[Engine]){
        var dictionary = defaults.get(for: Keys.engines) ?? Dictionary()
        dictionary.updateValue(engines, forKey: modelId)
        defaults.set(dictionary, for: Keys.engines)
    }
    static func setVersions(engineId: String, versions:[Version]){
        var dictionary = defaults.get(for: Keys.versions) ?? Dictionary()
        dictionary.updateValue(versions, forKey: engineId)
        defaults.set(dictionary, for: Keys.versions)
    }
    static func setDetails(versionId: String, details:[Detail]){
        var dictionary = defaults.get(for: Keys.details) ?? Dictionary()
        dictionary.updateValue(details, forKey: versionId)
        defaults.set(dictionary, for: Keys.details)
    }
}
