//
//  editLocation.swift
//  2by2
//
//  Created by Mohammad Noor El Din on 6/18/19.
//  Copyright © 2019 personal. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces

class editLocation: UIViewController, GMSAutocompleteViewControllerDelegate, CLLocationManagerDelegate, GMSMapViewDelegate {
   
    @IBOutlet weak var googleMapsView: GMSMapView!
    var searchResultController: UISearchBar!
    var gmsFetcher: GMSAutocompleteFetcher!
    var locationManager = CLLocationManager()
    var booking:BookingDataModel!
    var zoomlevel: Float = 15
    var latitiude: CLLocationDegrees!
    var longitude: CLLocationDegrees!
    var Fk_ReservationInfo : Int!
    
    override func viewDidLoad() {
        self.locationManager.delegate = self
        let cam = GMSCameraPosition.camera(withLatitude: booking.latitude, longitude: booking.lngitude, zoom: zoomlevel)
        self.googleMapsView.camera = cam
       // self.locationManager.startUpdatingLocation()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        googleMapsView.isMyLocationEnabled = true
        googleMapsView.animate(toZoom: self.zoomlevel)
        
        if let current = googleMapsView.myLocation?.coordinate {
            googleMapsView.animate(toLocation: current)
        }
        //updateBookingLocation(googleMapsView.camera)
        updateLocation(googleMapsView.camera)
        googleMapsView.delegate = self
        
        do {
            // Set the map style by passing the URL of the local file.
            if let styleURL = Bundle.main.url(forResource: "resource", withExtension: "geojson") {
                googleMapsView.mapStyle = try GMSMapStyle(contentsOfFileURL: styleURL)
            } else {
                NSLog("Unable to find style.json")
            }
        } catch {
            NSLog("One or more of the map styles failed to load. \(error)")
        }
    }
    
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    func locateWithLongitude(_ lon: CLLocationDegrees, andLatitude lat: CLLocationDegrees, andTitle title: String) {
        DispatchQueue.main.async { () -> Void in
            
            let camera = GMSCameraPosition.camera(withLatitude: lat, longitude: lon, zoom: self.zoomlevel)
            self.googleMapsView.camera = camera
        }
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location = locations.last
        locateWithLongitude((location?.coordinate.longitude)!, andLatitude: (location?.coordinate.latitude)!, andTitle: "")
        
        //Finally stop updating location otherwise it will come again and again in this delegate
        self.locationManager.stopUpdatingLocation()
        
    }
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        updateLocation(position)
        
    }
    @IBAction func confirmCliked(_ sender: Any) {
        let params = ["Fk_ReservationInfo":self.Fk_ReservationInfo,
                      "Latitude":self.latitiude,
                      "Longitude":self.longitude] as [String:Any]
        APIRequests.sendJSONRequest(method: .post, url: "https://webservice.2by2club.com/Reservation/EditLocation", params: params, object: self) { (resp, error) in
            if error != true {
                if resp?["Data"].bool == true {
                    Alerts.DisplayDefaultAlertWithActions(title: "Done", message: "your Sesstion Loaction Has Been Updated", object: self, buttons: ["Okey":.default], actionType: .default, completion: { (button) in
                        if button == "Okey" {
                           self.dismiss(animated: true, completion: nil)
                        }
                    })
                }
                else {
                    let serverMassage = resp?["Status"]["Message"].string ?? ""
                    Alerts.DisplayDefaultAlertWithActions(title: "error", message: serverMassage, object: self, buttons: ["Okey":.default], actionType: .default, completion: { (button) in
                        if button == "Okey" {
                            self.dismiss(animated: true, completion: nil)
                        }
                    })
                }
            }
            else {
                print ("error in requset")
                print(resp)
            }
        }
    }
    
    @IBAction func searchByLocationName(_ sender: Any) {
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        present(autocompleteController, animated: true, completion: nil)
    }
    @IBAction func getMyLocationPressed(_ sender: Any) {
        if let current = self.googleMapsView.myLocation?.coordinate {
            locateWithLongitude(current.longitude, andLatitude: current.latitude, andTitle: "")
        }
    }
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        dismiss(animated: true) {
            self.locateWithLongitude(place.coordinate.longitude, andLatitude: place.coordinate.latitude, andTitle: place.name)
        }
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    
    // User canceled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
    func updateLocation (_ camera: GMSCameraPosition) {
        self.latitiude = camera.target.latitude
        self.longitude = camera.target.longitude
        print(self.longitude)
        print(self.latitiude)
        print(self.Fk_ReservationInfo)
    }
    @IBAction func backPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
