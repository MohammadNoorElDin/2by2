//
//  UserCheckPhone.swift
//  2By2
//
//  Created by rocky on 1/14/19.
//  Copyright © 2019 personal. All rights reserved.
//

import UIKit
import SwiftyJSON

class UserCheckPhoneModel {
    
    static let className: String = MainUserModel.className + "CheckPhone"
    
    class func checkPhone(object: UIViewController, params: [String: Any], completion: @escaping (_ data: [String: JSON], _ error: Bool?) -> ()) {
        
        APIRequests.sendPhoneRequest(method: .post, url: UserCheckPhoneModel.className, params: params, object: object) { (dic, error) in
            
            if error == false {
                completion(dic, false)
            }else {
                completion(dic, true)
            }
            
        }
        
    }
    
}


class CoachCheckPhoneModel {
    
    static let className: String = MainCoachModel.className + "CheckPhone"
    
    class func checkPhone(object: UIViewController, params: [String: Any], completion: @escaping (_ data: [String: JSON], _ error: Bool?) -> ()) {
        
        APIRequests.sendPhoneRequest(method: .post, url: CoachCheckPhoneModel.className, params: params, object: object) { (dic, error) in
            
            if error == false {
                completion(dic, false)
            }else {
                completion(dic, true)
            }
            
        }
        
    }
    
}
