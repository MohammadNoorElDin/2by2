//
//  UserHomeModel.swift
//  2By2
//
//  Created by rocky on 12/9/18.
//  Copyright © 2018 personal. All rights reserved.
//

import Foundation
import SwiftyJSON

class UserHomeModel {
    
    static let className = MainUserModel.className + "Home"
    
    struct Params {
        static let Fk_User = "Fk_User"
    }
    
    struct returnData {
        struct Notification  {
            static let Id = "Id"
            static let Title = "Title"
            static let Description = "Description"
            static let Fk_NotificationType = "Fk_NotificationType"
            static let Priority = "Priority"
            static let CreatedAt = "CreatedAt"
            static let ModifiedAt = "ModifiedAt"
            static let NotificationType = "NotificationType"
        }
        struct Gift {
            static let Id = "Id"
            static let Title = "Title"
            static let Description = "Description"
            static let Discount = "Discount"
            static let PerUserMax = "PerUserMax"
            static let UsersMax = "UsersMax"
            static let CountAvailable = "CountAvailable"
            static let Count = "Count"
            static let ExpireDate = "ExpireDate"
            static let Priority = "Priority"
            static let Fk_SecondCategoryProgram = "Fk_SecondCategoryProgram"
            static let SecondCategoryProgram = "SecondCategoryProgram"
            static let CreatedAt = "CreatedAt"
            static let ModifiedAt = "ModifiedAt"
        }
        static let UpcomingReservations = "UpcomingReservations"
        static let BMIResult = "BMIResult"
        static let Weight = "Weight"
        static let Height = "Height"
    }
}

extension UserHomeModel {
    
    class func UserHomeRequest(object: UIViewController, params: [String: Any], completion: @escaping (_ data: [String: JSON], _ error: Bool?) -> ()) {
        print(UserHomeModel.className)
        
        APIRequests.sendRequest(method: .get, url: UserHomeModel.className, params: params, object: object) { (dic, error) in
            
            if error == false {
                completion(dic, false)
            }else {
                completion(dic, true)
            }
            
        }
        
    }
}
