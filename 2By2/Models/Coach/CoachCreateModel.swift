//
//  CoachCreateModel.swift
//  2By2
//
//  Created by mac on 10/28/18.
//  Copyright © 2018 personal. All rights reserved.
//

import UIKit
import SwiftyJSON

class CoachCreateModel {
    
    class CoachCreateGetRequest {
        
        static let className = MainCoachModel.className + "create"
        
        struct returnData {
            static let Id = "Id"
            static let FirstName = "FirstName"
            static let LastName = "LastName"
            static let Age = "Age"
            static let ProviderID = "ProviderID"
            static let Email = "Email"
            static let Password = "Password"
            static let NotificationToken = "NotificationToken"
            static let Longitude = "Longitude"
            static let latitude = "latitude"
            static let Phone = "Phone"
            static let Image = "Image"
            static let About = "About"
            struct Genders {
                static let structName = "Genders"
                static let Id = "Id"
                static let Name = "Name"
            }
            struct Languages {
                static let structName = "Languages"
                static let Id = "Id"
                static let Name = "Name"
            }
            struct LoginType {
                static let structName = "LoginType"
                static let Id = "Id"
                static let Name = "Name"
            }
            
            struct Locations {
                static let structName = "Locations"
                static let Id = "Id"
                static let Name = "Name"
            }
            struct FirstCategoryPrograms {
                static let structName = "FirstCategoryPrograms"
                static let Id = "Id"
                static let Name = "Name"
            }
            
        }
        
    } // END OF THE GET REQUEST ....
    
    class CoachCreatePostRequest {
        
        static let className = MainCoachModel.className + "create"
        
        struct returnData {
            
            struct Gender {
                static let structName = "Gender"
                static let Id = "Id"
                static let Name = "Name"
            }
            
            struct LoginType {
                static let structName = "LoginType"
                static let Id = "Id"
                static let Name = "Name"
            }
            struct Language {
                static let structName = "Language"
                static let Id = "Id"
                static let Name = "Name"
            }
            struct Location {
                static let structName = "Location"
                static let Id = "Id"
                static let Name = "Name"
            }
            
            struct FirstCategoryProgram {
                static let structName = "FirstCategoryProgram"
                static let Id = "Id"
                static let Name = "Name"
                struct SecondCategoryProgram {
                    static let structName = "SecondCategoryProgram"
                    static let Id = "Id"
                    static let Name = "Name"
                }
            }
            
        }
        
        struct Params {
            
            static let Name = "Name"
            static let Age = "Age"
            static let Fk_Gender = "Fk_Gender"
            static let Fk_Language = "Fk_Language"
            static let FK_LoginType = "FK_LoginType"
            static let ProviderID = "ProviderID"
            static let Email = "Email"
            static let Password = "Password"
            static let NotificationToken = "NotificationToken"
            static let Longitude = "Longitude"
            static let latitude = "latitude"
            static let Phone = "Phone"
            static let Image = "Image"
            static let About = "About"
            static let HaveAcar = "HaveAcar"
            
            
            struct Languages {
                static let structName = "Languages"
                static let Id = "Id"
                static let Name = "Name"
            }
            
            struct Locations {
                static let structName = "Locations"
                static let Id = "Id"
            }
            
            struct FirstCategoryPrograms {
                static let structName = "FirstCategoryPrograms"
                static let Id = "Id"
            }
            
        }
        
    } // END OF THE POST REQUEST ....
    
}


extension CoachCreateModel.CoachCreateGetRequest {
    
    class func CoachGetCreateRequest(object: UIViewController, completion: @escaping (_ data: [String: JSON], _ error: Bool?) -> ()) {
        
        APIRequests.sendRequest(method: .get, url: CoachCreateModel.CoachCreateGetRequest.className, params: nil, object: object) { (dic, error) in
            if error == true {
                completion(dic, true)
            }else {
                completion(dic, false)
            }
            
        }
        
    }
    
}

extension CoachCreateModel.CoachCreatePostRequest {
    
    class func CoachPostCreateRequest(object: UIViewController, params: [String: Any], completion: @escaping (_ data: [String: JSON], _ error: Bool?) -> ()) {
        
        APIRequests.sendRequest(method: .post, url: CoachCreateModel.CoachCreatePostRequest.className, params: params, object: object) { (dic, error) in
            
            if error == false {
                completion(dic, false)
            }else {
                completion(dic, true)
            }
            
        }
        
    }
}
