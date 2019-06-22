//
//  MobileAuthRequest.swift
//  2By2
//
//  Created by rocky on 1/16/19.
//  Copyright © 2019 personal. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class MobileAuthRequest {
    
    class func changeMobile(phone: String, object: UIViewController, compeletion: @escaping (_ error: Bool) -> () ) {
        
        var phone = phone
        
        UserCheckPhoneModel.checkPhone(object: object, params: ["Phone": phone]) { (response, error) in
            if error == false {
                
                phone.removeFirst() ; phone = "+20" + phone
                PhoneAuthProvider.provider().verifyPhoneNumber(phone, uiDelegate: nil) { (verificationID, error) in
                    
                    if let _ = error {
                         Alerts.DisplayDefaultAlert(title: "", message: "Try in another time", object: object, actionType: .default)
                        compeletion(false)
                    }else {
                        Alerts.DisplayActionSheetAlertWithButtonName(title: "", message: "We've sent you a verification code", object: object, actionType: .default, name: "OK")
                        
                        if let verificationID =  verificationID {
                            PersistentStructure.addKey(key: "verificationID", value: verificationID)
                        }
                        compeletion(true)
                    }
                }
                
            } else {
                // PHONE EXIST
                Alerts.DisplayDefaultAlert(title: "", message: "Phone number already exists", object: object, actionType: .default)
            }
        }
        
    }
    
    
    class func changeMobileForCoach(phone: String, object: UIViewController, compeletion: @escaping (_ error: Bool) -> () ) {
        
        var phone = phone
        
        CoachCheckPhoneModel.checkPhone(object: object, params: ["Phone": phone]) { (response, error) in
            if error == false {
                
                phone.removeFirst() ; phone = "+20" + phone
                PhoneAuthProvider.provider().verifyPhoneNumber(phone, uiDelegate: nil) { (verificationID, error) in
                    
                    if let _ = error {
                         Alerts.DisplayDefaultAlert(title: "", message: "Try in another time", object: object, actionType: .default)
                        compeletion(false)
                    }else {
                        Alerts.DisplayActionSheetAlertWithButtonName(title: "", message: "We've sent you a verification code", object: object, actionType: .default, name: "OK")
                        
                        if let verificationID =  verificationID {
                            PersistentStructure.addKey(key: "verificationID", value: verificationID)
                        }
                        compeletion(true)
                    }
                }
                
            }else {
                // PHONE EXIST
                Alerts.DisplayDefaultAlert(title: "", message: "Phone number already exists", object: object, actionType: .default)
            }
        }
        
    }
    
}


