//
//  ReservationInstallmentModel.swift
//  2By2
//
//  Created by rocky on 1/19/19.
//  Copyright © 2019 personal. All rights reserved.
//

import UIKit
import SwiftyJSON

class ReservationInstallmentModel {
    static let className = mainReservationModel.className + "ReservationInstallment"
    
    class func paymyinstallmentRequest(object: UIViewController, params: [String: Any], completion: @escaping (_ data: JSON?, _ error: Bool?) -> ()) {
        
        APIRequests.sendRequest(method: .post, url: ReservationInstallmentModel.className, params: params, object: object) { (response, error) in
            if error == false {
                completion([:], false)
            } else {
                completion([:], true)
            }
        }
    }
    
}


