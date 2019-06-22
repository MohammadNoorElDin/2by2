//
//  UserMeasurements.swift
//  theGymApp
//
//  Created by mac on 10/23/18.
//  Copyright © 2018 personal. All rights reserved.
//

import UIKit
import SwiftyJSON

class UserMeasurementsModel {
    
    static let className = MainUserModel.className + "GetMeasurements"
    
    struct params {
        static let Fk_User = "Fk_User"
    }
    
    struct returnData {
        static let Fat = "Fat"
        static let Muscles = "Muscles"
        static let Weight = "Weight"
        static let Height = "Height"
        static let Date = "Date"
    }
    
}

extension UserMeasurementsModel {
    
    class func UserGetMeasurementsRequest(object: UIViewController, completion: @escaping (_ data: JSON?, _ error: Bool?) -> ()) {
        
        let params = [UserMeasurementsModel.params.Fk_User: UserDataUsedThroughTheApp.userId ]
        
        APIRequests.sendRequestArrayBack(method: .get, url: UserMeasurementsModel.className, params: params, object: object) { (dic, error) in
            if true == error {
                completion(dic, true)
            }else {
                completion(dic, false)
            }
        }
    }
    
}
