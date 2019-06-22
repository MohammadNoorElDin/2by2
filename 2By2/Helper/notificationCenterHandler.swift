//
//  notificationCenterHandler.swift
//  2By2
//
//  Created by rocky on 2/27/1440 AH.
//  Copyright © 1440 AH personal. All rights reserved.
//

import UIKit

class NotificationHandler : UIViewController {
    
    class func addObserverHere(object: UIViewController, name: Notification.Name ,completion: @escaping () -> ()) {
        NotificationCenter.default.addObserver(forName: name, object: object, queue: OperationQueue.main) { (notification) in
            completion()
        }
    }/**/
    
    class func postNotification(name: Notification.Name , object: UIViewController) {
        NotificationCenter.default.post(name: name, object: object)
    }
}
