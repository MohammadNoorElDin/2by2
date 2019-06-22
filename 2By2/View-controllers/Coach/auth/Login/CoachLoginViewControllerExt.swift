//
//  CoachLoginViewControllerExt.swift
//  2By2
//
//  Created by mac on 10/29/18.
//  Copyright © 2018 personal. All rights reserved.
//

import Foundation
import SwiftyJSON

extension CoachLoginViewController {
    
    func login(phone: String, password: String, logintype: Int?) {
        
        guard !phone.isEmpty, Validation.isValidPhoneNumber(phone) else {
            
            Alerts.DisplayActionSheetAlert(title: "", message: Messenger.wrongPhoneNumber, object: self, actionType: .cancel)
            return
        }
        
        guard !password.isEmpty, Validation.isBetween(str: password, from: 6, to: 100)  else {
            
            Alerts.DisplayActionSheetAlert(title: "", message: Messenger.emptyPassword, object: self, actionType: .cancel)
            
            return
        }
        
        
        
        let params = [CoachLoginModel.Params.Phone: phone, CoachLoginModel.Params.Password: password,
                      CoachLoginModel.Params.Fk_LoginType: logintype ?? 3 ] as [String : Any]
        
        CoachLoginModel.CoachLogin(params: params, object: self, completion: { (user, error) in
            
            // I THINK U WILL NEED TO SEE THE RETURNED DATA AND SAVE THE COACH ID IN THE
            // USER DEFAULTS
            
            if error == true {
                // Display Alert To The User
                Alerts.DisplayDefaultAlert(title: "", message: Constants.errorLoginMessage, object: self, actionType: .cancel)
                
                return
            }

            
            let coach = user[CoachLoginModel.returnData.Coach.structName]
            
            if let phone = coach?[CoachLoginModel.returnData.Coach.Phone].string,
                let password = coach?[CoachLoginModel.returnData.Coach.Password].string,
                    let coachId = coach?[CoachLoginModel.returnData.Coach.Id].int {
                        PersistentStructure.saveData(data: [PersistentStructureKeys.coachPhone : phone, PersistentStructureKeys.coachPassword : password, PersistentStructureKeys.coachLoginType : 3,
                            PersistentStructureKeys.coachId : coachId,
                        ])
                }
            
            CoachDataUsedThroughTheApp.saveCoachInfo(user: user)
            
            
            // MOVE TO THE MAIN STORYBOARD
            self.present(MoveToStoryBoard.moveTo(sb: MoveToStoryBoard.home_coach), animated: true, completion: nil)
            
        })
    }
    
    func checkIfUserPasswordStillValid() {
        
        PersistentStructure.getObject(key: PersistentStructureKeys.coachLoginType) { (value, exist) in
            if exist == true {
                if let type = value as? Int {
                    
                    if type == 1 || type == 2 {
                        // USER LOGGED IN USING FACEBOOK OR GMAIL
                        // USER LOGGGED IN USING DEFAULT WAY
                        let providerId = PersistentStructure.getKey(key: PersistentStructureKeys.ProviderID)!
                        let LoginType = Int(type)
                        self.loginWithPlugin(ProviderId: providerId, loginType: LoginType, name: nil, email: nil)
                    }else if type == 3 {
                        // USER LOGGGED IN USING DEFAULT WAY
                        if let phone = PersistentStructure.getKey(key: PersistentStructureKeys.coachPhone) {
                            if let pass = PersistentStructure.getKey(key: PersistentStructureKeys.coachPassword) {
                                self.login(phone: phone, password: pass, logintype: 3)
                            }
                        }
                        
                    }else {
                        
                    }
                }
            }
        } // login Type ......
        
    }
    
    func loginWithPlugin(ProviderId id: String, loginType: Int, name: String?, email: String?){
        
        let params = [
            CoachLoginModel.Params.Fk_LoginType: loginType,
            CoachLoginModel.Params.ProviderID: id
        ] as [String : Any]
     
        CoachLoginModel.CoachLogin(params: params, object: self, completion: { (user, error) in
            
            if let ProviderID = user[CoachLoginModel.returnData.Coach.structName]?[CoachLoginModel.returnData.Coach.ProviderID].string, let coachId = user[CoachLoginModel.returnData.Coach.structName]?[CoachLoginModel.returnData.Coach.Id].int {
                
                PersistentStructure.saveData(data: [
                         PersistentStructureKeys.ProviderID : ProviderID,
                         PersistentStructureKeys.coachId : coachId,
                         PersistentStructureKeys.coachLoginType : loginType
                    ]
                )
               
                CoachDataUsedThroughTheApp.saveCoachInfo(user: user)
                self.present(MoveToStoryBoard.moveTo(sb: MoveToStoryBoard.home_coach), animated: true, completion: nil)
                
            }else {
                // REGISTER FIRST BECAUSE YOU ARE NOT SIGNED IN
                self.fullNameFromPlugin = name
                self.emailFromPlugin = email
                self.ProviderIdFromPlugin = id
                self.LoginTypeFromPlugin = loginType
                
                self.performSegue(withIdentifier: segueIdentifier.toRegisterViewControllerSegue , sender: self)
            }
            
        })
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == segueIdentifier.toRegisterViewControllerSegue {
            if let dest = segue.destination as? CoachRigsterViewController {
                dest.fullNameFromPlugin = self.fullNameFromPlugin
                dest.emailFromPlugin = self.emailFromPlugin
                dest.ProviderIdFromPlugin = self.ProviderIdFromPlugin
                dest.LoginTypeFromPlugin = self.LoginTypeFromPlugin
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
    
} // end of the class
