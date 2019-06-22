//
//  ReservationCreateModel.swift
//  theGymApp
//
//  Created by mac on 10/23/18.
//  Copyright © 2018 personal. All rights reserved.
//

import UIKit
import SwiftyJSON

class ReservationCreateModel {
    
    static let className = mainReservationModel.className + "Create"
    
    struct params {
        
        static let IsFree = "IsFree"
        static let IsReplicated = "IsReplicated"
        
        struct Reservation {
            static let structName = "Reservation"
            static let Fk_UserOwner = "Fk_UserOwner"
            static let Fk_PackagePersonRangePrice =  "Fk_PackagePersonRangePrice"
            static let IsGroup =  "IsGroup"
            static let Fk_PaymentOption =  "Fk_PaymentOption"
            
        }
        
        struct ReservationsInfos {
            static let structName = "ReservationsInfos"
            static let Fk_Agenda = "Fk_Agenda"
            static let Fk_SecondCategoryProgram =  "Fk_SecondCategoryProgram"
            static let Latitude = "Latitude"
            static let Longitude = "Longitude"
        }
        
        struct ReservationGroupMember {
            static let structName = "ReservationGroupInfo"
            static let Fk_AgeGroupRange = "Fk_AgeGroupRange"
            static let Fk_Level = "Fk_Level"
        }
        
        struct ReservationGroupInfo {
            static let structName = "ReservationGroupMember"
            static let Name = "Name"
            static let Phone = "Phone"
        }
        
        struct UserCreditTransaction {
            static let structName = "UserCreditTransaction"
        }
        
        struct UserPaymentHistory {
            static let structName = "UserPaymentHistory"
        }
        
    }
    
}


extension ReservationCreateModel {
    
    class func AgendaCreateRequest(object: UIViewController, params: [ String : Any ], completion: @escaping (_ data: JSON?, _ error: Bool?) -> ()) {
        
        APIRequests.sendJSONRequest(method: .post, url: ReservationCreateModel.className, params: params, object: object) { (dic, error) in
            
            if error == true {
                // ERROR
                completion(nil, true)
            }else {
                // SUCCESS
                completion(dic, false)
            }
            
        }
    }
    
}
