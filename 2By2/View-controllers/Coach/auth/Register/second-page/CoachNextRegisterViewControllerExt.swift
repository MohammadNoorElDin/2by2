//
//  CoachNextRegisterViewControllerExt.swift
//  2By2
//
//  Created by mac on 11/1/18.
//  Copyright © 2018 personal. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

extension CoachNextRegisterViewController {
    
    func configCell(table: UITableView) {
        table.allowsSelection = false
        table.backgroundColor = UIColor.clear
        table.separatorInset = .zero
        table.contentInset = .zero
    }
    
    // MARK :- prepareToSendDataToNextRegisterViewController
    func validateCoachModelData() -> Bool {
        
        // check if email
        guard let email = emailTF.text, Validation.isValidEmail(email) else {
            Alerts.DisplayActionSheetAlert(title: "", message: Messenger.wrongEmail, object: self, actionType: .default)
            return false
        }
        
        // check if phone
        guard let phone = phoneNumberTF.text, Validation.isValidPhoneNumber(phone) else {
            Alerts.DisplayActionSheetAlert(title: "", message: Messenger.wrongPhoneNumber, object: self, actionType: .default)
            return false
        }
        
        // check if password
        guard let password = passwordTF.text, Validation.isBetween(str: password, from: 6, to: 100) else {
            Alerts.DisplayActionSheetAlert(title: "", message: Messenger.wrongPassword, object: self, actionType: .default)
            return false
        }
        
        // check if specializations.count > 0
        if locationsTableViewCell.locations.count <= 0 {
            Alerts.DisplayActionSheetAlert(title: "", message: Messenger.locationsEmpty, object: self, actionType: .default)
            return false
        }
        
        coachModel.phoneNUmber = phone
        coachModel.password = password
        coachModel.email = email
        coachModel.locations = Generate.generateIntKeysFromIntDictionary(dic: locationsTableViewCell.locations)
        
        return true 
    }
    
