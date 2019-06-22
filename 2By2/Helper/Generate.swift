//
//  Generate.swift
//  2By2
//
//  Created by mac on 10/24/18.
//  Copyright © 2018 personal. All rights reserved.
//

import Foundation
import SwiftyJSON

class Generate {
    
    class func randomString(length: Int) -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0...length-1).map{ _ in letters.randomElement()! })
    }
    
    class func generateIntKeysFromIntDictionary( dic: [Int: Int] ) -> [Int] {
        var arr = [Int]()
        dic.forEach { (key, value) in
            arr.append(key)
        }
        return arr
    }
    
    class func return30DaysInNames() -> [String] {
        var array = [String]()
        for i in 0...29 {
            let today = Date() //Jun 21, 2017, 7:18 PM
            let thirtyDaysBeforeToday = Calendar.current.date(byAdding: .day, value: i, to: today + 30)!
            let dayInWeek = formattingDate(date: thirtyDaysBeforeToday, format: "EEEE").prefix(3)
            array.append(String(dayInWeek))
        }
        return array
    }
    
    class func return4SimilarDaysIntheMonth(startFrom: Date) -> [String] {
        var array = [String]()
        for i in 0...29 {
            let today = Date() //Jun 21, 2017, 7:18 PM
            let thirtyDaysBeforeToday = Calendar.current.date(byAdding: .day, value: i, to: today + 30)!
            let dateUsed = formattingDate(date: thirtyDaysBeforeToday, format: "MM/dd/YYYY")
            array.append(dateUsed)
        }
        return array
    }
    
    class func formattingDate(date: Date, format: String) -> String {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = format
        return inputFormatter.string(from: date)
    }
    
    class func return30DaysInDates() -> [String] {
        var array = [String]()
        for i in 0...29 {
            let today = Date() //Jun 21, 2017, 7:18 PM
            let thirtyDaysBeforeToday = Calendar.current.date(byAdding: .day, value: i, to: today + 30)!
            let dateUsed = formattingDate(date: thirtyDaysBeforeToday, format: "MM/dd/YYYY")
            array.append(dateUsed)
        }
        return array
    }
    
    class func return30DaysInDates2() -> [String] {
        var array = [String]()
        for i in 0...29 {
            let today = Date() //Jun 21, 2017, 7:18 PM
            let thirtyDaysBeforeToday = Calendar.current.date(byAdding: .day, value: i, to: today + 30)!
            let dateUsed = formattingDate(date: thirtyDaysBeforeToday, format: "dd/MM/YYYY")
            array.append(dateUsed)
        }
        return array
    }
    
    class func convertStrToDate(str: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "mm/dd/yyyy"
        return dateFormatter.date(from: str) ?? Date()
    }
    
    
    class func StrToDate(str: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "mm/dd/yyyy"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        var date = dateFormatter.date(from: str)!
        date = Calendar.current.date(byAdding: .day, value: 1, to: date)!
        return date 
    }
    
    class func convertStrToDateWithComponents(str: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy HH:mm"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        let str = str.replacingOccurrences(of: " -", with: "", options: .caseInsensitive, range: nil)
        let date = dateFormatter.date(from: str)!
        // date = Calendar.current.date(byAdding: .day, value: 1, to: date)!
        // date = Calendar.current.date(byAdding: .hour, value: 2, to: date)!
        return date
        
    }
    
    class func getToday() -> String {
        let dateUsed = formattingDate(date: Date(), format: "MM/dd/YYYY")
        return dateUsed
    }
    
    
    class func _24hours(int: Int) -> String {
        var int = int
        /*if int > 12 {
            int -= 12
        }*/
        return Generate.twoDigit(int: int)
    }
    
    static func twoDigit(int: Int) -> String {
        let int = String(int)
        
        if int.count == 1 {
            return "0" + int
        }else {
            return int
        }
    }
    
    static var dayStatus : String {
        get {
            let hour = Calendar.current.component(.hour, from: Date())
            var str: String = ""
            switch hour {
            case 1..<5 :
                str = "Good Evening,"
                break
            case 5..<12 :
                str = "Good Morning,"
                break
            case 12..<17 :
                str = "Good Afternoon,"
                break
            case 17..<25 :
                str = "Good Evening,"
                break
            default:
                str = "Good Morning,"
                break
            }
            return str 
        }
    }
    
}
