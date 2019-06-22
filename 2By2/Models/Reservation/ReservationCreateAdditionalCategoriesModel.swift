//
//  ReservationCreateAdditionalCategoriesModel.swift
//  2By2
//
//  Created by rocky on 1/13/19.
//  Copyright © 2019 personal. All rights reserved.
//

import UIKit
import SwiftyJSON

class ReservationCreateAdditionalCategoriesModel {
    
    static let className = mainReservationModel.className + "CreateAdditionalCategories"
    static let className2 = mainReservationModel.className + "GetReservationAdditionalCategories"
    
    class func getRequest(object: UIViewController, params: [String: Any], completion: @escaping (_ data: JSON?, _ error: Bool?) -> ()) {
        
        APIRequests.sendRequestArrayBack(method: .get, url: ReservationCreateAdditionalCategoriesModel.className, params: params, object: object) { (dic, error) in
            if true == error {
                completion(dic, true)
            }else {
                completion(dic, false)
            }
        }
    }
    
    
    class func postRequest(object: UIViewController, params: [String: Any], completion: @escaping (_ data: JSON?, _ error: Bool?) -> ()) {
        
        APIRequests.sendRequest(method: .post, url: ReservationCreateAdditionalCategoriesModel.className, params: params, object: object) { (response, error) in
            if error == false {
                completion([:], false)
            }else {
                completion([:], true)
            }
        }
        
    }
    
    
    class func GetReservationAdditionalCategories(object: UIViewController, params: [String: Any], completion: @escaping (_ data: JSON?, _ error: Bool?) -> ()) {
        
        APIRequests.sendRequest(method: .get, url: ReservationCreateAdditionalCategoriesModel.className2, params: params, object: object) { (response, error) in
            if error == false {
                completion(response["Data"], false)
            }else {
                completion([:], true)
            }
        }
        
    }
    
    
}



