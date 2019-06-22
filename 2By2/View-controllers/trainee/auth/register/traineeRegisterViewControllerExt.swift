//
//  traineeRegisterViewControllerExt.swift
//  trainee
//
//  Created by rocky on 11/21/18.
//  Copyright © 2018 personal. All rights reserved.
//

import UIKit

extension traineeRegisterViewController {
    
    func getUserCreateData() {
        
        
        UserCreateModel.UserCreateGetRequest.UserGetCreateRequest(object: self) { (response, error) in
            if error == true {
                // ERROR MESSAGE
                Alerts.DisplayActionSheetAlert(title: "", message: ((response[Constants.Message]?.string)!), object: self, actionType: .default)
                 // THIS SHOULDNOT BE HERE IN THE NEXT PROJECTS
                return
            }else {
                // DATA FETCHED
                
                if let genders = response[UserCreateModel.UserCreateGetRequest.returnData.Data.Genders.structName]?.array {
                    
                    genders.forEach({ (gender) in
                        if let name = gender[UserCreateModel.UserCreateGetRequest.returnData.Data.Genders.Name].string, let id = gender[UserCreateModel.UserCreateGetRequest.returnData.Data.Genders.Id].int {
                            
                            let genderModel = GenderModel(id: id, name: name)
                            self.genders.append(genderModel)
                        }
                    })
                } // END OF GENDERS
                
                if let GenderTypes = response[UserCreateModel.UserCreateGetRequest.returnData.Data.ShapeGenderTypes.structName]?.array {
                    self.ShapeGenderTypes = GenderTypes
                }
                
                //mark:- set default gender and age to display intial shapes
                self.selectedAge = 7
                self.selectedGender = 1
                self.DisplayShape()
                self.genderButton.setTitle("    \(self.genders[0].name)", for: .normal)
                self.ageButton.setTitle("    \(self.selectedAge)", for: .normal)
                
            }
            
        }
    }
    func validateUserData() -> Bool {
        
        guard let fullName = fullNameTF.text, !fullName.isEmpty else {
            Alerts.DisplayActionSheetAlert(title: "", message: Messenger.emptyName, object: self, actionType: .default)
            return false
        }
        
        guard let phone = phoneNumberTF.text, !phone.isEmpty else {
            Alerts.DisplayActionSheetAlert(title: "", message: Messenger.wrongPhoneNumber, object: self, actionType: .default)
            return false
        }
        
        guard let password = passwordTF.text, !password.isEmpty else {
            Alerts.DisplayActionSheetAlert(title: "", message: Messenger.emptyPassword, object: self, actionType: .default)
            return false
        }
        
        guard let confirm = confirmationNumber.text, !confirm.isEmpty else {
            Alerts.DisplayActionSheetAlert(title: "", message: "Empty confirmation number", object: self, actionType: .default)
            return false
        }
        
        guard let email = emailTF.text, !email.isEmpty else {
            Alerts.DisplayActionSheetAlert(title: "", message: Messenger.wrongEmail, object: self, actionType: .default)
            return false
        }
        
        guard self.selectedGender != 0 else {
            Alerts.DisplayActionSheetAlert(title: "", message: Messenger.EnterYourGender, object: self, actionType: .default)
            return false
        }
        
        guard self.selectedAge != 0 else {
            Alerts.DisplayActionSheetAlert(title: "", message: Messenger.EnterYourAge, object: self, actionType: .default)
            return false
        }
        
        guard self.selectedShape != 0 else {
            Alerts.DisplayActionSheetAlert(title: "", message: Messenger.selectShape, object: self, actionType: .default)
            return false
        }
        
        return true
    }
}
