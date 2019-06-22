//
//  UserModel.swift
//  theGymApp
//
//  Created by mac on 10/23/18.
//  Copyright © 2018 personal. All rights reserved.
//

import Foundation
import SwiftyJSON

// MARK :- Class Definition
class UserLoginModel {
    
    static let className = MainUserModel.className + "Login"
    
    struct returnData {
        struct User {
            static let structName = "User"
            static let Id = "Id"
            static let Name = "Name"
            static let Age = "Age"
            static let Phone = "Phone"
            static let Height = "Height"
            static let Width = "Width"
            static let Image = "Image"
            static let Email = "Email"
            static let GenderName = "GenderName"
            static let Fk_BodyShapeGenderType = "Fk_BodyShapeGenderType"
            static let ProviderID = "ProviderID"
            static let Password = "Password"
        }
        struct LoginType {
            static let structName = "LoginType"
            static let Id = "Id"
            static let Name = "Name"
        }
        struct Level {
            static let structName = "Level"
            static let Id = "Id"
            static let Name = "Name"
            
        }
    }
    
    struct Params {
        static let Phone = "Phone"
        static let Password = "Password"
        static let ProviderID = "ProviderID"
        static let Fk_LoginType = "Fk_LoginType"
    }
    
    
    
}

extension UserLoginModel {
    
    class func UserLogin(params: [String: Any], object: UIViewController, completion: @escaping (_ data: [String: JSON], _ error: Bool?) -> ()) {
        
        DispatchQueue.global(qos: .userInteractive).async {
            APIRequests.sendRequest(method: .post, url: UserLoginModel.className, params: params, object: object) { (dic, error) in
                
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


