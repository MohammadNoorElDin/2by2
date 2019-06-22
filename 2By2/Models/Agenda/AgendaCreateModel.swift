//
//  AgendaCreateModel.swift
//  2By2
//
//  Created by mac on 10/28/18.
//  Copyright © 2018 personal. All rights reserved.
//

import UIKit
import SwiftyJSON

class AgendaCreateModel {
    
    static let className = MainAgendaModel.className + "create"
    
    struct params {
        
        static let Fk_Coach = "Fk_Coach"
        
        struct AgnedaTimeFrames {
            static let structName = "AgnedaTimeFrames"
            static let TimeFrom = "TimeFrom"
            static let TimeTo = "TimeTo"
            static let Date = "Date"
        }
       
    }
    
}

extension AgendaCreateModel {
    
    class func AgendaCreateRequest(object: UIViewController, params: [ String : Any ], completion: @escaping (_ data: JSON?, _ error: Bool?) -> ()) {
        
        APIRequests.sendJSONRequest(method: .post, url: AgendaCreateModel.className, params: params, object: object) { (dic, error) in
            
            if error == true {
                // ERROR
                completion(nil, true)
            }else {
                // SUCCESS
                completion(dic, false)
            }
            
        }
    }
    
}
