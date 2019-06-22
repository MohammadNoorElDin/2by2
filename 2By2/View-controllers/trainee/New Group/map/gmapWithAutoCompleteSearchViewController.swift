//
//  gmapWithAutoCompleteSearchViewController.swift
//  trainee
//
//  Created by rocky on 1/21/19.
//  Copyright © 2019 personal. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces

class gmapWithAutoCompleteSearchViewController: UIViewController, GMSAutocompleteViewControllerDelegate, CLLocationManagerDelegate, GMSMapViewDelegate {
   
    @IBOutlet weak var googleMapsView: GMSMapView!
    var searchResultController: UISearchBar!
    var gmsFetcher: GMSAutocompleteFetcher!
    var locationManager = CLLocationManager()
    
    var zoomlevel: Float = 15
    var latitiude: CLLocationDegrees!
    var longitude: CLLocationDegrees!
    var bookingModel: BookingDataModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //Location Manager code to fetch current location
        self.locationManager.delegate = self
        self.locationManager.startUpdatingLocation()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        googleMapsView.isMyLocationEnabled = true
        // googleMapsView.isTrafficEnabled = true
        // googleMapsView.isIndoorEnabled = true
        googleMapsView.animate(toZoom: self.zoomlevel)
        
        if let current = googleMapsView.myLocation?.coordinate {
            googleMapsView.animate(toLocation: current)
        }
        updateBookingLocation(googleMapsView.camera)
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
 
    @IBAction func searchWithAddress(_ sender: AnyObject) {
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        present(autocompleteController, animated: true, completion: nil)
    }
    
    // Handle the user's selection.
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
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
    /**
     Locate map with longitude and longitude after search location on UISearchBar
     
     - parameter lon:   longitude location
     - parameter lat:   latitude location
     - parameter title: title of address location
     */
    func locateWithLongitude(_ lon: CLLocationDegrees, andLatitude lat: CLLocationDegrees, andTitle title: String) {
        DispatchQueue.main.async { () -> Void in
            
            let camera = GMSCameraPosition.camera(withLatitude: lat, longitude: lon, zoom: self.zoomlevel)
            self.googleMapsView.camera = camera
        }
    }
 
    //Location Manager delegates
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location = locations.last
        locateWithLongitude((location?.coordinate.longitude)!, andLatitude: (location?.coordinate.latitude)!, andTitle: "")
        
        //Finally stop updating location otherwise it will come again and again in this delegate
        self.locationManager.stopUpdatingLocation()
        
    }
    
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        updateBookingLocation(position)
    }
    
    func updateBookingLocation(_ camera: GMSCameraPosition) {
        self.bookingModel.latitude = camera.target.latitude
        self.bookingModel.lngitude = camera.target.longitude
    }
    
    @IBAction func confirmClicked(_ sender: UIButton) {
        
        if self.bookingModel.isFree == true || bookingModel.isModifyingPrograms == true {
            if self.bookingModel.availableSessions == 0 {
                self.bookingModel.availableSessions = 1
            }
            
            if let nextViewController = MoveToStoryBoard.moveTo(sb: MoveToStoryBoard.trainee_home, storyBoardId: "toaboutTraineeViewController") as? AboutTraineeViewController {
                
                nextViewController.bookingModel = self.bookingModel
                self.navigationController?.pushViewController(nextViewController, animated: true)
            }
        }else {
            performSegue(withIdentifier: segueIdentifier.toPickYourPackageSegue, sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == segueIdentifier.toPickYourPackageSegue {
            if let dest = segue.destination as? ChoosePackageViewController {
                dest.bookingModel = self.bookingModel
            }
        }
    }
    
    @IBAction func getToMYLocation(_ sender: UIButton) {
        if let current = self.googleMapsView.myLocation?.coordinate {
            locateWithLongitude(current.longitude, andLatitude: current.latitude, andTitle: "")
        }
    }
    
}


