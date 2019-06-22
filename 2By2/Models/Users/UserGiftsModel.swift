//
//  UserGifts.swift
//  theGymApp
//
//  Created by mac on 10/23/18.
//  Copyright © 2018 personal. All rights reserved.
//

import UIKit

import SwiftyJSON

class UserGiftsModel {
    
    static let className = MainUserModel.className + "GetGifts"
    
    // MARK :- CLASS GetGifts
    class GetGiftsModel {
        
        static let nestedClassName = MainUserModel.className + "GetGifts"
        
        struct params {
            static let Fk_User = "Fk_User"
        }
        
        struct returnData {
            static let Title = "Title"
            static let Description = "Description"
            static let Discount = "Discount"
            static let ExpireDate = "ExpireDate"
            static let CountAvailable = "CountAvailable"
            struct SecondCategoryProgram {
                static let structName = "SecondCategoryProgram"
                static let Id = "Id"
                static let Name = "Name"
            }
        }
    }
    
    // MARK :- CLASS EditUserGift
    class EditUserGiftModel {
        
        static let nestedClassName = MainUserModel.className + "GetGifts"
        
        struct params {
            static let Id = "Id"
            static let Count = "Count"
        }
    }
    
}

extension UserGiftsModel.GetGiftsModel {
    
    class func UserGetGiftsRequest(object: UIViewController, completion: @escaping (_ data: JSON?, _ error: Bool?) -> ()) {
        
        let params = [UserGiftsModel.GetGiftsModel.params.Fk_User: UserDataUsedThroughTheApp.userId ]
        
        APIRequests.sendRequestArrayBack(method: .get, url: UserGiftsModel.className, params: params, object: object) { (dic, error) in
            if true == error {
                completion(dic, true)
            }else {
                completion(dic, false)
            }
        }
    }
}
