//
//  ReservationGetCoachsModel.swift
//  theGymApp
//
//  Created by mac on 10/23/18.
//  Copyright © 2018 personal. All rights reserved.
//

import UIKit
import SwiftyJSON

class ReservationCoachsModel {
    
    class GetCoachs {
    
        static let className = mainReservationModel.className + "GetCoachs"
        
        struct params {
            static let Latitude = "Latitude"
            static let Longitude = "Longitude"
            static let Date = "Date"
            static let Fk_BodyShapeGenderType = "Fk_BodyShapeGenderType"
            static let Fk_SecondCategoryProgram = "Fk_SecondCategoryProgram"
            static let Name = "Name"
            static let FK_Gender = "FK_Gender"
            static let FK_Languages = "FK_Languages"
        }
        
        struct returnData {
            static let Id = "Id"
            static let Name = "Name"
            static let Image = "Image"
            static let About = "About"
        }

    } // END OF CLASS GETCOACHS
    
    class GetCoachsAgenda {
        
        static let className = mainReservationModel.className + "getcoachsagenda"
        
        struct params {
            static let Fk_Coach = "Fk_Coach"
        }
        
        struct returnData {
            static let DateFrom = "DateFrom"
            static let DateTo = "DateTo"
            static let Fk_UserOwner = "Fk_UserOwner"
        }
        
    } // END OF CLASS GETCOACHS
    
    
    
}

extension ReservationCoachsModel.GetCoachs {
    
    class func getCoachesToChooseFrom(object: UIViewController, params: [String: Any]?, completion: @escaping (_ data: JSON?, _ error: Bool?) -> ()) {
        
        APIRequests.sendRequestArrayBack(method: .get, url: ReservationCoachsModel.GetCoachs.className , params: params, object: object) { (dic, error) in
            
            if true == error {
                completion(dic, true)
            }else {
                completion(dic, false)
            }
        }
    }
    
    
}
