//
//  File.swift
//  2By2
//
//  Created by rocky on 1/24/19.
//  Copyright © 2019 personal. All rights reserved.
//

import UIKit
import SwiftyJSON

class CoachGetLocation {
    
    static let className = MainCoachModel.className + "GetLocation"
    
    class func CoachHomeRequest(object: UIViewController, params: [String: Any], completion: @escaping (_ data: [String: JSON], _ error: Bool?) -> ()) {
        
        APIRequests.sendRequest(method: .get, url: CoachGetLocation.className, params: params, object: object) { (dic, error) in
            
            if error == false {
                completion(dic, false)
            }else {
                completion(dic, true)
            }
            
        }
        
    }
}

