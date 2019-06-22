//
//  Alerts.swift
//  theGymApp
//
//  Created by mac on 10/24/18.
//  Copyright © 2018 personal. All rights reserved.
//

import Foundation
import UIKit

class Alerts: UIViewController {
    
    /*
     |====================================
     | MARK:- actionSheet alerts
     |====================================
     | 1- with title and message
     | 2- DisplayActionSheetAlertWithAction
     | 3- DisplayActionSheetAlertWithActions
     */
    
    class func DisplayActionSheetAlert(title titleController: String, message: String, object: UIViewController, actionType: UIAlertAction.Style ) {
        
        // create action
        let action = UIAlertAction(title: (actionType == .default) ? "OK" : "Cancel", style: actionType, handler: nil)
        // send action to alert and display
        self.createAlert(title: titleController, message: message, object: object, actionType: actionType, preferredStyle: .actionSheet, actions: [action] )
    }
    
    class func DisplayActionSheetAlertWithButtonName(title titleController: String, message: String, object: UIViewController, actionType: UIAlertAction.Style, name: String ) {
        
        // create action
        let action = UIAlertAction(title: name, style: actionType, handler: nil)
        // send action to alert and display
        self.createAlert(title: titleController, message: message, object: object, actionType: actionType, preferredStyle: .actionSheet, actions: [action] )
    }
    
    class func DisplayActionSheetAlertWithAction(title titleController: String, message: String, object: UIViewController, actionType: UIAlertAction.Style, completion: @escaping () -> () ) {
        
        // create action
        let action = UIAlertAction(title: (actionType == .default) ? "OK" : "Cancel", style: actionType) { (action) in
            // execute something
            completion()
        }
        // send action to alert and display
        self.createAlert(title: titleController, message: message, object: object, actionType: actionType, preferredStyle: .actionSheet, actions: [action])
    }
    
    class func DisplayActionSheetAlertWithActions(title titleController: String, message: String, object: UIViewController, buttons: [String: UIAlertAction.Style], actionType: UIAlertAction.Style, completion: @escaping (_ buttonClicked: String) -> Void ) {
        
        var actions = [UIAlertAction]()
        
        buttons.forEach { (buttonName, buttonType) in
            // create action
            let action = UIAlertAction(title: buttonName, style: buttonType) { (action) in
                completion(buttonName)
            }
            actions.append(action)
        }
        
        // send action to alert and display
        self.createAlert(title: titleController, message: message, object: object, actionType: actionType,preferredStyle: .actionSheet, actions: actions)
    }
    
    /*
     |====================================
     | MARK:- normal alerts
     |====================================
     | 1- with title and message
     | 2- DisplayDefaultAlertWithAction
     | 3- DisplayDefaultAlertWithActions
     */
    
    class func DisplayDefaultAlert(title titleController: String, message: String, object: UIViewController, actionType: UIAlertAction.Style) {
        
        // create action
        let action = UIAlertAction(title: "Cancel", style: actionType, handler: nil)
        
        // send action to alert and display
        self.createAlert(title: titleController, message: message, object: object, actionType: actionType, preferredStyle: .alert, actions: [action])
    }
    
    
    
    class func DisplayDefaultAlertWithAction(title titleController: String, message: String, object: UIViewController, actionType: UIAlertAction.Style, completion: @escaping () -> () ) {

        // create action
        let action = UIAlertAction(title: (actionType == .default) ? "Default" : "Cancel", style: actionType) { (action) in
            completion()
        }
        // send action to alert and display
        self.createAlert(title: titleController, message: message, object: object, actionType: actionType, preferredStyle: .alert, actions: [action])
    }
    
    class func DisplayDefaultAlertWithActions(title titleController: String, message: String, object: UIViewController, buttons: [String: UIAlertAction.Style], actionType: UIAlertAction.Style, completion: @escaping (_ buttonClicked: String) -> Void ) {
        
        var actions = [UIAlertAction]()
        
        buttons.forEach { (buttonName, buttonType) in
            // create action
            let action = UIAlertAction(title: buttonName, style: buttonType) { (action) in
                completion(buttonName)
            }
            actions.append(action)
        }
     
        // send action to alert and display
        self.createAlert(title: titleController, message: message, object: object, actionType: actionType, preferredStyle: .alert, actions: actions)
    }
    
    
    /*
     | ====================================
     | HELPER FUNCTIONS
     | ====================================
     | 1- createAlert
     */
    
    static private func createAlert(title titleController: String, message: String, object: UIViewController,actionType: UIAlertAction.Style, preferredStyle: UIAlertController.Style, actions: [UIAlertAction]) {

        
        // create alert
        let alert = UIAlertController(title: titleController, message: message, preferredStyle: preferredStyle)
        
        actions.forEach { (action) in
            alert.addAction(action)
        }
        // display alert
        UILabel.appearance(whenContainedInInstancesOf: [UIAlertController.self]).numberOfLines = 10

        object.present(alert, animated: true, completion: nil)
    }
    
    
}
