//
//  ReservationCloseOldReservationModel.swift
//  2By2
//
//  Created by rocky on 1/13/19.
//  Copyright © 2019 personal. All rights reserved.
//

import UIKit
import SwiftyJSON

class ReservationCloseOldReservationModel {
    
    static let className = mainReservationModel.className + "CloseOldReservation"
    
    class func closeRequest(object: UIViewController, completion: @escaping (_ data: JSON?, _ error: Bool?) -> ()) {
        
        APIRequests.sendRequest(method: .get, url: ReservationCloseOldReservationModel.className, params: nil, object: object) { (response, error) in
            if error == false {
                completion([:], false)
            }else {
                completion([:], true)
            }
        }
    }
    
}
