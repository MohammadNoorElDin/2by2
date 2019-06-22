//
//  traineeMapViewController.swift
//  trainee
//
//  Created by rocky on 12/9/18.
//  Copyright © 2018 personal. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import Alamofire
import SwiftyJSON

class traineeMapViewController: UIViewController, CLLocationManagerDelegate, GMSMapViewDelegate {
    
   @IBOutlet weak var googleMapsView: GMSMapView!
    @IBOutlet weak var btn: UIButton!
    
    var locationManager = CLLocationManager()
    var zoomlevel: Float = 16
    var pos: CLLocationCoordinate2D!
    var trackCoach: String!
    var timer =  Timer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //Location Manager code to fetch current location
        self.locationManager.delegate = self
        self.locationManager.startUpdatingLocation()
        self.title = self.trackCoach
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        //googleMapsView.isMyLocationEnabled = true
        // googleMapsView.isTrafficEnabled = true
        // googleMapsView.isIndoorEnabled = true
        googleMapsView.animate(toZoom: self.zoomlevel)
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
        
        if let current = self.locationManager.location?.coordinate {
            self.googleMapsView.animate(toLocation: current)
            self.draw(src: self.pos, dst: current)
        }
        
        self.timer = Timer.scheduledTimer(withTimeInterval: 10, repeats: true) { (timer) in
            if let current = self.locationManager.location?.coordinate {
                self.googleMapsView.animate(toLocation: current)
                self.draw(src: self.pos, dst: current)
            }
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        self.timer.invalidate()
    }
    
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
    
    func draw(src: CLLocationCoordinate2D, dst: CLLocationCoordinate2D){
        
        let url = "https://maps.googleapis.com/maps/api/directions/json?origin=\(src.latitude),\(src.longitude)&destination=\(dst.latitude),\(dst.longitude)&sensor=false&mode=driving&key=\(Constants.GMK_TRACK)"
        
        Alamofire.request(url, method: .get, parameters: [:], encoding: URLEncoding.default, headers: nil)
            .validate(statusCode: 200..<300)
            .responseJSON { (response) in
                switch response.result {
                    
                case .success(let data) :
                    let json = JSON(data)
                    let routes = json["routes"].array!
                    
                    self.googleMapsView.clear()
                    
                    OperationQueue.main.addOperation({
                        
                        for route in routes
                        {
                            let routeOverviewPolyline = route["overview_polyline"].dictionary!
                            let points = routeOverviewPolyline["points"]?.string!
                            let path = GMSPath.init(fromEncodedPath: points!)
                            let polyline = GMSPolyline.init(path: path)
                            polyline.strokeWidth = 3
                            polyline.strokeColor = Theme.setColor()
                            let bounds = GMSCoordinateBounds(path: path!)
                            self.googleMapsView.animate(with: GMSCameraUpdate.fit(bounds, withPadding: 30.0))
                            polyline.map = self.googleMapsView
                            let marker = GMSMarker()
                            marker.position = src
                            marker.iconView = UIImageView(image: UIImage(named: "Christmas_-_Celebrate"))
                        }
                    })
                    
                    let text = "   Estimated time to arrive : " + json["routes"][0]["legs"][0]["duration"]["text"].string!
                    self.btn.setTitle(text, for: .normal)
                    self.btn.titleLabel?.sizeToFit()
                    
                case .failure(let noData) :
                    print("Error found \(noData)")
                } // END OF THE SWITCH CASE
                
        } // END OF THE COMPLETION
       
        
        
    }
    
    
}

