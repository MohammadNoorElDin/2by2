//
//  ReservationGetCoachAgenda.swift
//  2By2
//
//  Created by rocky on 12/17/18.
//  Copyright © 2018 personal. All rights reserved.
//

import UIKit
import SwiftyJSON

class ReservationGetCoachAgendaModel {
    
    static let className = mainReservationModel.className + "GetCoachAgenda"
    
    struct params {
        static let Fk_Coach = "Fk_Coach"
        static let Fk_User = "Fk_User"
    }
    
}

extension ReservationGetCoachAgendaModel {
    
    class func GetCoachAgenda(object: UIViewController, params: [String: Any], completion: @escaping (_ data: [String: JSON], _ error: Bool?) -> ()) {
        
        APIRequests.sendRequest(method: .get, url: ReservationGetCoachAgendaModel.className, params: params, object: object) { (dic, error) in
            
            if error == false {
                completion(dic, false)
            }else {
                completion(dic, true)
            }
            
        }
        
    }
}
