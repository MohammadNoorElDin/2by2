//
//  UserEdit.swift
//  theGymApp
//
//  Created by mac on 10/23/18.
//  Copyright © 2018 personal. All rights reserved.
//

import UIKit
import SwiftyJSON

class UserEditModel {
    
    static let className = MainUserModel.className + "Edit"
    struct params {
        static let Id = "Id"
        static let Name = "Name"
        static let Age = "Age"
        static let Phone = "Phone"
        static let NotificationToken = "NotificationToken"
        static let Height = "Height"
        static let Weight = "Weight"
        static let Image = "Image"
        static let Email = "Email"
        static let Fk_Gender = "Fk_Gender"
        static let Fk_BodyShapeGenderType = "Fk_BodyShapeGenderType"
        static let ProviderID = "ProviderID"
        static let Fk_LoginType = "Fk_LoginType"
        static let Fk_Level = "Fk_Level"
        static let Password = "Password"
    }
    
    struct returnData {
        var Id = "Id"
        var FirstName = "FirstName"
        var LastName = "LastName"
        var Age = "Age"
        var Phone = "Phone"
        var Height = "Height"
        var Width = "Width"
        var Image = "Image"
        var Email = "Email"
        var GenderName = "GenderName"
        var BodyShapeGenderTypeImage = "BodyShapeGenderTypeImage"
        var ProviderID = "ProviderID"
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
        var Password = "Password"
    }
    
    
    
}


extension UserEditModel {
    
    class func UserEdit(params: [String: Any], object: UIViewController, completion: @escaping (_ data: [String: JSON], _ error: Bool?) -> ()) {
        
        APIRequests.sendRequest(method: .post, url: UserEditModel.className, params: params, object: object) { (dic, error) in
            
            if error == true {
                completion(dic, true)
            }else {
                completion(dic, false)
            }
        }
    }
    
}

