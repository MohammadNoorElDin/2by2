//
//  ReservationRateModel.swift
//  2By2
//
//  Created by rocky on 1/13/19.
//  Copyright © 2019 personal. All rights reserved.
//

import UIKit
import SwiftyJSON

class ReservationRateModel {
    
    static let className = mainReservationModel.className + "UpdateRate"
       
    class func updateRate(object: UIViewController, params: [String: Any], completion: @escaping (_ data: [String: JSON], _ error: Bool?) -> ()) {
        
        APIRequests.sendRequest(method: .post, url: ReservationRateModel.className, params: params, object: object) { (dic, error) in
            
            if error == false {
                completion(dic, false)
            }else {
                completion(dic, true)
            }
            
        }
        
    }
        
    
}

