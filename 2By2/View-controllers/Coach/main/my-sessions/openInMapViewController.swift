//
//  openInMapViewController.swift
//  2By2
//
//  Created by rocky on 1/12/19.
//  Copyright © 2019 personal. All rights reserved.
//

import UIKit
import GoogleMaps

import MapKit

class openInMapViewController: UIViewController {

    var Slat: CLLocationDegrees!
    var Slng: CLLocationDegrees!
    var Dlat: CLLocationDegrees? = nil
    var Dlng: CLLocationDegrees? = nil
    var MapTitle: String? = nil
    
    
    // current user location
    var locationManager = CLLocationManager()
    var currentLocation: CLLocation?
    var mapView: GMSMapView!
    var zoomLevel: Float = 15.0
    

    override func viewDidLoad() {
        super.viewDidLoad()

        self.userCurrentLocation()
        
        let currentLat = locationManager.location?.coordinate.latitude ?? 26.8206
        let currentLng = locationManager.location?.coordinate.longitude ?? 30.8025
        
        let camera = GMSCameraPosition.camera(withLatitude: currentLat, longitude: currentLng, zoom: zoomLevel)
        
        let source = CLLocationCoordinate2D(latitude: currentLat, longitude: currentLng)
        let destination = CLLocationCoordinate2D(latitude: 30.965820, longitude: 31.161317)
        
        mapView = GMSMapView.map(withFrame: view.bounds, camera: camera)
        mapView.settings.myLocationButton = true
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        //mapView.isMyLocationEnabled = true
        self.createMarker(lat: currentLat, lng: currentLng, addTitle: self.MapTitle ?? "")
        self.createMarker(lat: 30.965820, lng: 31.161317, addTitle: "")
        // Add the map to the view, hide it until we've got a location update.
        let path = GMSMutablePath()
        path.add(source)
        path.add(destination)
        let polyline = GMSPolyline(path: path)
        polyline.strokeWidth = 5.0
        polyline.strokeColor = Theme.setColor()
        polyline.map = mapView
        polyline.isTappable = false
        
        view.addSubview(mapView)
        mapView.isHidden = true
        
    }

   
    func userCurrentLocation() {
        
        locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.distanceFilter = 50
        locationManager.startUpdatingLocation()
        locationManager.delegate = self
        // placesClient = GMSPlacesClient.shared()
        
    }
    
}

extension openInMapViewController: CLLocationManagerDelegate {
    
    // Handle incoming location events.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location: CLLocation = locations.last!
        print("Location: \(location)")
        
        let camera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude,
                                              longitude: location.coordinate.longitude,
                                              zoom: zoomLevel)
        
        if mapView.isHidden {
            mapView.isHidden = false
            mapView.camera = camera
        } else {
            mapView.animate(to: camera)
        }
    }
    
    // Handle authorization for the location manager.
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .restricted:
            print("Location access was restricted.")
        case .denied:
            print("User denied access to location.")
            // Display the map using the default location.
            mapView.isHidden = false
        case .notDetermined:
            print("Location status not determined.")
        case .authorizedAlways: fallthrough
        case .authorizedWhenInUse:
            print("Location status is OK.")
        }
    }
    
    // Handle location manager errors.
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationManager.stopUpdatingLocation()
        print("Error: \(error)")
    }
    
    
    func createMarker(lat: CLLocationDegrees, lng: CLLocationDegrees, addTitle: String) {

        let position = CLLocationCoordinate2D(latitude: lat, longitude: lng)
        let marker = GMSMarker(position: position)
        if addTitle.isEmpty == false {
            
        }else {
            marker.title = addTitle
        }
        marker.map = mapView
        
    }
    

}
