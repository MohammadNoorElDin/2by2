//
//  Validation.swift
//  theGymApp
//
//  Created by mac on 10/23/18.
//  Copyright © 2018 personal. All rights reserved.
//

import Foundation

class Validation {
    
    class func isValidPhoneNumber(_ phone:String) -> Bool {
        return phone.hasPrefix("01") && phone.count == 11
    }
    
    class func isValidEmail(_ email:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: email)
    }
    
    class func isBiggerThan(str: String, count: Int) -> Bool {
        return (str.count > count)
    }
    
    class func isSmallerThan(str: String, count: Int) -> Bool  {
        return (str.count < count)
    }
    
    class func isBetween(str: String, from: Int, to: Int) -> Bool {
        let length = str.count
        return (length >= from && length <= to)
    }
    
    class func isBetween(from: Int, to: Int, number: Int) -> Bool {
        
        if from <= number && to >= number {
            return true
        }
        
        return false
    }
}
