//
//  traineeLoginViewController.swift
//  trainee
//
//  Created by rocky on 11/21/18.
//  Copyright © 2018 personal. All rights reserved.
//

import UIKit
import GoogleSignIn

class traineeLoginViewController: UIViewController, GIDSignInDelegate, GIDSignInUIDelegate  {

    @IBOutlet weak var phoneTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    
    /*
     |------------------------------------------------------------
     | IN CASE USER LOGGED IN USING PLUGISN ( FACEBOOK | GMAIL )
     |------------------------------------------------------------
     | 1- fullName
     | 2- email >> send to the nextViewController
     | 3- ProviderIdFromPlugin
     | 4- LoginTypeFromPlugin
     */
    var ProviderIdFromPlugin: String? = nil
    var LoginTypeFromPlugin: Int? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func loginButtonClicked(_ sender: UIButton) {
        login(phone: phoneTF.text ?? "" , password: passwordTF.text ?? "", logintype: 3)
    }
    
    @IBAction func faceButtonClicked(_ sender: UIButton) {
        FacebookHandler.tryToLoginWithFacebook(viewController: self) { (result) in
            if let result = result {
                if let id = result["id"] as? String {
                    if let name = result["name"] as? String, let email = result["email"] as? String {
                        
                        self.loginWithPlugin(ProviderId: id, loginType: 1, name: name, email: email)
                    }
                }
            }
        }
    }
    
    
    @IBAction func gmailButtonClicked(_ sender: AnyObject) {
        GIDSignIn.sharedInstance().delegate=self
        GIDSignIn.sharedInstance().uiDelegate=self
        GIDSignIn.sharedInstance().signIn()
    }
    
    @IBAction func forgetButtonClicked(_ sender: UIButton) {
        self.forgetPasswordRequest()
    }
    
    @IBAction func ShowPasswordClicked(_ sender: UIButton) {
        passwordTF.displayPassword()
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if error != nil { print(error); stopAnimating() ;return }
        
        
        if user.profile.hasImage {
            // crash here !!!!!!!! cannot get imageUrl here, why?
            // let imageUrl = user.profile.imageURLWithDimension(120)
            let imageUrl = signIn.currentUser.profile.imageURL(withDimension: 120)
            let image = imageUrl!.absoluteString
            UserDataUsedThroughTheApp.userImage = image
        }
        
        let userId = user.userID
        let name = user.profile.name!
        let email = user.profile.email!
        self.loginWithPlugin(ProviderId: userId!, loginType: 2, name: name, email: email)
        
    }

}
