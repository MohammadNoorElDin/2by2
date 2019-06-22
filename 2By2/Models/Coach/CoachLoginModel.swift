//
//  CoachLoginModel.swift
//  2By2
//
//  Created by mac on 10/28/18.
//  Copyright © 2018 personal. All rights reserved.
//

import UIKit
import SwiftyJSON

// MARK:- VARIABLES
class CoachLoginModel {
    
    static let className = MainCoachModel.className + "login"
    
    struct Params {
        static let Phone = "Phone"
        static let Password = "Password"
        static let ProviderID = "ProviderID"
        static let Fk_LoginType = "Fk_LoginType" // 3 [email, password] , 2 [gmail], 1 [facebook]
    }
    
    struct returnData {
        struct Coach {
            
            static let structName = "Coach"
            
            static let Id = "Id"
            static let Name = "Name"
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
            static let FK_LoginType = "FK_LoginType"
            
            struct LoginType {
                static let structName = "LoginType"
                static let Id = "Id"
                static let Name = "Name"
            }
            struct Gender {
                static let structName = "Gender"
                static let Id = "Id"
                static let Name = "Name"
            }
        }
        struct Languages {
            static let structName = "Languages"
            static let Id = "Id"
            static let Name = "Name"
        }
        struct Locations {
            static let structName = "Locations"
            static let Id = "Id"
            static let Name = "Name"
        }
        struct FirstCategoryProgram {
            static let structName = "FirstCategoryProgram"
            static let Id = "Id"
            static let Name = "Name"
        }
    }
}


// MARK:- FUNCTIONS

extension CoachLoginModel {
    
    class func CoachLogin(params: [String: Any], object: UIViewController, completion: @escaping (_ data: [String: JSON], _ error: Bool?) -> ()) {
        
        DispatchQueue.global(qos: .userInteractive).async {
            APIRequests.sendRequest(method: .post, url: CoachLoginModel.className, params: params, object: object) { (dic, error) in
                
                DispatchQueue.main.async {
                    
                    if error == true {
                        completion(dic, true)
                    }else {
                        completion(dic, false)
                    }
                    
                }
            }
        }
    }
    
}
