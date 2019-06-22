//
//  CoachEditModel.swift
//  2By2
//
//  Created by mac on 10/28/18.
//  Copyright © 2018 personal. All rights reserved.
//

import UIKit
import SwiftyJSON

class CoachEditModel {
    
    static let className = MainCoachModel.className + "edit"
    
    struct returnData {
        
        struct Data {
            static let structName = "Data"
            struct User {
                static let structName = "User"
                static let Id = "Id"
                static let FirstName = "FirstName"
                static let LastName = "LastName"
                static let Age = "Age"
                static let Fk_Gender = "Fk_Gender"
                static let Fk_Language = "Fk_Language"
                static let ProviderID = "ProviderID"
                static let Email = "Email"
                static let Password = "Password"
                static let NotificationToken = "NotificationToken"
                static let Longitude = "Longitude"
                static let latitude = "latitude"
                static let Phone = "Phone"
                static let Image = "Image"
                static let About = "About"
                static let Fk_BodyShapeGenderType = "Fk_BodyShapeGenderType"
                struct LoginType {
                    static let structName = "LoginType"
                    static let Id = "Id"
                    static let Name = "Name"
                }
            }
            
            static let BodyShapeGenderTypeImage = "BodyShapeGenderTypeImage"
            struct Level {
                static let structName = "Level"
                static let Id = "Id"
                static let Name = "Name"
            }
        }
        
    }
    
    
    struct Params {
        static let Id = "Id"
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
        
        struct Locations {
            static let structName = "Locations"
            static let Id = "Id"
        }
        
        struct Languages {
            static let structName = "Languages"
            static let Id = "Id"
            static let Name = "Name"
        }
        
        struct FirstCategoryPrograms {
            static let structName = "FirstCategoryPrograms"
            static let Id = "Id"
        }
        
    }
    
}

extension CoachEditModel {
    
    
    class func CoachEditProfileRequest(object: UIViewController, params: [String: Any], completion: @escaping (_ data: [String: JSON], _ error: Bool?) -> ()) {
        
        APIRequests.sendRequest(method: .post, url: CoachEditModel.className, params: params, object: object) { (dic, error) in
            
            if error == false {
                completion(dic, false)
            }else {
                completion(dic, true)
            }
            
        }
        
    }
    
}
