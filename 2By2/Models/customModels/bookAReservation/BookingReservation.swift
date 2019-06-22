//
//  BookingReservation.swift
//  2By2
//
//  Created by rocky on 12/12/18.
//  Copyright © 2018 personal. All rights reserved.
//

import UIKit

class BookingReservation {
    
    static var latitude: Double = 0.0
    static var lngitude: Double = 0.0
    static var picked: Int = 0 // COACH ID
    static var Fk_PackagePersonRangePrice: Int = 0 // COACH ID
    static var Package_Name: String = "" // PACKAGE NAME 
    static var FK_Agenda = [Int]()
    static var Second_Category_Program: Int = 0 // COACH ID
    static var Second_Category_Program_Name: String = "" // COACH NAME
    static var availableSessions: Int = 0 // COACH ID
    
    static var deleteReservationId: Int = 0
    static var timeWhichNeedsToBeUpdated: String = ""
    static var dateWhichNeedsToBeUpdated: String = ""
    
    static var coachName: String = ""
    static var coachImage: String = ""
    static var friends = [FriendsInfo]()
    static var packagePrice: Int = 0 
    
    static var isFree: Bool = false
    static var isDuplicate: Bool = false 
    
    static var isModifyingPrograms: Bool = false
    
    class func addCoordinates(lat: Double, lng: Double) {
        BookingReservation.latitude = lat
        BookingReservation.lngitude = lng
    }
}
