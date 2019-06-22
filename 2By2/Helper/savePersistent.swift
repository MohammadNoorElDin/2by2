//
//  savePersistent.swift
//  2By2
//
//  Created by mac on 10/26/18.
//  Copyright © 2018 personal. All rights reserved.
//

import Foundation

class PersistentStructure {
    
    static let ud =  UserDefaults.standard
    
    // it takes dictionary
    class func saveData(data: [String: Any]) {
        data.forEach { (key, value) in
            self.ud.set(value, forKey: key)
        }
    }
    
    // get value and data ["Int", "ahmed.sam.20019@gmail.com"]
    class func getObject(key: String, completion: @escaping (_ value: Any?,_ exist: Bool) -> ()) {
        DispatchQueue.global(qos: .userInteractive).async {
            if let exist = self.ud.object(forKey: key) {
                DispatchQueue.main.async {
                    completion(exist, true)
                }
            }else {
                completion(nil, false)
            }
        }
    }
    
    // delete userDefaults key
    class func deleteKey(key: String) {
        self.ud.removeObject(forKey: key)
    }
    
    // set or update value (one value)
    class func addKey(key: String, value: Any) {
        self.ud.set(value, forKey: key)
    }
    
    class func getKey(key: String) -> String? {
        return self.ud.object(forKey: key) as? String
    }
    
    class func getKeyInt(key: String) -> Int? {
        return self.ud.object(forKey: key) as? Int
    }
    
    class func removeAll(completion: @escaping () -> ()) {
        DispatchQueue.global(qos: .userInteractive).async {
            let domain = Bundle.main.bundleIdentifier!
            UserDefaults.standard.removePersistentDomain(forName: domain)
            UserDefaults.standard.synchronize()
            
            #if trainee
                PersistentStructure.addKey(key: "tutorialStatusForUsers", value: "0") // display again
            #else
                PersistentStructure.addKey(key: "tutorialStatusForCoaches", value: "0") // display again
            #endif
            
            DispatchQueue.main.async {
                completion()
            }
        }
    }
    
}


/*
 | =============================================
 | user
 | =============================================
 | 1- coachEmail
 | 2- coachPassword
 | 3- coachLoginType
 | 4- coachEmail
 */

struct PersistentStructureKeys {
    
    static let coachPhone: String = "coachPhone"
    static let coachId: String = "coachId"
    static let coachPassword: String = "coachPassword"
    static let coachLoginType: String = "coachLoginType"
    
    static let userPhone: String = "userPhone"
    static let userId: String = "userId"
    static let userPassword: String = "userPassword"
    static let userLoginType: String = "userLoginType"
    
    
    static let ProviderID: String = "ProviderID"
    
}
