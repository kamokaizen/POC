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
    
    @IBOutlet fileprivate weak var mapView: GMSMapView!
    let locationManager = CLLocationManager()
    var workMarker = GMSMarker()
    var homeMarker = GMSMarker()
    var currentPosition = GMSMarker()
    var zoom: Float = 15
    //MARK: Create a delegate property here, don't forget to make it weak!
    weak var delegate: LocationUpdateDelegate? = nil
    
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
        showMarker(homePosition: (delegate?.getHomePosition())!, workPosition: (delegate?.getWorkPosition())!)
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
        homeMarker.icon = Utils.imageWithImage(image: UIImage(named: "home.png")!, scaledToSize: CGSize(width: 40.0, height: 40.0))

        workMarker.position = workPosition
        workMarker.title = "Work"
        workMarker.snippet = "Your work position"
        workMarker.isDraggable = true
        workMarker.map = mapView
        workMarker.icon = Utils.imageWithImage(image: UIImage(named: "office.png")!, scaledToSize: CGSize(width: 40.0, height: 40.0))
        
        currentPosition.title = "Current Position"
        currentPosition.snippet = "This location is provided from your device GPS"
        currentPosition.map = mapView
        currentPosition.icon = Utils.imageWithImage(image: UIImage(named: "current.png")!, scaledToSize: CGSize(width: 40.0, height: 40.0))
    }
    
    // MARK: - Actions
    
    @IBAction func didSaveTapped(sender: UIButton) {
        delegate?.homePositionChanged(lat: homeMarker.position.latitude, lon: homeMarker.position.longitude)
        delegate?.workPositionChanged(lat: workMarker.position.latitude, lon: workMarker.position.longitude)
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
