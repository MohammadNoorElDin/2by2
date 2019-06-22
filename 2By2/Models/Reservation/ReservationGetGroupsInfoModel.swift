//
//  GetGroupsInfo.swift
//  theGymApp
//
//  Created by mac on 10/23/18.
//  Copyright © 2018 personal. All rights reserved.
//

import UIKit
import SwiftyJSON

class ReservationGetGroupsInfoModel {
    
    static let className = mainReservationModel.className + "GetGroupsInfo"
    
    struct returnData {
        struct AgeGroupRange {
            static let structName = "AgeGroupRange"
            static let Id = "Id"
            static let Name = "Name"
        }
        struct Level {
            static let structName = "Level"
            static let Id = "Id"
            static let Name = "Name"
            static let AgeTo = "AgeTo"
            static let AgeFrom = "AgeFrom"
        }
    }
    
}

extension ReservationGetGroupsInfoModel {
    
    class func GetGroupsInfo(object: UIViewController, completion: @escaping (_ data: [String: JSON], _ error: Bool?) -> ()) {
        
        APIRequests.sendRequest(method: .get, url: ReservationGetGroupsInfoModel.className, params: nil, object: object) { (dic, error) in
            
            if error == false {
                completion(dic, false)
            }else {
                completion(dic, true)
            }
            
        }
        
    }
    
}
