//
//  UserCreate.swift
//  theGymApp
//
//  Created by mac on 10/23/18.
//  Copyright © 2018 personal. All rights reserved.
//

import UIKit
import SwiftyJSON

class UserCreateModel {
    
    static let className = MainUserModel.className + "Create"
    
    class UserCreateGetRequest {
        
        struct returnData {
            struct Data {
                struct Genders {
                    static let structName = "Genders"
                    static let Id = "Id"
                    static let Name = "Name"
                }
                
                struct ShapeGenderTypes {
                    static let structName = "ShapeGenderTypes"
                    static let Id = "Id"
                    static let Name = "Name"
                    struct BodyShapeGenderTypes {
                        static let structName = "BodyShapeGenderTypes"
                        static let Id = "Id"
                        static let Image = "Image"
                        struct BodyShape {
                            static let structName =  "BodyShape"
                            static let Id = "Id"
                            static let Name = "Name"
                        }
                    }
                }
                
                struct BodyShape {
                    static let structName = "Genders"
                    static let Id = "id"
                    static let Name = "Name"
                }
                
                struct LoginTypes {
                    static let structName = "Genders"
                    static let Id = "id"
                    static let Name = "Name"
                }
                
                struct Levels {
                    static let structName = "Genders"
                    static let Id = "id"
                    static let Name = "Name"
                }
                
            }
        }
    }
    
    class UserCreatePostRequest{
        
        struct returnData {
            let Id = "Id"
            let Name = "Name"
            let Age = "Age"
            let Phone = "Phone"
            let Height = "Height"
            let Width = "Width"
            let Image = "Image"
            let Email = "Email"
            let GenderName = "GenderName"
            let BodyShapeGenderTypeImage = "BodyShapeGenderTypeImage"
            let ProviderID = "ProviderID"
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
            let Password = "Password"
        }
        
        struct Params {
            static let Id = "Id"
            static let Name = "Name"
            static let Age = "Age"
            static let Phone = "Phone"
            static let NotificationToken = "NotificationToken"
            static let Height = "Height"
            static let Width = "Width"
            static let Image = "Image"
            static let Email = "Email"
            static let Fk_Gender = "Fk_Gender"
            static let Fk_BodyShapeGenderType = "Fk_BodyShapeGenderType"
            static let ProviderID = "ProviderID"
            static let Fk_LoginType = "Fk_LoginType"
            static let Fk_Level = "Fk_Level"
            static let Password = "Password"
        }
        
    }
}


extension UserCreateModel {
    
    class func UserPostCreateRequest(object: UIViewController, params: [String: Any], completion: @escaping (_ data: [String: JSON], _ error: Bool?) -> ()) {
        APIRequests.sendRequest(method: .post, url: UserCreateModel.className, params: params, object: object) { (dic, error) in
            
            if error == false {
                completion(dic, false)
            }else {
                completion(dic, true)
            }
        }
    }
    
}


extension UserCreateModel.UserCreateGetRequest {
    
    class func UserGetCreateRequest(object: UIViewController, completion: @escaping (_ data: [String: JSON], _ error: Bool?) -> ()) {
        
        APIRequests.sendRequest(method: .get, url: UserCreateModel.className, params: nil, object: object) { (dic, error) in
            
            if error == false {
                completion(dic, false)
            }else {
                completion(dic, true)
            }
        }
    }
}

extension UserCreateModel.UserCreatePostRequest {
    
    class func UserPostCreateRequest(object: UIViewController, params: [String: Any], completion: @escaping (_ data: [String: JSON], _ error: Bool?) -> ()) {
        
        APIRequests.sendRequest(method: .post, url: UserCreateModel.className, params: params, object: object) { (dic, error) in
            
            if error == false {
                completion(dic, false)
            }else {
                completion(dic, true)
            }
        }
    }
    
}
