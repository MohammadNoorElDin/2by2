//
//  homeCoachViewController.swift
//  2By2
//
//  Created by rocky on 3/2/1440 AH.
//  Copyright © 1440 AH personal. All rights reserved.
//

import UIKit
import SideMenuSwift
import SwiftyJSON
import SDWebImage
import OneSignal
import GoogleMaps

class homeCoachViewController: UIViewController, GMSMapViewDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var notificationCoachName: UILabel!
    @IBOutlet weak var notificationShift: UILabel!
    @IBOutlet weak var notificationDesc: UILabel!
    @IBOutlet weak var notification2By2: UILabel!
    @IBOutlet weak var profileImage: UIButton!

    let contentCellIdentifier: String = "ContentCellIdentifier"
    let ContentCollectionViewCell: String = "ContentCollectionViewCell"
    
    var arrayOfDates = [String]()
    var arrayOfDatesNames = [String]()
    var usedBefore: Bool = false  // INT : ROW [INT (COLUMN) ]
    
    var rows : Int = 1
    var agendaDates = [JSON]()
    var rowCloumn = [String:Int]()
    var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dayNamesAndDates()
        
        collectionView.register(UINib(nibName: "ContentCollectionViewCell", bundle: nil),
                                forCellWithReuseIdentifier: contentCellIdentifier)

        // collectionView.allowsSelection = false
        let color = UIColor(rgb: 0xF7F7F7).withAlphaComponent(0.0)
        
        collectionView.layer.borderWidth = 10
        collectionView.layer.borderColor = color.cgColor
        
        self.sideMenuController?.cache(viewControllerGenerator: { self.storyboard?.instantiateViewController(withIdentifier: "coachagendaView") }, with: "coach-agenda")
        self.sideMenuController?.cache(viewControllerGenerator: { self.storyboard?.instantiateViewController(withIdentifier: "coachsessionView") }, with: "coach-session")
        
        self.CloseOldReservation()
        
        self.locationManager.delegate = self
        startReceivingSignificantLocationChanges()
        
    }
    
    func CloseOldReservation() {
        ReservationCloseOldReservationModel.closeRequest(object: self) { (response, error) in
            if error == false {
                print("done!!!!")
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.sideMenuController?.cache(viewControllerGenerator: { self.storyboard?.instantiateViewController(withIdentifier: "coachprofileView") }, with: "coach-profile")
        
        fetchCoachDataHome()
        displayUserProfileImage()
        displayMessage()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        self.rowCloumn.removeAll()
    }
    
    @IBAction func imageClicked(_ sender: UIButton) {
        self.sideMenuController?.setContentViewController(with: "coach-profile")
    }
    
    @IBAction func openSideMenu(_ sender: UIBarButtonItem) {
        self.sideMenuController?.revealMenu()
    }
    
    func displayUserProfileImage() {
        let imagePath = CoachDataUsedThroughTheApp.coachImage
        self.profileImage.findMe(url: imagePath)
        self.profileImage.radiusButtonImage()
    }
    
}


extension homeCoachViewController : CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if let location = locations.last {
            let lat = location.coordinate.latitude
            let lng = location.coordinate.longitude
            let params = [
                "Longitude": lng,
                "latitude": lat,
                "Id": CoachDataUsedThroughTheApp.coachId,
            ] as [String: Any]
            
            CoachEditModel.CoachEditProfileRequest(object: self, params: params) { (response, error) in
                if error == false {
                    print("location updated successfully")
                }
            }
        }
    }
    
    func startReceivingSignificantLocationChanges() {

        let authorizationStatus = CLLocationManager.authorizationStatus()
        if authorizationStatus != .authorizedAlways {
            // User has not authorized access to location information.
            return
        }
        
        if !CLLocationManager.significantLocationChangeMonitoringAvailable() {
            // The service is not available.
            return
        }
        // locationManager.delegate = self
        locationManager.startMonitoringSignificantLocationChanges()
        
    }
}

