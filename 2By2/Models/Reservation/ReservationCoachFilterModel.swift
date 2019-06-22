//
//  ReservationGetPrograms.swift
//  theGymApp
//
//  Created by mac on 10/23/18.
//  Copyright © 2018 personal. All rights reserved.
//

import Foundation
import SwiftyJSON

class ReservationCoachFilterModel {
    
    static let className = mainReservationModel.className + "CoachFilter"
    
    struct returnData {
        
    }
    
    struct Params {
        static let Fk_SecondCategoryProgram = "Fk_SecondCategoryProgram"
        static let Longitude = "Longitude"
        static let Date = "Date"
        static let Latitude = "Latitude"
        static let Fk_Language = "Fk_Language"
        static let Fk_Gender = "Fk_Gender"
    }
    
}

extension ReservationCoachFilterModel {
    
    class func filterCoaches(object: UIViewController, params: [String: Any], completion: @escaping (_ data: JSON?, _ error: Bool?) -> ()) {
        
        APIRequests.sendRequestArrayBack(method: .post, url: ReservationCoachFilterModel.className, params: params, object: object) { (dic, error) in
            if true == error {
                completion(dic, true)
            }else {
                completion(dic, false)
            }
        }
    }
}
