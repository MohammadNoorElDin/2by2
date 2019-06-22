//
//  AgendaGetAgendaModel.swift
//  2By2
//
//  Created by mac on 10/28/18.
//  Copyright © 2018 personal. All rights reserved.
//

import UIKit
import SwiftyJSON

class AgendaGetAgendaModel {
    
    static let className = MainAgendaModel.className + "getAgendaTimeFrames"
    
    struct params {
        static let Fk_Coach = "Fk_Coach"
    }
    struct returnData {
        struct Data {
            static let structName = "Data"
            static let Fk_AgnedaTimeFrame = "Fk_AgnedaTimeFrame"
            static let From = "From"
            static let To = "To"
        }
    }
}


extension AgendaGetAgendaModel {
    
    class func AgendaGetAgendaRequest(object: UIViewController, completion: @escaping (_ data: JSON?, _ error: Bool?) -> ()) {
        
        let params = [AgendaGetAgendaModel.params.Fk_Coach: CoachDataUsedThroughTheApp.coachId  ]
        APIRequests.sendRequestArrayBack(method: .get, url: AgendaGetAgendaModel.className, params: params, object: object) { (dic, error) in
            
            if error == false {
                completion(dic, false)
            }else {
                completion(dic, true)
            }
        }
    }
}
