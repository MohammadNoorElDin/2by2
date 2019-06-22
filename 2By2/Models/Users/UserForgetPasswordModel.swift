//
//  UserForgetPasswordModel.swift
//  2By2
//
//  Created by rocky on 12/20/18.
//  Copyright © 2018 personal. All rights reserved.
//

import UIKit
import SwiftyJSON

class UserForgetPasswordModel {
    
    static let className = MainUserModel.className + "ForgetPassword"
    
    struct Params {
        static let Phone = "Phone"
    }
    
}


extension UserForgetPasswordModel {
    
    class func sendForgetPasswordRequest(object: UIViewController, params: [String: Any], completion: @escaping (_ status: Bool) -> () ) {
        
        
        APIRequests.sendRequest(method: .post, url: UserForgetPasswordModel.className, params: params, object: object) { (response, error) in
            
                completion(error) // TRUE MEANS ERROR IS EXIST 
            
        }
        
    }
    
}
