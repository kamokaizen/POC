//
//  MapLocationSelectorVM.swift
//  kacagiderim_beta
//
//  Created by kamilinal on 12/9/18.
//  Copyright © 2018 kacagiderim. All rights reserved.
//

import Foundation
import GoogleMaps
import RxSwift
import RxCocoa

class ProfileLocationSelectorVM : NSObject,  CLLocationManagerDelegate {
    
    var locationManager = CLLocationManager()
    var currentPosition : BehaviorRelay<CLLocationCoordinate2D> = BehaviorRelay(value: CLLocationCoordinate2D())
    var homePosition : BehaviorRelay<CLLocationCoordinate2D> = BehaviorRelay(value: CLLocationCoordinate2D())
    var workPosition : BehaviorRelay<CLLocationCoordinate2D> = BehaviorRelay(value: CLLocationCoordinate2D())
    
    init(homePosition: CLLocationCoordinate2D?, workPosition: CLLocationCoordinate2D?) {
        super.init()
        self.homePosition.accept(homePosition ?? CLLocationCoordinate2D())
        self.workPosition.accept(workPosition ?? CLLocationCoordinate2D())
        
        // Ask for Authorisation from the User.
        self.locationManager.requestAlwaysAuthorization()
        
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }
    
    //MARK - CLLocation methods
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        print("locations = \(locValue.latitude) \(locValue.longitude)")
        self.currentPosition.accept(locValue)
//        focusMapToShowAllMarkers()
    }
}
