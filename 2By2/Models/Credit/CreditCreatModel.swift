//
//  CreditCreatModel.swift
//  theGymApp
//
//  Created by mac on 10/24/18.
//  Copyright © 2018 personal. All rights reserved.
//

import UIKit
import SwiftyJSON

class CreditCreatModel {

    class CreatePostRequest {
        
        static let className = MainCreditModel.className + "createCredit"
        
        struct params {
            static let Fk_User = "Fk_User"
        }
        struct returnData {
            static let Data = "Data"
        }
    }
    
    class CreateGetRequest {
        
        static let className = MainCreditModel.className + "createCredit"
        
        struct returnData {
            
            struct CreditType {
                static let structName = "CreditType"
                static let Id = "Id"
                static let Name = "Name"
            }
        }
        
    }

}

extension CreditCreatModel.CreatePostRequest {
    
    class func tokenCommingBack(object: UIViewController, completion: @escaping (_ data: String?, _ error: Bool?) -> ()) {
        
        let params = [
            CreditCreatModel.CreatePostRequest.params.Fk_User : UserDataUsedThroughTheApp.userId
        ]
        
        DispatchQueue.global(qos: .userInteractive).async {
            APIRequests.sendPaymentRequest(method: .post, url: CreditCreatModel.CreatePostRequest.className, params: params, object: object, completion: { (token, error) in
                if error == false {
                    completion(token, false)
                }else {
                    completion(nil, false)
                }
                
            })
        }
        
    }
}

extension CreditCreatModel.CreateGetRequest{
    
    class func getStatus(url:String, object: UIViewController, completion: @escaping (_ data: JSON?, _ error: Bool?) -> ()) {
        
        DispatchQueue.global(qos: .userInteractive).async {
            APIRequests.sendPaymentBackRequest(method: .get, url: url, params: nil, object: object, completion: { (response, error) in
                
                if error == false {
                    completion(response, false)
                } else {
                    completion(nil, false)
                }
                
            })
        }
        
    }
    
 
    
    
}
