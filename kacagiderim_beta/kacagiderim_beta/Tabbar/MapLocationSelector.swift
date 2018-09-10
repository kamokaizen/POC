//
//  MapLocationSelector.swift
//  kacagiderim_beta
//
//  Created by Comodo on 7.09.2018.
//  Copyright © 2018 kacagiderim. All rights reserved.
//

import Foundation
import UIKit
import GoogleMaps

class MapLocationSelector : UIViewController, GMSMapViewDelegate, CLLocationManagerDelegate {
    
    var viewModel:ProfileViewModel?
    @IBOutlet fileprivate weak var mapView: GMSMapView!
    let locationManager = CLLocationManager()
    var workMarker = GMSMarker()
    var homeMarker = GMSMarker()
    var currentPosition = GMSMarker()
    var zoom: Float = 15
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Ask for Authorisation from the User.
        self.locationManager.requestAlwaysAuthorization()
        
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        
        let camera = GMSCameraPosition.camera(withLatitude: 37.36, longitude: -122.0, zoom: zoom)
        mapView.camera = camera
//        mapView.settings.myLocationButton = true
        
        let homeLatitude = Double(viewModel?.homeLatitude.value ?? "") ?? 0.0
        let homelongitude = Double(viewModel?.homeLongitude.value ?? "") ?? 0.0
        let workLatitude = Double(viewModel?.workLatitude.value ?? "") ?? 0.0
        let worklongitude = Double(viewModel?.workLongitude.value ?? "") ?? 0.0
        
        let homePosition = CLLocationCoordinate2D(latitude: homeLatitude, longitude: homelongitude)
        let workPosition = CLLocationCoordinate2D(latitude: workLatitude, longitude: worklongitude)
        showMarker(homePosition: homePosition, workPosition: workPosition)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func showMarker(homePosition: CLLocationCoordinate2D, workPosition: CLLocationCoordinate2D){
        homeMarker.position = homePosition
        homeMarker.title = "Home"
        homeMarker.snippet = "Your home position"
        homeMarker.isDraggable = true
        homeMarker.map = mapView

        workMarker.position = workPosition
        workMarker.title = "Work"
        workMarker.snippet = "Your work position"
        workMarker.isDraggable = true
        workMarker.map = mapView
        
        currentPosition.title = "Current Position"
        currentPosition.snippet = "This location is provided from your device GPS"
        currentPosition.map = mapView
    }
    
    // MARK: - Actions
    
    @IBAction func didSaveTapped(sender: UIButton) {
        self.viewModel?.homeLatitude.value = "\(homeMarker.position.latitude)"
        self.viewModel?.homeLongitude.value = "\(homeMarker.position.longitude)"
        self.viewModel?.workLatitude.value = "\(workMarker.position.latitude)"
        self.viewModel?.workLongitude.value = "\(workMarker.position.longitude)"
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func didCancelTapped(sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnZoomIn(_ sender: Any) {
        zoom = zoom + 1
        self.mapView.animate(toZoom: zoom)
    }
    
    @IBAction func btnZoomOut(_ sender: Any) {
        zoom = zoom - 1
        self.mapView.animate(toZoom: zoom)
    }
    
    //MARK - GMSMarker Dragging
    
    func mapView(_ mapView: GMSMapView, didBeginDragging marker: GMSMarker) {
        print("didBeginDragging")
    }
    func mapView(_ mapView: GMSMapView, didDrag marker: GMSMarker) {
        print("didDrag")
    }
    func mapView(_ mapView: GMSMapView, didEndDragging marker: GMSMarker) {
        print("didEndDragging")
    }
    
    //MARK - tap event
    
//    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D){
//        marker.position = coordinate
//    }
    
    //MARK - CLLocation methods
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        print("locations = \(locValue.latitude) \(locValue.longitude)")
        currentPosition.position = locValue
    }
}
