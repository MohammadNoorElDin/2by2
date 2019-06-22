//
//  UserChallanges.swift
//  theGymApp
//
//  Created by mac on 10/23/18.
//  Copyright © 2018 personal. All rights reserved.
//

import UIKit
import SwiftyJSON

class UserChallangesModel {

    static let className = MainUserModel.className + "UserChallenges"
    
    struct params {
        static let Fk_User = "Fk_User"
    }
    
    struct returnData {
        static let Fat = "Fat"
        static let Muscles = "Muscles"
        static let Weight = "Weight"
        static let Height = "Height"
        static let Date = "Date"
        struct ChallengeState {
            static let Id = "Id"
            static let Name = "Name"
        }
    }

}

extension UserChallangesModel {
    class func UserGetChallangesRequest(object: UIViewController, completion: @escaping (_ data: JSON?, _ error: Bool?) -> ()) {
        
        let params = [UserChallangesModel.params.Fk_User: UserDataUsedThroughTheApp.userId ]
        
        APIRequests.sendRequestArrayBack(method: .get, url: UserChallangesModel.className, params: params, object: object) { (dic, error) in
            if true == error {
                completion(dic, true)
            }else {
                completion(dic, false)
            }
        }
    }
    
    class func EditUserChallangeRequest(object: UIViewController, params: [String: Any], completion: @escaping (_ data: JSON?, _ error: Bool?) -> ()) {
        let url = UserChallangesModel.className + "EditUserChallange"
        
        APIRequests.sendRequest(method: .post, url: url, params: params, object: object) { (reponse, error) in
            if error == false {
                completion([:], false)
            }else {
                completion([:], true)
            }
        }
    }
}
