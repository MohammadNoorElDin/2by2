
//
//  ReservationGetReservations.swift
//  theGymApp
//
//  Created by mac on 10/24/18.
//  Copyright © 2018 personal. All rights reserved.
//

import UIKit
import SwiftyJSON

class ReservationGetReservationsModel {
    
    class GetComingReservation {
        
        static let className = mainReservationModel.className + "GetUserComingReservations"
        
        struct params {
            static let Fk_User =  "Fk_User"
        }
        
        struct returnData {
            
            struct Agenda {
                static let structName = "Agenda"
                static let DateFrom = "DateFrom"
                static let DateTo =  "DateTo"
                
                struct Coach {
                    static let structName = "Coach"
                    static let Id = "Id"
                    static let FirstName = "FirstName"
                    static let LastName = "LastName"
                    static let Image = "Image"
                    static let Phone = "Phone"
                }
            }
            
            struct ReservationsInfo {
                static let structName = "ReservationsInfo"
                static let Id = "Id"
                static let IsOwner = "IsOwner"
                static let Longitude =  "Longitude"
                static let Latitude = "Latitude"
                
                struct State {
                    static let structName = "State"
                    static let Id = "Id"
                    static let Name = "Name"
                }
                struct SecondCategoryProgram {
                    static let structName = "SecondCategoryProgram"
                    static let Id = "Id"
                    static let Name = "Name"
                }
                
            }
            
            struct Package {
                static let structName = "Package"
                static let Modify_Coach = "Modify_Coach"
                static let Modify_Date = "Modify_Date"
                static let Modify_Program = "Modify_Program"
            }
        }
    } // END OF THE COMING CLASS
    class GetPastReservations {
        
        static let className = mainReservationModel.className + "GetUserPastReservations"
        
        struct params {
            static let Fk_User =  "Fk_User"
        }
        
        struct returnData {
            
            struct Agenda {
                static let structName = "Agenda"
                static let DateFrom = "DateFrom"
                static let DateTo = "DateTo"
                struct Coach {
                    static let structName = "Coach"
                    static let Id = "Id"
                    static let FirstName = "FirstName"
                    static let LastName =  "LastName"
                    static let Image =  "Image"
                    static let Phone =  "Phone"
                }
            }
            
            struct ReservationsInfo {
                static let Id = "Id"
                static let IsOwner = "IsOwner"
                struct State  {
                    static let structName = "State"
                    static let Id = "Id"
                    static let Name = "Name"
                }
                struct SecondCategoryProgram {
                    static let structName = "SecondCategoryProgram"
                    static let Id = "Id"
                    static let Name = "Name"
                }
            }
        }
        
        class GetUnReservations {
            static let nestedClassName = mainReservationModel.className + "GetUnReservations"
            
            struct params {
                static let Fk_User =  "Fk_User"
            }
            
            struct returnData {
                struct Package {
                    static let Name = "Name"
                    static let AvailableSeesion = "AvailableSeesion"
                    static let ExpiryDate = "ExpiryDate"
                    static let Modify_Coach = "Modify_Coach"
                    static let Modify_Date = "Modify_Date"
                    static let Modify_Program = "Modify_Program"
                }
                
                struct ReservationsInfo {
                    static let structName = "ReservationsInfo"
                    static let Fk_Reservation = "Fk_Reservation"
                    static let Fk_SecondCategoryProgram = "Fk_SecondCategoryProgram"
                    static let Fk_Coach = "Fk_Coach"
                }
            }
            
        }
    }
    class GetUnReservations {
        static let className = mainReservationModel.className + "GetUnReservation"
        struct params {
            static let Fk_User = "Fk_User"
        }
    }
    class AddUserToReservation {
        static let className = mainReservationModel.className + "AddUserToReservation"
        struct params {
            static let code = "code"
            static let Fk_User = "Fk_User"
        }
    }
    
}

extension ReservationGetReservationsModel.AddUserToReservation {
    class func sendCodeRequest(object: UIViewController, params: [String: Any], completion: @escaping (_ data: JSON?, _ error: Bool?) -> ()) {
        APIRequests.sendRequest(method: .post, url: ReservationGetReservationsModel.AddUserToReservation.className, params: params, object: object) { (response, error) in
            if error == false {
                completion([:], false)
            }else {
                completion([:], true)
            }
        }
    }
}

extension ReservationGetReservationsModel.GetComingReservation {
    
    class func getUserComingReservations(object: UIViewController, completion: @escaping (_ data: JSON?, _ error: Bool?) -> ()) {
        
        let params = [ReservationGetReservationsModel.GetComingReservation.params.Fk_User: UserDataUsedThroughTheApp.userId  ]
        
        APIRequests.sendRequestArrayBack(method: .get, url: ReservationGetReservationsModel.GetComingReservation.className, params: params, object: object) { (dic, error) in
            
            if error == false {
                completion(dic, false)
            }else {
                completion(dic, true)
            }
        }
    }
    
}


extension ReservationGetReservationsModel.GetComingReservation {
    
    class func GetUnReservation(object: UIViewController, completion: @escaping (_ data: JSON?, _ error: Bool?) -> ()) {
        
        let params = [ReservationGetReservationsModel.GetComingReservation.params.Fk_User: UserDataUsedThroughTheApp.userId ]
        
        APIRequests.sendRequestArrayBack(method: .get, url: ReservationGetReservationsModel.GetUnReservations.className, params: params, object: object) { (dic, error) in
            
            if error == false {
                completion(dic, false)
            }else {
                completion(dic, true)
            }
        }
    }
    
}


extension ReservationGetReservationsModel.GetPastReservations {
    
    class func GetUserPastReservation(object: UIViewController, completion: @escaping (_ data: JSON?, _ error: Bool?) -> ()) {
        
        let params = [ReservationGetReservationsModel.GetComingReservation.params.Fk_User: UserDataUsedThroughTheApp.userId ]
        
        APIRequests.sendRequestArrayBack(method: .get, url: ReservationGetReservationsModel.GetPastReservations.className, params: params, object: object) { (dic, error) in
            
            if error == false {
                completion(dic, false)
            }else {
                completion(dic, true)
            }
        }
    }
    
}


