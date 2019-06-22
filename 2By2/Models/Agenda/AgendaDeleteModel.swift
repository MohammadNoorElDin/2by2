//
//  AgendaDeleteModel.swift
//  2By2
//
//  Created by mac on 10/28/18.
//  Copyright © 2018 personal. All rights reserved.
//

import UIKit
import SwiftyJSON

class AgendaDeleteModel {

    static let className = MainAgendaModel.className + "delete"

    struct params {
        static let Fk_AgnedaTimeFrame = "Fk_AgnedaTimeFrame"
    }
}

extension AgendaDeleteModel {
    
    class func AgendaDeleteRequest(object: UIViewController, params: [ String : Any ], completion: @escaping (_ data: JSON?, _ error: Bool?) -> ()) {
        
        APIRequests.sendRequestArrayBack(method: .post, url: AgendaDeleteModel.className, params: params, object: object) { (dic, error) in
            if error == false { completion(dic, false) } else { completion(dic, true) }
        }
        
    }
    
}
