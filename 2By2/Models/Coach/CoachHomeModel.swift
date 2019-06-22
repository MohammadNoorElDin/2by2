//
//  CoachHomeModel.swift
//  2By2
//
//  Created by mac on 10/28/18.
//  Copyright © 2018 personal. All rights reserved.
//

import Foundation
import SwiftyJSON

class CoachHomeModel {
    
    static let className = MainCoachModel.className + "home"
    
    struct Params {
        static let Fk_Coach = "Fk_Coach"
    }
    
    struct returnData {
        struct Notification {
            static let structName = "Notification"
            static let Id = "Id"
            static let Title = "Title"
            static let Description = "Description"
            
            struct NotificationType {
                static let structName = "NotificationType"
                static let Id = "Id"
                static let Name = "Name"
            }
            
            struct AgendaDates {
                static let structName = "AgendaDates"
                static let Date = "Date"
                static let RowCount = "RowCount"
                struct Agendas {
                    static let structName = "Agendas"
                    static let IsReserved = "IsReserved"
                }
                
            }
        }
    }
}

extension CoachHomeModel {
    
    class func CoachHomeRequest(object: UIViewController, params: [String: Any], completion: @escaping (_ data: [String: JSON], _ error: Bool?) -> ()) {
        
        APIRequests.sendRequest(method: .get, url: CoachHomeModel.className, params: params, object: object) { (dic, error) in
            
            if error == false {
                completion(dic, false)
            }else {
                completion(dic, true)
            }
            
        }
        
    }
}
