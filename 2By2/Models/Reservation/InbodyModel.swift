//
//  InbodyModel.swift
//  2By2
//
//  Created by rocky on 2/1/19.
//  Copyright © 2019 personal. All rights reserved.
//

import SwiftyJSON
import UIKit

class InbodyModel {
    
    static let className = mainReservationModel.className + "GetInbodySessions"
    
    struct params {
        static let Fk_User = "Fk_User"
    }
    
    class AddUserInbody {
        
        static let className = mainReservationModel.className + "AddUserInbody"
        
        struct params {
            static let Fk_User = "Fk_User"
            static let Fk_Inbody = "Fk_Inbody"
            static let Fk_Gift = "Fk_Gift"
            
        }
    }
    
}

extension InbodyModel {
    
    class func GetInbodySessions(object: UIViewController, completion: @escaping (_ data: [String: JSON], _ error: Bool?) -> ()) {
        
        let params = ["FK_User": UserDataUsedThroughTheApp.userId]
        APIRequests.sendRequest(method: .get, url: InbodyModel.className, params: params, object: object) { (dic, error) in
            
            if error == false {
                completion(dic, false)
            }else {
                completion(dic, true)
            }
            
        }
        
    }
}

extension InbodyModel.AddUserInbody {
    
    class func AddUserInbody(object: UIViewController, params: [String: Any], completion: @escaping (_ data: [String: JSON], _ error: Bool?) -> ()) {
        
        APIRequests.sendRequest(method: .post, url: InbodyModel.AddUserInbody.className, params: params, object: object) { (dic, error) in
            
            if error == false {
                completion(dic, false)
            }else {
                completion(dic, true)
            }
            
        }
        
    }
}
