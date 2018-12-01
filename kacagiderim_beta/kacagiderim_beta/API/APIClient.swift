//
//  APIClient.swift
//  kacagiderim_beta
//
//  Created by Comodo on 19.07.2018.
//  Copyright © 2018 kacagiderim. All rights reserved.
//

import Alamofire

class APIClient {
        
    private static func checkTokenExpired<T:Decodable>(route:APIConfiguration, completion:@escaping (Result<T>)->Void){
        TokenController.handleTokenExpire(completion: { value in
            // equal to 1 is all is well, equal to -1 means something went wrong
            switch value {
            case .success:
                performRequest(route: route, completion: completion)
            case .timeout, .connectionProblem:
                // nothing can do
                print("there is a connection problem between your device and server")
                performRequest(route: route, completion: completion)
            case .fail:
                // means that can not refresh token and so delete user from user defaults then go to login page
                AuthManager.logout()
                PopupHandler.errorPopup(title: "Session Expired", description: "Your session has expired. Please sign in kacagiderim again!")
            }
        })
    }
    
    @discardableResult
    private static func performRequest<T:Decodable>(route:APIConfiguration, decoder: JSONDecoder = JSONDecoder(), completion:@escaping (Result<T>)->Void) -> DataRequest {
        
        return Alamofire.request(route)
            .validate()
            .response { (response) in
                print("Request: \(String(describing: response.request))")
                print("Response: \(String(describing: response.response))")
                if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                    print("Data: \(utf8Text)")
                }
                print("Error: \(String(describing: response.error))")
                
                let timeout = response.error?._code == NSURLErrorTimedOut ? true : false
                let statusCode = response.response?.statusCode != nil ? response.response?.statusCode : -1
                
                if(statusCode == 401){
                    print("API refresh token invalid. Need to re login")
                    // means that can not refresh token and so delete user from user defaults then go to login page
                    AuthManager.logout()
                    PopupHandler.errorPopup(title: "Session Expired", description: "Your session has expired. Please sign in kacagiderim again!")
                    return
                }
                
                if(response.error != nil){                    
                    do{
                        var customError = CustomError(error:response.error!, reason: (response.error?.localizedDescription)!, timeout:timeout, statusCode:statusCode!)
                        
                        switch(route){
                        case LoginEndpoint.login:
                            customError = CustomError(error: response.error!, reason: try decoder.decode(LoginFailResponse.self, from: response.data!).error_description, timeout:timeout,statusCode:statusCode!)
                        case UserEndpoint.create:
                            customError = CustomError(error: response.error!, reason: try decoder.decode(ServerResponse<User>.self, from: response.data!).reason, timeout:timeout,statusCode:statusCode!)
                        default:
                            customError = CustomError(error:response.error!, reason: (response.error?.localizedDescription)!, timeout:timeout,statusCode:statusCode!)
                        }
                        
                        completion(Result<T>.failure(customError))
                        return
                    }
                    catch{
                        print("API Unexpected Parse error: \(error).")
                        completion(Result<T>.failure(CustomError(error: error, reason: (response.error?.localizedDescription)!, timeout:timeout,statusCode:statusCode!)))
                        return
                    }
                }
                
                do{
                    let decodedResponse = try decoder.decode(T.self, from: response.data!)
                    completion(Result<T>.success(decodedResponse))
                    return
                }
                catch{
                    print("API Unexpected Parse error: \(error).")
                    completion(Result<T>.failure(CustomError(error: error, reason: (response.error?.localizedDescription)!, timeout:timeout, statusCode:statusCode!)))
                    return
                }
        }
    }
    
    static func login(email: String, password: String, completion:@escaping (Result<LoginSuccessResponse>)->Void) {
        // this method do not need access_token
        performRequest(route: LoginEndpoint.login(email: email, password: password), completion: completion)
    }
    
    static func createAccount(user: User, completion:@escaping (Result<ServerResponse<User>>)->Void) {
        // this method do not need access_token
        performRequest(route: UserEndpoint.create(user:user), completion: completion)
    }
    
    static func createAccountFromGoogle(token: String, completion:@escaping (Result<ServerResponse<LoginSuccessResponse>>)->Void){
        // this method do not need access_token
        performRequest(route: UserEndpoint.createGoogleUser(token: token), completion: completion)
    }
    
    static func createAccountFromFacebook(user: FacebookUser, completion:@escaping
        (Result<ServerResponse<LoginSuccessResponse>>)->Void){
        // this method do not need access_token
        performRequest(route: UserEndpoint.createFacebookUser(user: user), completion: completion)
    }
    
    static func updateAccount(user: User, completion:@escaping (Result<ServerResponse<User>>)->Void) {
        checkTokenExpired(route: UserEndpoint.update(user:user), completion: completion)
    }
    
    static func changePassword(current: String, new: String, confirmed: String, completion:@escaping (Result<ServerResponse<User>>)->Void) {
        checkTokenExpired(route: UserEndpoint.changePassword(current: current, new: new, confirmed: confirmed), completion: completion)
    }
    
    static func getCurrentUser(completion:@escaping (Result<ServerResponse<User>>)->Void){
        checkTokenExpired(route: UserEndpoint.current(), completion: completion)
    }

    static func getAllCountries(completion:@escaping (Result<ServerResponse<Countries>>)->Void) {
        // this method do not need access_token
        performRequest(route: NationEndpoint.countries, completion: completion)
    }
    
    static func getCitiesOfCountry(countryId: String, completion:@escaping (Result<ServerResponse<Cities>>)->Void) {
        checkTokenExpired(route: NationEndpoint.cities(countryId: countryId), completion: completion)
    }
    
    static func refreshToken(refreshToken:String, completion:@escaping (Result<LoginSuccessResponse>)->Void){
        // this method do not need access_token
        performRequest(route: LoginEndpoint.refreshToken(refreshToken: refreshToken), completion: completion)
    }
    
    static func getFuelPrices(country: String, city: String, completion:@escaping (Result<ServerResponse<FuelPrice>>)->Void){
        checkTokenExpired(route: FuelEndpoint.prices(country: country, city: city), completion: completion)
    }
    
    static func getFuelPricesWithNames(country: String, cities: String, completion:@escaping (Result<ServerResponse<FuelPrices>>)->Void){
        checkTokenExpired(route: FuelEndpoint.priceswithnames(country: country, cities: cities), completion: completion)
    }
    
    static func getBrands(completion:@escaping (Result<ServerResponse<PageResponse<Brand>>>) -> Void){
        checkTokenExpired(route: CarEndpoint.brands(), completion: completion)
    }
    
    static func getModels(brandId: String, completion:@escaping (Result<ServerResponse<PageResponse<Model>>>) -> Void){
        checkTokenExpired(route: CarEndpoint.models(brandId: brandId, pageNumber: 1, pageSize: 1000), completion: completion)
    }
    
    static func getEngines(modelId: String, completion:@escaping (Result<ServerResponse<PageResponse<Engine>>>) -> Void) {
        checkTokenExpired(route: CarEndpoint.engines(modelId: modelId, pageNumber: 1, pageSize: 1000), completion: completion)
    }
    
    static func getVersions(engineId: String, completion:@escaping (Result<ServerResponse<PageResponse<Version>>>) -> Void) {
        checkTokenExpired(route: CarEndpoint.versions(engineId: engineId, pageNumber: 1, pageSize: 1000), completion: completion)
    }
    
    static func getPackets(versionId: String, completion:@escaping (Result<ServerResponse<PageResponse<Packet>>>) -> Void) {
        checkTokenExpired(route: CarEndpoint.packets(versionId: versionId, pageNumber: 1, pageSize: 1000), completion: completion)
    }
    
    static func getDetails(versionId: String, completion:@escaping (Result<ServerResponse<PageResponse<Detail>>>) -> Void) {
        checkTokenExpired(route: CarEndpoint.details(versionId: versionId, pageNumber: 1, pageSize: 1000), completion: completion)
    }

    static func getDetail(detailId: String, completion:@escaping (Result<ServerResponse<Detail>>) -> Void) {
        checkTokenExpired(route: CarEndpoint.detail(detailId: detailId), completion: completion)
    }
    
    static func vehicleSearch(searchText: String, pageNumber:Int, completion:@escaping (Result<ServerResponse<PageResponse<Detail>>>) -> Void){
        checkTokenExpired(route: CarEndpoint.details(versionId: searchText, pageNumber: pageNumber, pageSize: 20), completion: completion)
    }
    
    static func getUserVehicles(userId: String, completion:@escaping (Result<ServerResponse<VehicleResponse>>) -> Void){
        checkTokenExpired(route: AccountEndpoint.getVehicles(userId: userId), completion: completion)
    }
    
    static func createVehicle(accountVehicle: AccountVehicle, completion:@escaping (Result<ServerResponse<AccountVehicle>>) -> Void){
        checkTokenExpired(route: AccountEndpoint.createVehicle(accountVehicle: accountVehicle), completion: completion)
    }
    
    static func updateVehicle(accountVehicle: AccountVehicle, completion:@escaping (Result<ServerResponse<AccountVehicle>>) -> Void){
        checkTokenExpired(route: AccountEndpoint.updateVehicle(accountVehicle: accountVehicle), completion: completion)
    }
    
    static func deleteVehicle(accountVehicleId: String, completion:@escaping (Result<ServerResponse<AccountVehicle>>) -> Void){
        checkTokenExpired(route: AccountEndpoint.deleteVehicle(accountVehicleId: accountVehicleId), completion: completion)
    }
}
