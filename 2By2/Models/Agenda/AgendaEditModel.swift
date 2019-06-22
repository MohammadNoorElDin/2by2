//
//  AgendaEditModel.swift
//  2By2
//
//  Created by mac on 10/28/18.
//  Copyright © 2018 personal. All rights reserved.
//

import UIKit
import SwiftyJSON

class AgendaEditModel {
    
    static let className = MainAgendaModel.className + "edit"
    
    struct params {
        static let Fk_AgnedaTimeFrame = "Fk_AgnedaTimeFrame"
        static let TimeFrom = "TimeFrom"
        static let TimeTo = "TimeTo"
        static let Date = "Date"
    }
}


extension AgendaEditModel {
   
    class func AgendaModifyRequest(object: UIViewController, params: [ String : Any ], completion: @escaping (_ data: JSON?, _ error: Bool?) -> ()) {
        
        APIRequests.sendJSONRequest(method: .post, url: AgendaEditModel.className, params: params, object: object) { (dic, error) in
            
            if error == true {
                // ERROR
                completion(nil, true)
            }else {
                // SUCCESS
                print("yes yes yes")
                completion(dic, false)
            }
            
        }
    }
    
}
