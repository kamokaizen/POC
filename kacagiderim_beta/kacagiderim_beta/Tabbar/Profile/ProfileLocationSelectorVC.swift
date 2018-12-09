//
//  ProfileLocationSelectorVC.swift
//  kacagiderim_beta
//
//  Created by kamilinal on 12/9/18.
//  Copyright © 2018 kacagiderim. All rights reserved.
//

import Foundation
import UIKit
import GoogleMaps
import CardParts

class ProfileLocationSelectorVC : CardPartsFullScreenViewController, GMSMapViewDelegate {
    
    var viewModel: ProfileLocationSelectorVM!
    var mapView: GMSMapView!
    var workMarker = GMSMarker()
    var homeMarker = GMSMarker()
    var currentPosition = GMSMarker()
    var clickMarker = GMSMarker()
    var tappedMarker = GMSMarker()
    var markers: [GMSMarker] = []
    var homeImage = Utils.imageWithImage(image: UIImage(named: "home.png")!, scaledToSize: CGSize(width: 40.0, height: 40.0))
    var workImage = Utils.imageWithImage(image: UIImage(named: "office")!, scaledToSize: CGSize(width: 40.0, height: 40.0))
    var currentImage = Utils.imageWithImage(image: UIImage(named: "current.png")!, scaledToSize: CGSize(width: 40.0, height: 40.0))
    var clickImage = Utils.imageWithImage(image: UIImage(named: "click.png")!, scaledToSize: CGSize(width: 40.0, height: 40.0))
    
    let homeChangeButton = UIButton(type: UIButton.ButtonType.custom)
    let workChangeButton = UIButton(type: UIButton.ButtonType.custom)
    
    var infoWindow = UIView(frame: CGRect.init(x: 0, y: 0, width: 220, height: 110))
    var zoom: Float = 15
    let offsetClickMarker: CGFloat = 40
    let offsetOtherMarker: CGFloat = 20
    
    var topPadding:CGFloat = 0.0
    var bottomPadding:CGFloat = 0.0
    var width:CGFloat = 0.0
    var height:CGFloat = 0.0
    
    let toolbarHeight:CGFloat = 44.0
    let zoomButtonHeight:CGFloat = 50.0
    
