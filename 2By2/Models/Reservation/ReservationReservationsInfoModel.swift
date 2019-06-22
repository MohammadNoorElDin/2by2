//
//  ReservationCreateReservationsInfoModel.swift
//  theGymApp
//
//  Created by mac on 10/24/18.
//  Copyright © 2018 personal. All rights reserved.
//

import UIKit
import SwiftyJSON

class ReservationReservationsInfoModel {
    
    class CreateReservationsInfo {
        static let className = mainReservationModel.className + "CreateReservationsInfo"
        
        struct params {
            static let Fk_Agenda = "Fk_Agenda"
            static let Fk_SecondCategoryProgram = "Fk_SecondCategoryProgram"
            static let Fk_Reservation = "Fk_Reservation"
            static let Longitude = "Longitude"
            static let Latitude = "Latitude"
        }
        
    } // END  OF THE CREATE CLASS
    
    class EditReservationsInfo {
        
        static let className = mainReservationModel.className + "EditReservationsInfo"
        
        struct params {
            static let Id = "Id"
            static let Fk_Agenda = "Fk_Agenda"
            static let Fk_SecondCategoryProgram = "Fk_SecondCategoryProgram"
            static let Fk_State = "Fk_State"
            static let Fk_Reservation = "Fk_Reservation"
            static let Longitude = "Longitude"
            static let Latitude = "Latitude"
        }
        
    } // END OF THE EDIT RESERVATION CLASS
    
    class DeleteReservationsInfo {
        
        static let className = mainReservationModel.className + "DeleteReservationsInfo"
        struct params {
            static let Id = "Id"
        }
    }
    
    
    class DeleteReservationsByState {
        
        static let className = mainReservationModel.className + "DeleteReservationInfosbyState"
        
        struct params {
            static let Fk_Reservation = "Fk_Reservation"
            static let Fk_State = "Fk_State"
        }
    }
    
}

extension ReservationReservationsInfoModel.DeleteReservationsByState {
   
    class func deleteReservationInfo(object: UIViewController, params: [String: Any], completion: @escaping (_ data: [String: JSON], _ error: Bool?) -> ()) {
       
        
        
        APIRequests.sendRequest(method: .post, url: ReservationReservationsInfoModel.DeleteReservationsByState.className, params: params, object: object) { (dic, error) in
            
            if error == false {
                completion(dic, false)
            }else {
                completion(dic, true)
            }
            
        }
    }
    
}

extension ReservationReservationsInfoModel.DeleteReservationsInfo {
    
    class func deleteReservation(object: UIViewController, params: [String: Any], completion: @escaping (_ data: [String: JSON], _ error: Bool?) -> ()) {
        
        APIRequests.sendRequest(method: .post, url: ReservationReservationsInfoModel.DeleteReservationsInfo.className, params: params, object: object) { (dic, error) in
            
            if error == false {
                completion(dic, false)
            }else {
                completion(dic, true)
            }
            
        }
    }
    
}


extension ReservationReservationsInfoModel.EditReservationsInfo {
    
    class func editReservation(object: UIViewController, params: [String: Any], completion: @escaping (_ data: [String: JSON], _ error: Bool?) -> ()) {
        
        APIRequests.sendRequest(method: .post, url: ReservationReservationsInfoModel.EditReservationsInfo.className, params: params, object: object) { (dic, error) in
            
            if error == false {
                completion(dic, false)
            }else {
                completion(dic, true)
            }
            
        }
    }
    
}

extension ReservationReservationsInfoModel.CreateReservationsInfo {
    
    class func createReservationInfo(object: UIViewController, params: [ String : Any ], completion: @escaping (_ data: JSON?, _ error: Bool?) -> ()) {
        
        print(params)
        print(ReservationReservationsInfoModel.EditReservationsInfo.className)
        
        APIRequests.sendJSONRequest(method: .post, url: ReservationReservationsInfoModel.CreateReservationsInfo.className, params: params, object: object) { (dic, error) in
            
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



