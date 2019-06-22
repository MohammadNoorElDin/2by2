//  ReservationGitPackages.swift
//  theGymApp
//
//  Created by mac on 10/23/18.
//  Copyright © 2018 personal. All rights reserved.
//

import UIKit
import SwiftyJSON

class ReservationGetPackagesModel {
    
    static let className = mainReservationModel.className + "GetNewPackages"
    
    struct returnData {
    
        static var Name = "Name"
        static var SeesionCount = "SeesionCount"
        static var Include = "Include"
        
        struct PackagePersonRangePrices  {
            static let structName = "PackagePersonRangePrices"
            static let Id = "Id"
            static let Price = "Price"
            
            struct PackagePersonRange {
                static let structName = "PackagePersonRange"
                static let Name = "Name"
                static let CountFrom = "CountFrom"
                static let CountTo = "CountTo"
            }
        }
        
    }
    
}


extension ReservationGetPackagesModel {
   
    class func UserGetPackagesRequest(object: UIViewController, params: [String: Any]?, completion: @escaping (_ data: JSON?, _ error: Bool?) -> ()) {
        
        APIRequests.sendRequestArrayBack(method: .get, url: ReservationGetPackagesModel.className , params: params, object: object) { (dic, error) in
           
            if true == error {
                completion(dic, true)
            }else {
                completion(dic, false)
            }
        }
    }
    
}