    func sendRequestToRegister(phone: String) {
        
        let credential = PhoneAuthProvider.provider().credential(
            withVerificationID: PersistentStructure.getKey(key: "verificationID")!,
            verificationCode: self.confirmationNumber.text!)
        
        Auth.auth().signInAndRetrieveData(with: credential) { (user, error) in
            
            if let error = error as NSError? {
                Alerts.DisplayActionSheetAlertWithButtonName(title: "", message: error.localizedDescription, object: self, actionType: .default, name: "OK")
                
                return
            } else {
                
                var params = [
                    CoachCreateModel.CoachCreatePostRequest.Params.Name : self.coachModel.fullName,
                    CoachCreateModel.CoachCreatePostRequest.Params.Age : self.coachModel.age,
                    CoachCreateModel.CoachCreatePostRequest.Params.HaveAcar : self.coachModel.doYouHave,
                    CoachCreateModel.CoachCreatePostRequest.Params.Phone : self.coachModel.phoneNUmber,
                    CoachCreateModel.CoachCreatePostRequest.Params.Password : self.coachModel.password,
                    CoachCreateModel.CoachCreatePostRequest.Params.Email : self.coachModel.email,
                    CoachCreateModel.CoachCreatePostRequest.Params.Fk_Gender : self.coachModel.gender,
                    CoachCreateModel.CoachCreatePostRequest.Params.FK_LoginType : 3,
                    CoachCreateModel.CoachCreatePostRequest.Params.Locations.structName : self.coachModel.locations,
                    CoachCreateModel.CoachCreatePostRequest.Params.FirstCategoryPrograms.structName : self.coachModel.specializations,
                    CoachCreateModel.CoachCreatePostRequest.Params.Languages.structName : self.coachModel.spokenLanguages,
                    ] as [String: Any]
                
                if self.ProviderIdFromPlugin != nil && self.LoginTypeFromPlugin != 3 {
                    params[CoachCreateModel.CoachCreatePostRequest.Params.ProviderID] = self.ProviderIdFromPlugin!
                    params.updateValue(self.LoginTypeFromPlugin!, forKey: CoachCreateModel.CoachCreatePostRequest.Params.FK_LoginType)
                    if self.LoginTypeFromPlugin == 1 {
                        // FACEBOOK
                        params[CoachCreateModel.CoachCreatePostRequest.Params.Image] =
                        "https://graph.facebook.com/\(self.ProviderIdFromPlugin!)/picture?type=large"
                    }
                    
                    if self.LoginTypeFromPlugin == 2 {
                        // GMAIL
                        if CoachDataUsedThroughTheApp.coachImage.isEmpty == false {
                            params[CoachCreateModel.CoachCreatePostRequest.Params.Image] =
                                CoachDataUsedThroughTheApp.coachImage
                        }
                    }
                }
                
                
                CoachCreateModel.CoachCreatePostRequest.CoachPostCreateRequest(object: self, params: params) { (user, error) in
                    
                    if error == true {
                        Alerts.DisplayDefaultAlert(title: "", message: (user[Constants.Message]?.string)!, object: self, actionType: .default)
                        
                        return
                    } else {
                        // USER ADDED TO THE DATABASE NOW YOU HAVE TO SAVE HIS/HER DATA INSIDE THE USERDEFAULTS
                        
                        // THIS IN CASE USER LOGGED IN USING ANY PLUGIN
                        if let ProviderID = user[CoachLoginModel.returnData.Coach.structName]?[CoachLoginModel.returnData.Coach.ProviderID].string, let coachId = user[CoachLoginModel.returnData.Coach.structName]?[CoachLoginModel.returnData.Coach.Id].int {
                            
                            PersistentStructure.saveData(data: [
                                PersistentStructureKeys.ProviderID : ProviderID,
                                PersistentStructureKeys.coachId : coachId,
                                PersistentStructureKeys.coachLoginType : self.LoginTypeFromPlugin!
                                ]
                            )
                            
                        } else {
                            // USER SIGNNED IN USING THE NORMAL WAY
                            let coach = user[CoachLoginModel.returnData.Coach.structName]
                            if let phone = coach?[CoachLoginModel.returnData.Coach.Phone].string,
                                let password = coach?[CoachLoginModel.returnData.Coach.Password].string,
                                let coachId = coach?[CoachLoginModel.returnData.Coach.Id].int {
                                
                                PersistentStructure.saveData(data: [PersistentStructureKeys.coachPhone : phone, PersistentStructureKeys.coachPassword : password, PersistentStructureKeys.coachLoginType : 3,
                                                                    PersistentStructureKeys.coachId : coachId
                                    ])
                                
                                // MOVE TO THE SECOND STORYBOARD
                            }
                        }
                        
                        CoachDataUsedThroughTheApp.saveCoachInfo(user: user)
                        
                        // MOVE TO THE HOME-COACH STORYBOARD
                        self.present(MoveToStoryBoard.moveTo(sb: MoveToStoryBoard.home_coach), animated: true, completion: nil )
                        
                    } // END OF RESPONSE
                    
                }
                
            }
        }
        
    }
}

extension CoachNextRegisterViewController: UITabBarDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let num = Locations?.count  {
            if num % 2 == 0 {
                return num / 2
            }else {
                return ( num + 1 ) / 2
            }
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: locations_nib_identifier, for: indexPath) as! locationsTableViewCell
        
        cell.backgroundColor = UIColor.clear
        
        let num = ( indexPath.row * 2 )
        
        if Locations.indices.contains( num  ) {
            let lh = Locations[num]
            if Locations.indices.contains( num + 1 ) {
                let rh = Locations[num + 1]
                cell.configCell(lbLocation: lh, rbLocation: rh)
            }else {
                cell.configCell(lbLocation: lh, rbLocation: nil)
            }
        }
        
        return cell
    }
    
}
