//
//  CoachRegisterViewControllerExt.swift
//  2By2
//
//  Created by mac on 10/30/18.
//  Copyright © 2018 personal. All rights reserved.
//

import UIKit
import SwiftyJSON


/*
 |===========================================
 | MARK :- THREE SIMPLE FUNCTIONS
 |===========================================
 | 1- getData Request To The Server
 | 2- ConfigCell to appear as u wish in the view
 | 3- prepareToSendDataToNextRegisterViewController
 */

extension CoachRigsterViewController {
    
    // MARK :- configCell
    func getData() {
        
        guard genders.count <= 0 else {
            return
        }
        
        CoachCreateModel.CoachCreateGetRequest.CoachGetCreateRequest(object: self) { (dic, error) in
            
            if let languages = dic[CoachCreateModel.CoachCreateGetRequest.returnData.Languages.structName]?.array {
                languages.forEach({ (lang) in
                    if let name = lang[CoachCreateModel.CoachCreateGetRequest.returnData.Languages.Name].string, let id = lang[CoachCreateModel.CoachCreateGetRequest.returnData.Languages.Id].int {
                        let langModel = langsModel(lang: name, id: id)
                        self.langs.append(langModel)
                    }
                })
                self.spokenLanguagesTV.reloadData()
            }
            
            if let specializations = dic[CoachCreateModel.CoachCreateGetRequest.returnData.FirstCategoryPrograms.structName]?.array {
                specializations.forEach({ (specialization) in
                    if let name = specialization[CoachCreateModel.CoachCreateGetRequest.returnData.FirstCategoryPrograms.Name].string, let id = specialization[CoachCreateModel.CoachCreateGetRequest.returnData.FirstCategoryPrograms.Id].int {
                        let specializationModel = SpecializationModel(id: id, name: name)
                        self.specializations.append(specializationModel)
                    }
                })
                self.specializationTV.reloadData()
            }
            
            if let genders = dic[CoachCreateModel.CoachCreateGetRequest.returnData.Genders.structName]?.array {
                genders.forEach({ (gender) in
                    if let name = gender[CoachCreateModel.CoachCreateGetRequest.returnData.Genders.Name].string, let id = gender[CoachCreateModel.CoachCreateGetRequest.returnData.Genders.Id].int {
                        let genderModel = GenderModel(id: id, name: name)
                        self.genders.append(genderModel)
                    }
                })
            }
            
            if let locations = dic[CoachCreateModel.CoachCreateGetRequest.returnData.Locations.structName]?.array {
                locations.forEach({ (location) in
                    if let name = location[CoachCreateModel.CoachCreateGetRequest.returnData.Locations.Name].string, let id = location[CoachCreateModel.CoachCreateGetRequest.returnData.Locations.Id].int {
                        let locationModel = LocationsModel(id: id, name: name)
                        self.locations.append(locationModel)
                    }
                })
            }
            
            
        }
    }
    // 076353
    // MARK :- configCell
    func configCell(table: UITableView) {
        table.allowsSelection = false
        table.backgroundColor = UIColor.clear
        table.separatorInset = .zero
        table.contentInset = .zero
    }
    
    // MARK :- prepareToSendDataToNextRegisterViewController
    func prepareToSendDataToNextRegisterViewController() {
        
        guard let name = fullNameTF.text, !name.isEmpty else {
            Alerts.DisplayActionSheetAlert(title: "", message: Messenger.emptyName, object: self, actionType: .default)
            return
        }
        
        // check if the gender is checked
        guard let gender = coachModel?.gender, gender != 0 else {
            Alerts.DisplayActionSheetAlert(title: "", message: Messenger.EnterYourGender, object: self, actionType: .default)
            return
        }
        // check if the age is choosed
        guard let age = coachModel?.age, age > 0 else {
            Alerts.DisplayActionSheetAlert(title: "", message: Messenger.EnterYourAge, object: self, actionType: .default)
            return
        }
        
        // check if langs.count > 0
        if coachLangTableViewCell.langs.count <= 0 {
            Alerts.DisplayActionSheetAlert(title: "", message: Messenger.langsEmpty, object: self, actionType: .default)
            return
        }
        // check if specializations.count > 0
        if specializationTableViewCell.specializations.count <= 0 {
            Alerts.DisplayActionSheetAlert(title: "", message: Messenger.specializationsEmpty, object: self, actionType: .default)
            return
        }
        
        coachModel?.fullName = name
        coachModel?.doYouHave = self.yesIHaveCar
        coachModel?.spokenLanguages = Generate.generateIntKeysFromIntDictionary(dic: coachLangTableViewCell.langs)
        coachModel?.specializations = Generate.generateIntKeysFromIntDictionary(dic: specializationTableViewCell.specializations)
        
        
    }
    
}

/*
 |===========================================
 | MARK :- TWO SIMPLE FUNCTIONS
 |===========================================
 | 1- numberOfRowsInSection
 | 2- cellForRowAt
 */

extension CoachRigsterViewController: UITableViewDataSource {
   
    // MARK :- numberOfRowsInSection
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView.tag == 0 { // lang
            return langs.count
        }else {
            return specializations.count
        }
    }
    
    // MARK :- cellForRowAt
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView.tag == 0 { // lang
            let cell = tableView.dequeueReusableCell(withIdentifier: lang_nib_identifier, for: indexPath) as! coachLangTableViewCell
            cell.backgroundColor = UIColor.clear
            
            let num = ( indexPath.row * 2 )
            
            if langs.indices.contains( num  ) {
                let lh = langs[num]
                if langs.indices.contains( num + 1 ) {
                    let rh = langs[num + 1]
                    cell.configCell(lbLang: lh, rbLang: rh)
                    cell.rightButton.titleLabel?.font = Theme.FontLight(size: 17)
                    cell.rightButton.setTitleColor(.white, for: .normal)
                }else {
                    cell.configCell(lbLang: lh, rbLang: nil)
                }
                cell.leftButton.setTitleColor(.white, for: .normal)
                cell.leftButton.titleLabel?.font = Theme.FontLight(size: 17)
            }
            return cell
        }else { // specialization
            
            let cell = tableView.dequeueReusableCell(withIdentifier: specialization_nib_identifier, for: indexPath) as! specializationTableViewCell
            cell.backgroundColor = UIColor.clear
            
            let num = ( indexPath.row * 2 )
            
            if specializations.indices.contains( num  ) {
                let lh = specializations[num]
                if specializations.indices.contains( num + 1 ) {
                    let rh = specializations[num + 1]
                    cell.configCell(lbSpecialization: lh, rbSpecialization: rh)
                    cell.rightButton.setTitleColor(.white, for: .normal)
                    cell.rightButton.titleLabel?.font = Theme.FontLight(size: 17)
                }else {
                    cell.configCell(lbSpecialization: lh, rbSpecialization: nil)
                }
                cell.leftButton.setTitleColor(.white, for: .normal)
                cell.leftButton.titleLabel?.font = Theme.FontLight(size: 17)
                
            }
            return cell
        }
        
    }
}

