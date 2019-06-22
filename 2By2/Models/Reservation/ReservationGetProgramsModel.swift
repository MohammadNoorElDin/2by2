//
//  ReservationGetPrograms.swift
//  theGymApp
//
//  Created by mac on 10/23/18.
//  Copyright © 2018 personal. All rights reserved.
//

import Foundation
import SwiftyJSON

class ReservationGetProgramsModel {
    
    static let className = mainReservationModel.className + "GetPrograms"
    
    struct params {
        static let Fk_BodyShapeGenderType = "Fk_BodyShapeGenderType"
    }
    
    struct returnData {
        static let Id = "Id"
        static let Name = "Name"
        static let Image = "Image"
        struct ThirdCategoryProgram {
            static let structName = "ThirdCategoryProgram"
            static let Name = "Name"
        }
    }
    
}

extension ReservationGetProgramsModel {
    
    class func UserProgramsRequest(object: UIViewController, completion: @escaping (_ data: JSON?, _ error: Bool?) -> ()) {
        
        let params = [ReservationGetProgramsModel.params.Fk_BodyShapeGenderType: UserDataUsedThroughTheApp.Fk_BodyShapeGenderType ]
        
        APIRequests.sendRequestArrayBack(method: .get, url: ReservationGetProgramsModel.className, params: params, object: object) { (dic, error) in
            if true == error {
                completion(dic, true)
            }else {
                completion(dic, false)
            }
        }
    }
}
