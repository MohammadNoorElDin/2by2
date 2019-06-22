//
//  facebookHandler.swift
//  theGymApp
//
//  Created by mac on 10/23/18.
//  Copyright © 2018 personal. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import FBSDKCoreKit

class FacebookHandler {
    
    // MARK: - you should send your current view Controller
    class func tryToLoginWithFacebook(viewController: UIViewController, completion: @escaping (_ result: [String: AnyObject]? ) -> () ) {
        
        let fbLoginManager: FBSDKLoginManager = FBSDKLoginManager()
        fbLoginManager.logIn(withReadPermissions: ["email"], from: viewController) { (result, error) in
            
            if error == nil {
                
                if result?.grantedPermissions != nil {
                    
                    if (result?.grantedPermissions.contains("email"))! {
                        
                        self.getFacebookData(completion: { (result) in
                            completion(result)
                        })
                    }
                }
                
            } else {
                
                print(error as Any)
                print(error?.localizedDescription as Any)
                
            }
        }
    }
    
    private class func getFacebookData(completion: @escaping (_ result: [String: AnyObject]?) -> ()) {
        if (FBSDKAccessToken.current() != nil) {
            
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields" :"id, name, email"])?.start(completionHandler: { (connection, result, error) in
                
                if error == nil {
                    let result = result as! [String: AnyObject]
                    
                    completion(result)
                }
            })
        }
    }
    
}
