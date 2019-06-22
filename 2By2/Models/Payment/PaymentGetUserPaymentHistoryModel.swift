//
//  PaymentGetUserPaymentHistoryModel.swift
//  theGymApp
//
//  Created by mac on 10/24/18.
//  Copyright © 2018 personal. All rights reserved.
//

import UIKit
import SwiftyJSON

class PaymentGetUserPaymentHistoryModel {
    
    static let className = mainPayment.className + "GetUserPaymentHistory"
    
    struct params {
        static let Fk_User = "Fk_User"
    }
    
    struct returnData {
        static let Fk_Reservation = "Fk_Reservation"
        static let PackageName = "PackageName"
        static let TotalPrice = "TotalPrice"
        static let CreatedAt = "CreatedAt"
        static let TotalPaid = "TotalPaid"
        static let TotalUnPaid = "TotalUnPaid"
    }
    
}

extension PaymentGetUserPaymentHistoryModel {
    
    class func GetUserPaymentHistoryRequest(object: UIViewController, completion: @escaping (_ data: JSON?, _ error: Bool?) -> ()) {
        
        let params = [PaymentGetUserPaymentHistoryModel.params.Fk_User: UserDataUsedThroughTheApp.userId ]
        print("url is:\(PaymentGetUserPaymentHistoryModel.className)")
        
        APIRequests.sendRequestArrayBack(method: .get, url: PaymentGetUserPaymentHistoryModel.className, params: params, object: object) { (dic, error) in
            if true == error {
                completion(dic, true)
            }else {
                completion(dic, false)
            }
        }
    }
    
    class func GetUserPaymentMethodsRequest(object: UIViewController, completion: @escaping (_ data: JSON?, _ error: Bool?) -> ()) {
        
        let params = [PaymentGetUserPaymentHistoryModel.params.Fk_User: UserDataUsedThroughTheApp.userId ]
        let url: String = "https://webservice.2by2club.com/Credit/GetUserCredit"
        
        APIRequests.sendRequestArrayBack(method: .get, url: url, params: params, object: object) { (dic, error) in
            if true == error {
                completion(dic, true)
            }else {
                completion(dic, false)
            }
        }
    }
    
    
    class func DeletePaymentMethodsRequest(object: UIViewController, params: [String: Any], completion: @escaping (_ data: JSON?, _ error: Bool?) -> ()) {
        
        let url: String = "https://webservice.2by2club.com/Credit/Delete"
        
        APIRequests.sendRequest(method: .post, url: url, params: params, object: object) { (response, error) in
            
            if error == false {
                completion([:], false)
            } else {
                completion([:], true)
            }
        }
    }
 
    
    
}
