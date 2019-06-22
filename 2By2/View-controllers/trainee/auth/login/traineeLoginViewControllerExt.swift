//
//  traineeLoginViewControllerExt.swift
//  2By2
//
//  Created by rocky on 11/21/18.
//  Copyright © 2018 personal. All rights reserved.
//

import UIKit
import SwiftyJSON

extension traineeLoginViewController {

    func login(phone: String, password: String, logintype: Int?) {
        
        guard !phone.isEmpty, Validation.isValidPhoneNumber(phone) else {
            Alerts.DisplayActionSheetAlert(title: "", message: Messenger.wrongPhoneNumber, object: self, actionType: .cancel)
            return
        }
        
        guard !password.isEmpty, Validation.isBetween(str: password, from: 6, to: 100)  else {
            Alerts.DisplayActionSheetAlert(title: "", message: Messenger.emptyPassword, object: self, actionType: .cancel)
            return
        }
        
        
        
        let params = [UserLoginModel.Params.Phone: phone, UserLoginModel.Params.Password: password,
                      UserLoginModel.Params.Fk_LoginType: logintype ?? 3 ] as [String : Any]
        
        UserLoginModel.UserLogin(params: params, object: self, completion: { (response, error) in
            
            // I THINK U WILL NEED TO SEE THE RETURNED DATA AND SAVE THE COACH ID IN THE
            // USER DEFAULTS
            
            if error == true {
                // Display Alert To The User
                Alerts.DisplayDefaultAlert(title: "", message: Constants.errorLoginMessage, object: self, actionType: .cancel)
                
                return
            }
            
            
            if let phone = response[UserLoginModel.returnData.User.Phone]?.string,
                let password = response[UserLoginModel.returnData.User.Password]?.string {
                
                PersistentStructure.saveData(data: [PersistentStructureKeys.userPhone : phone, PersistentStructureKeys.userPassword : password, PersistentStructureKeys.userLoginType : 3])
            }
            
            UserDataUsedThroughTheApp.saveUserInfo(user: response)
            
            
            // MOVE TO THE MAIN STORYBOARD
            self.present(MoveToStoryBoard.moveTo(sb: MoveToStoryBoard.trainee_home), animated: true, completion: nil)
            
        })
    }
    
    func loginWithPlugin(ProviderId id: String, loginType: Int, name: String?, email: String?){
        
        let params = [
            UserLoginModel.Params.Fk_LoginType: loginType,
            UserLoginModel.Params.ProviderID: id
        ] as [String : Any]
        
        UserLoginModel.UserLogin(params: params, object: self, completion: { (user, error) in
            
            if let ProviderID = user[UserLoginModel.returnData.User.ProviderID]?.string {
                
                PersistentStructure.saveData(data: [
                    PersistentStructureKeys.ProviderID : ProviderID,
                    PersistentStructureKeys.userLoginType : loginType
                    ]
                )
                
                UserDataUsedThroughTheApp.saveUserInfo(user: user)
                self.present(MoveToStoryBoard.moveTo(sb: MoveToStoryBoard.trainee_home), animated: true, completion: nil)
                
            }else {
                // REGISTER FIRST BECAUSE YOU ARE NOT SIGNED IN
                UserDataUsedThroughTheApp.userFullName = name ?? ""
                UserDataUsedThroughTheApp.userEmailAddress = email ?? ""
                self.ProviderIdFromPlugin = id
                self.LoginTypeFromPlugin = loginType
                self.performSegue(withIdentifier: segueIdentifier.toTraineeRegisterViewControllerSegue , sender: self)
            }
            
        })
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == segueIdentifier.toTraineeRegisterViewControllerSegue {
            if let dest = segue.destination as? traineeRegisterViewController {
                dest.ProviderIdFromPlugin = self.ProviderIdFromPlugin
                dest.LoginTypeFromPlugin = self.LoginTypeFromPlugin ?? 3
            }
        }
    }
 
    
    func forgetPasswordRequest() {
        
        guard let phone = phoneTF.text, Validation.isValidPhoneNumber(phone) else {
            Alerts.DisplayDefaultAlert(title: "", message: Messenger.wrongPhoneNumber, object: self, actionType: .default)
            return
        }
        
        let params = [ "Phone": phone ]
        
        UserForgetPasswordModel.sendForgetPasswordRequest(object: self, params: params) { (status) in
            if status == false {
                Alerts.DisplayDefaultAlert(title: "", message: "We sent you an sms with a new Password", object: self, actionType: .default)
            }
        }
    }

}