    public init(viewModel: ProfileLocationSelectorVM) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
    }
    
    required public init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        calculateViewProperties()
        createToolbar()
        initializeMapView()
        bindMapButtons()
        createMarkers(homePosition: viewModel!.homePosition.value, workPosition: viewModel!.workPosition.value)
        focusMapToShowAllMarkers()    
    }
    
    func calculateViewProperties(){
        let params = Utils.returnSafeAreaParameters()
        topPadding = params.0
        bottomPadding = params.1
        width = self.view.bounds.width
        height = self.view.bounds.height
    }
    
    func initializeMapView(){
        let lat = currentPosition.position.latitude
        let lon = currentPosition.position.longitude
        
        let camera = GMSCameraPosition.camera(withLatitude: lat, longitude: lon, zoom: zoom)
        mapView = GMSMapView.map(withFrame: CGRect(x: 0, y: topPadding + toolbarHeight, width: width, height: height-bottomPadding-toolbarHeight), camera: camera)
        self.mapView.delegate = self
        self.view.addSubview(mapView)
    }
    
    func createToolbar(){
        let toolbar = UIToolbar(frame: CGRect(x:0, y: topPadding, width: width, height: toolbarHeight))
        toolbar.barStyle = UIBarStyle.default
        let titleView = UIBarButtonItem.init(title: "Configure Locations", style: UIBarButtonItem.Style.plain, target: nil, action: nil)
        titleView.tintColor = UIColor.darkDefault
        let doneButton = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: self, action: #selector(didSaveTapped(sender:)))
        let cancelButton = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonItem.SystemItem.cancel, target: self, action: #selector(didCancelTapped(sender:)))
        let fixedSpace = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        toolbar.setItems([cancelButton,fixedSpace, titleView, fixedSpace, doneButton], animated: true)
        self.view.addSubview(toolbar)
    }
    
    func bindMapButtons(){
        homeChangeButton.setImage(homeImage, for: UIControl.State.normal)
        homeChangeButton.imageView?.contentMode = .scaleAspectFit;
        homeChangeButton.addTarget(self, action:#selector(setCurrentToHomeTapped), for: .touchUpInside)
        workChangeButton.setImage(workImage, for: UIControl.State.normal)
        workChangeButton.imageView?.contentMode = .scaleAspectFit;
        workChangeButton.addTarget(self, action:#selector(setCurrentToWorkTapped), for: .touchUpInside)
        
        let zoomInButton = CardPartButtonView()
        zoomInButton.frame = CGRect(x: width-zoomButtonHeight, y: height-bottomPadding-toolbarHeight-(zoomButtonHeight*2), width: zoomButtonHeight, height: zoomButtonHeight)
        zoomInButton.setImage(Utils.imageWithImage(image: UIImage(named: "plus.png")!, scaledToSize: CGSize(width: zoomButtonHeight, height: zoomButtonHeight)), for: UIControl.State.normal)
        zoomInButton.addTarget(self, action: #selector(btnZoomIn(_:)), for: .touchUpInside)
        
        let zoomOutButton = CardPartButtonView()
        zoomOutButton.frame = CGRect(x: width-zoomButtonHeight, y: height-bottomPadding-toolbarHeight-zoomButtonHeight, width: zoomButtonHeight, height: zoomButtonHeight)
        zoomOutButton.setImage(Utils.imageWithImage(image: UIImage(named: "minus.png")!, scaledToSize: CGSize(width: zoomButtonHeight, height: zoomButtonHeight)), for: UIControl.State.normal)
        zoomOutButton.addTarget(self, action: #selector(btnZoomOut(_:)), for: .touchUpInside)
        self.view.addSubview(zoomInButton)
        self.view.addSubview(zoomOutButton)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func createMarkers(homePosition: CLLocationCoordinate2D, workPosition: CLLocationCoordinate2D){
        homeMarker.position = homePosition
        homeMarker.title = "Home"
        homeMarker.snippet = "Your home position"
        homeMarker.isDraggable = true
        homeMarker.map = mapView
        homeMarker.icon = homeImage
        
        workMarker.position = workPosition
        workMarker.title = "Work"
        workMarker.snippet = "Your work position"
        workMarker.isDraggable = true
        workMarker.map = mapView
        workMarker.icon = workImage
        
        currentPosition.title = "Current Position"
        currentPosition.snippet = "Your current position"
        currentPosition.map = mapView
        currentPosition.icon = currentImage
        
        clickMarker.map = mapView
        clickMarker.icon = clickImage
        
        self.markers.append(homeMarker)
        self.markers.append(workMarker)
        self.markers.append(currentPosition)
        self.markers.append(clickMarker)
    }
    
    func focusMapToShowAllMarkers() {
        let firstLocation: CLLocationCoordinate2D = self.markers.first!.position
        var bounds: GMSCoordinateBounds = GMSCoordinateBounds(coordinate: firstLocation, coordinate: firstLocation)
        
        for marker in self.markers {
            if(CLLocationCoordinate2DIsValid(marker.position)){
                print("marker position: ", marker.position.latitude, marker.position.longitude)
                bounds = bounds.includingCoordinate(marker.position)
                let camera = self.mapView.camera(for: bounds, insets: UIEdgeInsets(top: 30, left: 30, bottom: 30, right: 30))!
                self.mapView.camera = camera
            }
        }
    }
    
    func constructCustomInfoWindow(marker:GMSMarker) -> UIView {
        infoWindow.removeFromSuperview()
        
        if(marker == clickMarker){
            infoWindow = UIView(frame: CGRect.init(x: 0, y: 0, width: 220, height: 110))
            let stackVertical = CardPartStackView(frame: CGRect.init(x: 10, y: 10, width: 200, height: 90))
            stackVertical.axis = .vertical
            stackVertical.spacing = 0
            stackVertical.distribution = .equalSpacing
            
            let stackHorizontal = CardPartStackView(frame: CGRect.init(x: 0, y: 0, width: 200, height: 45))
            stackHorizontal.axis = .horizontal
            stackHorizontal.spacing = 0
            stackHorizontal.distribution = .equalSpacing
            
            let titleTextView = CardPartTextView(type: .normal)
            titleTextView.text = "Use this position for home"
            titleTextView.textColor = K.Constants.kacagiderimColor
            stackHorizontal.addArrangedSubview(titleTextView)
            stackHorizontal.addArrangedSubview(homeChangeButton)
            
            let stackHorizontal2 = CardPartStackView(frame: CGRect.init(x: 0, y: 0, width: 200, height: 45))
            stackHorizontal2.axis = .horizontal
            stackHorizontal2.spacing = 0
            stackHorizontal2.distribution = .equalSpacing
            
            let titleTextView2 = CardPartTextView(type: .normal)
            titleTextView2.text = "Use this position for work"
            titleTextView2.textColor = K.Constants.kacagiderimColor
            stackHorizontal2.addArrangedSubview(titleTextView2)
            stackHorizontal2.addArrangedSubview(workChangeButton)
            
            let cardPartSeparatorView = CardPartSeparatorView()
            cardPartSeparatorView.frame = CGRect.init(x: 0, y: 0, width: 200, height: 1)
            stackVertical.addArrangedSubview(stackHorizontal)
            stackVertical.addArrangedSubview(cardPartSeparatorView)
            stackVertical.addArrangedSubview(stackHorizontal2)
            
            infoWindow.addSubview(stackVertical)
            infoWindow.center = mapView.projection.point(for: marker.position)
            infoWindow.center.y -= offsetClickMarker
        }
        else{
            infoWindow = UIView(frame: CGRect.init(x: 0, y: 0, width: 220, height: 75))
            let stackVertical = CardPartStackView(frame: CGRect.init(x: 10, y: 10, width: 200, height: 55))
            stackVertical.axis = .vertical
            stackVertical.spacing = 0
            stackVertical.distribution = .equalSpacing
            
            let titlePart = CardPartTitleView(type: .titleOnly)
            titlePart.label.text = marker.title
            
            let cardPartSeparatorView = CardPartSeparatorView()
            
            let descView = CardPartTextView(type: .normal)
            descView.text = marker.snippet
            stackVertical.addArrangedSubview(titlePart)
            stackVertical.addArrangedSubview(cardPartSeparatorView)
            stackVertical.addArrangedSubview(descView)
            infoWindow.addSubview(stackVertical)
            infoWindow.center = mapView.projection.point(for: marker.position)
            infoWindow.center.y -= offsetOtherMarker
        }
        
        infoWindow.backgroundColor = UIColor.white
        infoWindow.layer.cornerRadius = 10
        return infoWindow
    }
    
    @objc func setCurrentToHomeTapped(_ sender: UIButton){
        infoWindow.removeFromSuperview()
        homeMarker.position = clickMarker.position
        clickMarker.position = kCLLocationCoordinate2DInvalid;
        focusMapToShowAllMarkers()
    }
    
    @objc func setCurrentToWorkTapped(_ sender: UIButton){
        infoWindow.removeFromSuperview()
        workMarker.position = clickMarker.position
        clickMarker.position = kCLLocationCoordinate2DInvalid;
        focusMapToShowAllMarkers()
    }
    
    // MARK: - Actions
    
    @objc func didSaveTapped(sender: UIButton) {
        Utils.delayWithSeconds(0.5, completion: {
            var user = DefaultManager.getUser()
            if(user != nil){
                user?.homeLatitude = self.homeMarker.position.latitude
                user?.homeLongitude = self.homeMarker.position.longitude
                user?.workLatitude = self.workMarker.position.latitude
                user?.workLongitude = self.workMarker.position.longitude
                DefaultManager.setUser(user: user!)
                PopupHandler.successPopup(title: "Success", description: "Positions updated, please click save to persistent always.")
            }
            self.dismiss(animated: true, completion: nil)
        })
    }
    
    @objc func didCancelTapped(sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func btnZoomIn(_ sender: Any) {
        self.mapView.animate(with: GMSCameraUpdate.zoomIn())
    }
    
    @objc func btnZoomOut(_ sender: Any) {
        self.mapView.animate(with: GMSCameraUpdate.zoomOut())
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
    
    //MARK - custom info window
    //empty the default infowindow
    func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
        return UIView()
    }
    
    // reset custom infowindow whenever marker is tapped
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        tappedMarker = marker
        self.view.addSubview(constructCustomInfoWindow(marker:marker))
        
        // Remember to return false
        // so marker event is still handled by delegate
        return false
    }
    
    // let the custom infowindow follows the camera
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        let location = tappedMarker.position
        infoWindow.center = mapView.projection.point(for: location)
        if(tappedMarker == clickMarker){
            infoWindow.center.y -= offsetClickMarker
        }
        else{
            infoWindow.center.y -= offsetOtherMarker
        }
    }
    
    // take care of the close event
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        infoWindow.removeFromSuperview()
        clickMarker.position = coordinate
    }
}
