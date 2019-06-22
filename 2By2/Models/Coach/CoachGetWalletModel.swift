//
//  CoachGetWalletModel.swift
//  2By2
//
//  Created by mac on 10/28/18.
//  Copyright © 2018 personal. All rights reserved.
//

import UIKit
import SwiftyJSON

class CoachGetWalletModel {
    
    static let className = MainCoachModel.className + "GetWallet"
    
    struct Params {
        static let Fk_Coach = "Fk_Coach"
    }
    
    struct returnData {
        
        struct ReservationsInfo {
            static let structName = "ReservationsInfo"
            static let TotalPrice = "TotalPrice"
            static let Satus = "Satus"
            static let ModifiedAt = "ModifiedAt"
        }
        static let TotalCredit = "TotalCredit"
        static let SessionsCount = "SessionsCount"
        static let Pending = "Pending"
        static let Dueto = "Dueto"
    }
    
    
}

extension CoachGetWalletModel {
    
    class func CoachGetWallet(object: UIViewController, params: [String: Any], completion: @escaping (_ data: [String: JSON], _ error: Bool?) -> ()) {
        
        APIRequests.sendRequest(method: .post, url: CoachGetWalletModel.className, params: params, object: object) { (dic, error) in
            
            if error == false {
                completion(dic, false)
            }else {
                completion(dic, true)
            }
            
        }
    }
}
