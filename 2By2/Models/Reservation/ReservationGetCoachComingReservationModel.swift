//
//  ReservationGetCoachComingReservationModel.swift
//  2By2
//
//  Created by rocky on 1/2/19.
//  Copyright © 2019 personal. All rights reserved.
//

import UIKit
import SwiftyJSON

class ReservationGetCoachComingReservationModel {
    
    static let className = mainReservationModel.className + "GetCoachComingReservation"
    
    
}

class ReservationGetCoachPastReservationModel {
    
    static let className = mainReservationModel.className + "GetCoachPastReservation"
    
    
}

extension ReservationGetCoachComingReservationModel {
    
    class func GetCoachComingReservation(object: UIViewController, completion: @escaping (_ data: JSON?, _ error: Bool?) -> ()) {
        
        let params = ["FK_Coach": CoachDataUsedThroughTheApp.coachId /* 41 */ ]
        
        APIRequests.sendRequestArrayBack(method: .get, url: ReservationGetCoachComingReservationModel.className , params: params, object: object) { (dic, error) in
            
            if true == error {
                completion(dic, true)
            }else {
                completion(dic, false)
            }
        }
    }

}

extension ReservationGetCoachPastReservationModel {
    
    class func GetCoachPastReservation(object: UIViewController, completion: @escaping (_ data: JSON?, _ error: Bool?) -> ()) {
        
        let params = ["FK_Coach": CoachDataUsedThroughTheApp.coachId /*43*/ ]
        
        APIRequests.sendRequestArrayBack(method: .get, url: ReservationGetCoachPastReservationModel.className , params: params, object: object) { (dic, error) in
            
            if true == error {
                completion(dic, true)
            }else {
                completion(dic, false)
            }
        }
    }
    
}
