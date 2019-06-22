//
//  LocalNotification.swift
//  2By2
//
//  Created by mac on 10/26/18.
//  Copyright © 2018 personal. All rights reserved.
//

import Foundation
import UserNotifications
import UIKit

class LocalNotification {
    
    let content = UNMutableNotificationContent()
    var body : String!
    var title : String!
    var sound : UNNotificationSound?
    
    func sendNotificationToUser(timeInterval: TimeInterval, identifier: String) {
        
        // three things u need to push local notification
        // content
        content.body = body
        content.title = title
        content.badge = UIApplication.shared.applicationIconBadgeNumber + 1 as NSNumber
        content.sound = (sound != nil) ? sound : UNNotificationSound.default
        
        // trigger
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: true)
        
        // request
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
    
    // user allowed to send notification
    class func userGranted(completion : @escaping (_ status: Bool) -> ()) {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
            if error == nil {
                print("user granted ")
                completion(true)
            }else {
                print("user refused notifications")
                completion(false)
            }
        }
    }
    
    
}
