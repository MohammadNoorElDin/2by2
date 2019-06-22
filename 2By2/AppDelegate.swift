//
//  AppDelegate.swift
//  theGymApp
//
//  Created by mac on 10/23/18.
//  Copyright © 2018 personal. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import UserNotifications
import GoogleSignIn
import IQKeyboardManager
import SideMenuSwift
import Firebase
import OneSignal
import GoogleMaps
import GooglePlaces

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate, OSSubscriptionObserver {
    
    var window: UIWindow?
    var locationManager = CLLocationManager()
    
    /*
     |=============================================================================
     | MARK:- AppDelegate methods
     |=============================================================================
     | 1- didFinishLaunchingWithOptions
     */
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch. 
        
        /*LocalNotification.userGranted { (status) in
            if status == true {
                print("Granted")
            }
        }*/
        
        // notification this class is responsible for it
        // UNUserNotificationCenter.current().delegate = self // this is very important
        
        // Sign with Gmail
        GIDSignIn.sharedInstance().clientID = Constants.GMAIL_KEY
        
        // Keyboard 
        IQKeyboardManager.shared().isEnabled = true
        
        // SIDEMENU
        SideMenuController.preferences.basic.menuWidth = 200
        
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        
        FirebaseApp.configure()
        
        self.setupAppearance()
        
        // oneSignal setting function call
        oneSignal(launchOptions: launchOptions)
        OneSignal.add(self as OSSubscriptionObserver)

        GMSServices.provideAPIKey(Constants.GMK)
        GMSPlacesClient.provideAPIKey(Constants.GMK)
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        
        // Application status bar background
        UIApplication.shared.statusBarView?.backgroundColor = UIColor(rgb: 0xA32F1C)
        
        self.setupAppearance()

        // SKIP ON BOARDING TUTORIAL
        if let displayed = PersistentStructure.getKey(key: "tutorialStatusForUsers"), displayed == "0" {
            window?.rootViewController = MoveToStoryBoard.moveTo(sb: MoveToStoryBoard.LaunchScreen)
        }
        
        if let displayed = PersistentStructure.getKey(key: "tutorialStatusForCoaches"), displayed == "0" {
            window?.rootViewController = MoveToStoryBoard.moveTo(sb: MoveToStoryBoard.LaunchScreen)
        }
        
        return true 
    }
    
    /*
     | MARK:- FACEBOOK
     | ================================================
     | 1- connect App Delegate ...
     */
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        
        return FBSDKApplicationDelegate.sharedInstance().application(application, open: url, sourceApplication: sourceApplication, annotation: annotation)
        
    }
    
    /*
     | MARK:- GMAIL
     | ================================================
     | 1- UIApplicationOpenURLOptionsKey
     | 2- Sign
     | 3- disconnect
     */
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        return GIDSignIn.sharedInstance().handle(url as URL?,
             sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
             annotation: options[UIApplication.OpenURLOptionsKey.annotation])
    }
    
    /*
     |=============================================================================
     | MARK:- Notifications delegate methods
     |=============================================================================
     | 1- userNotificationCenter (didReceive) works when user click the notification
     | 2- userNotificationCenter (willPresent) works when user is in the foreground
     */
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        if response.notification.request.identifier == "testIdentifier" {
            print("yes")
        }
        // when user click or firee the notification something u can do .......
        completionHandler()
    }
    
    // foreground
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .sound])
        
    }
    
    // register for remote notification
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
    }
    
    // did recieve remote notification 
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        print(userInfo)
        
    }
    
    // one Signal setting
    func oneSignal(launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
        let onesignalInitSettings = [kOSSettingsKeyAutoPrompt: false]
        
        var key: String = ""
        
        #if trainee
            key = OneSignal.APP_KEY_FOR_TRAINEES
        #else
            key = OneSignal.APP_KEY_FOR_COACHES
        #endif
        
        OneSignal.initWithLaunchOptions(launchOptions,
                                        appId: key,
                                        handleNotificationAction: nil,
                                        settings: onesignalInitSettings)
        
        OneSignal.inFocusDisplayType = OSNotificationDisplayType.notification;
        
        OneSignal.promptForPushNotifications(userResponse: { accepted in
            print("User accepted notifications: \(accepted)")
        })
        
        let notificationReceivedBlock: OSHandleNotificationReceivedBlock = { notification in
            print("Received Notification: \(notification!.payload.notificationID as Any)")
        }
        
        let notificationOpenedBlock: OSHandleNotificationActionBlock = { result in
            // This block gets called when the user reacts to a notification received
            let payload: OSNotificationPayload = result!.notification.payload
            if payload.additionalData != nil {
                let additionalData = payload.additionalData
                additionalData?.forEach({ (data) in
                    if let _ : String = data.key as? String {
                        
                    }
                })
                
            }
        }
        
        _ = [kOSSettingsKeyAutoPrompt: false,
             kOSSettingsKeyInAppLaunchURL: true]
        
        
        OneSignal.initWithLaunchOptions(launchOptions,
                                        appId: key,
                                        handleNotificationReceived: notificationReceivedBlock,
                                        handleNotificationAction: notificationOpenedBlock,
                                        settings: onesignalInitSettings)
        
        OneSignal.inFocusDisplayType = OSNotificationDisplayType.notification
        
        
        OneSignal.promptForPushNotifications(userResponse: { accepted in
            print("User accepted notifications: \(accepted)")
        })
        
    }
    
    // oneSignal playerId
    
    // After you add the observer on didFinishLaunching, this method will be called when the notification subscription property changes.
    func onOSSubscriptionChanged(_ stateChanges: OSSubscriptionStateChanges!) {
        if !stateChanges.from.subscribed && stateChanges.to.subscribed {
            print("Subscribed for OneSignal push notifications!")
        }
        
        //The player id is inside stateChanges. But be careful, this value can be nil if the user has not granted you permission to send notifications.
        if let playerId = stateChanges.to.userId {
            print(playerId as Any)
        }
        
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {

    }
    
    
    /*
     |==================================================
     | SETUP APPEARANCE
     |==================================================
     | 1- setupAppearance()
     | 2- setupGlobalAppearance()
     */

    
    func setupAppearance() {
        UINavigationBar.appearance().titleTextAttributes = [ NSAttributedString.Key.font: UIFont(name: "nexaBold", size: 15)!]
        //navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        //navigationController?.navigationBar.shadowImage = UIImage()
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
        UINavigationBar.appearance().shadowImage = UIImage()
    }
    
}

/*

1    When Create Reservation  - champ & coach / open upcoming reservation    12/24/2018

2    Not now    12/24/2018

3    Before training with 1 hour  - champ & coach / open upcoming reservation    12/24/2018

4    Change in Reservation Info State ( track coach ) - champ / open track coach    12/24/2018

5    Change in Reservation Info State ( coach start )  - champ / open upcoming reservation    12/24/2018

6    Change in Reservation Info State ( coach finish )  - champ / open past reservation    12/24/2018

7    Change in Reservation Info Agenda - coach  / open upcoming reservation    12/24/2018

8    Delete Upcoming Reservation - coach / open upcoming reservation    12/24/2018

9    Change in Reservation Info State ( installments ) - champ / open payment history    12/24/2018

10    Before BMI reservation with 1 hour  - champ  / nothing    12/24/2018

11    Dashboard bmi result - champ / open measurments    12/24/2018

12    Not Busniss Ready    12/24/2018

13    Not Busniss Ready    12/24/2018

14    Dashboard add user challenge - champ / open challenges    12/28/2018

15    News     12/28/2018
NULL    NULL    NULL
*/
