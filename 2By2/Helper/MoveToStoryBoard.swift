//
//  MoveTo.swift
//  2By2
//
//  Created by rocky on 11/11/18.
//  Copyright © 2018 personal. All rights reserved.
//

import UIKit

class MoveToStoryBoard {
    
    /*
     ||*********************************************
     || storyBoard names
     ||*********************************************
     || 1- auth
     || 2- home-coach
     */
    
    static let auth = UIStoryboard(name: "auth", bundle: nil)
    static let home_coach = UIStoryboard(name: "home-coach", bundle: nil)
    
    static let trainee_auth = UIStoryboard(name: "trainee-auth", bundle: nil)
    static let trainee_home = UIStoryboard(name: "trainee-home", bundle: nil)
    static let trainee_onboarding = UIStoryboard(name: "onboarding", bundle: nil)
    static let LaunchScreen = UIStoryboard(name: "LaunchScreen", bundle: nil)
    
    class func moveTo(sb: UIStoryboard, storyBoardId: String? = nil) -> UIViewController {
        
        let tab : UIViewController!
        
        if let sbId = storyBoardId {
            tab = sb.instantiateViewController(withIdentifier: sbId)
        }else {
            tab = sb.instantiateInitialViewController()
        }
        
        return tab
    }
}
