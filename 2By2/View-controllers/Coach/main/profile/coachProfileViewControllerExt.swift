//
//  coachProfileViewControllerExt.swift
//  2By2
//
//  Created by rocky on 11/17/18.
//  Copyright © 2018 personal. All rights reserved.
//

import UIKit

extension coachProfileViewController {
    
    //MARK:- FUNCTIONS
    /**
     ++ -------------------------------------------------
     ++ FUNCTIONS ( CONFIG )
     ++ -------------------------------------------------
     ++ 1- config ...
     ++ 2- displayUserProfileImage ....
     ++ 3- send Request to fetch Result
     ++ 4-
     **/
    // MARK:- displayUserProfileImage
    func displayUserProfileImage() {
        let imagePath = CoachDataUsedThroughTheApp.coachImage
        self.profileImage.findMe(url: imagePath)
        self.profileImage.imageRadius()
    }
    
    func getUserData(completion: @escaping () -> ()) {
       
        guard self.languages.count == 0 else {
            return
        }
        
        CoachCreateModel.CoachCreateGetRequest.CoachGetCreateRequest(object: self) { (dic, error) in
            if error == true {
              
                print("errorrororororororoororororo wallehy error ")
                
            } else {
                if self.languages.count == 0 {
                    if let languages = dic[CoachCreateModel.CoachCreateGetRequest.returnData.Languages.structName]?.array {
                        languages.forEach({ (lang) in
                            if let name = lang[CoachCreateModel.CoachCreateGetRequest.returnData.Languages.Name].string, let id = lang[CoachCreateModel.CoachCreateGetRequest.returnData.Languages.Id].int {
                                let langModel = langsModel(lang: name, id: id)
                                self.languages.append(langModel)
                            }
                        })
                        self.languagesTV.reloadData()
                    }
                }
                if self.specializations.count == 0 {
                    if let specializations = dic[CoachCreateModel.CoachCreateGetRequest.returnData.FirstCategoryPrograms.structName]?.array {
                        specializations.forEach({ (specialization) in
                            if let name = specialization[CoachCreateModel.CoachCreateGetRequest.returnData.FirstCategoryPrograms.Name].string, let id = specialization[CoachCreateModel.CoachCreateGetRequest.returnData.FirstCategoryPrograms.Id].int {
                                let specializationModel = SpecializationModel(id: id, name: name)
                                self.specializations.append(specializationModel)
                            }
                        })
                        self.specialtiesTV.reloadData()
                    }
                }
                if self.genders.count == 0 {
                    if let genders = dic[CoachCreateModel.CoachCreateGetRequest.returnData.Genders.structName]?.array {
                        genders.forEach({ (gender) in
                            if let name = gender[CoachCreateModel.CoachCreateGetRequest.returnData.Genders.Name].string, let id = gender[CoachCreateModel.CoachCreateGetRequest.returnData.Genders.Id].int {
                                let genderModel = GenderModel(id: id, name: name)
                                self.genders.append(genderModel)
                            }
                        })
                    }
                }
                if self.serviceAreas.count == 0 {
                    if let locations = dic[CoachCreateModel.CoachCreateGetRequest.returnData.Locations.structName]?.array {
                        locations.forEach({ (location) in
                            if let name = location[CoachCreateModel.CoachCreateGetRequest.returnData.Locations.Name].string, let id = location[CoachCreateModel.CoachCreateGetRequest.returnData.Locations.Id].int {
                                let locationModel = LocationsModel(id: id, name: name)
                                self.serviceAreas.append(locationModel)
                            }
                        })
                        self.serviceAreasTV.reloadData()
                    }
                }
            } // end of else
            completion()
        }
       
    }
    
    func setUserData() {
        
        
        var params = [String: Any]()
        
        if let type = PersistentStructure.getKeyInt(key: PersistentStructureKeys.coachLoginType) {
            if type == 1 || type == 2 {
                // gmail or facebook
                params[CoachLoginModel.Params.ProviderID] = PersistentStructure.getKey(key: PersistentStructureKeys.ProviderID)!
            } else if type == 3 {
                // normal way
                params[CoachLoginModel.Params.Phone] = PersistentStructure.getKey(key: PersistentStructureKeys.coachPhone)!
                params[CoachLoginModel.Params.Password] = PersistentStructure.getKey(key: PersistentStructureKeys.coachPassword)!
            }
            params[CoachLoginModel.Params.Fk_LoginType] = type
            print(params)
        }
        
        CoachLoginModel.CoachLogin(params: params, object: self) { (response, status) in
            
            if status == false {
                
                if let coach = response["Coach"]?.dictionary {
                    self.user = coach
                    
                    self.coachModel.fullName = CoachDataUsedThroughTheApp.coachFullName
                    
                    // SET GENDER
                    if let gender = coach["Gender"]?.dictionary {
                        if let id = gender["Id"]?.int {
                            self.coachModel.gender = id
                        }
                        if let name = gender["Name"]?.string {
                            self.genderButton.setTitle("   \(name)" , for: .normal)
                        }
                        
                    }
                    
                    // SET AGE
                    if let age = coach["Age"]?.int {
                        self.coachModel.age = age
                        self.ageButton.setTitle("   \(age)", for: .normal)
                    }
                    
                    // SET NAME
                    if let name = coach["Name"]?.string {
                        CoachDataUsedThroughTheApp.coachFullName = name
                        self.fullNameTF.text = name /*u dont neeed this*/
                    }
                    
                    // SET EMAIL
                    if let email = coach["Email"]?.string {
                        self.emailTF.text = email /*u dont neeed this*/
                    }
                    
                    // SET PHONE
                    if let phone = coach["Phone"]?.string {
                        self.mobileTF.text = phone
                    }
                    
                    // SET LANG
                    if let langs = response["Languages"]?.array {
                        DispatchQueue.main.async {
                            langs.forEach({ (lang) in
                                if let lang = lang.dictionary {
                                    print("yes you are here")
                                    if let id = lang["Id"]?.int {
                                        for (index, element) in self.languages.enumerated() {
                                            if id == element.id {
                                                self.languages[index].selected = true
                                            }
                                        }
                                    }
                                }
                            })
                        }
                        DispatchQueue.main.async {
                            self.languagesTV.reloadData()
                        }
                    } // END OF LANGS
                    
                    // SET SPECIALIZATIONS
                    if let specializations = response["FirstCategoryPrograms"]?.array {
                        DispatchQueue.main.async {
                            specializations.forEach({ (specialization) in
                                if let specialization = specialization.dictionary {
                                    if let id = specialization["Id"]?.int {
                                        for (index, element) in self.specializations.enumerated() {
                                            if id == element.id {
                                                self.specializations[index].selected = true
                                            }
                                        }
                                    }
                                }
                            })
                        }
                        DispatchQueue.main.async {
                            self.specialtiesTV.reloadData()
                        }
                    } // END OF SPECIALIZATIONS
                    
                    
                    // SET Locations
                    if let locations = response["Locations"]?.array {
                        DispatchQueue.main.async {
                            locations.forEach({ (location) in
                                if let location = location.dictionary {
                                    if let id = location["Id"]?.int {
                                        for (index, element) in self.serviceAreas.enumerated() {
                                            if id == element.id {
                                                self.serviceAreas[index].selected = true
                                            }
                                        }
                                    }
                                }
                            })
                        }
                        DispatchQueue.main.async {
                            self.serviceAreasTV.reloadData()
                        }
                    } // END OF Locations
                    
                } // END OF COACH FETCHING DATA
                
            }
        }
    }

    func validateRequestData() -> Bool {
        
        guard let fullName = self.fullNameTF.text, !fullName.isEmpty else {
            Alerts.DisplayActionSheetAlert(title: "", message: Messenger.emptyName, object: self, actionType: .default)
            return false
        }
        
        guard let mobile = self.mobileTF.text, !mobile.isEmpty else {
            Alerts.DisplayActionSheetAlert(title: "", message: Messenger.wrongPhoneNumber, object: self, actionType: .default)
            return false
        }
        
        if coachLangTableViewCell.langs.count <= 0 {
            Alerts.DisplayActionSheetAlert(title: "", message: Messenger.langsEmpty, object: self, actionType: .default)
            return false
        }
        
        if locationsTableViewCell.locations.count <= 0 {
            Alerts.DisplayActionSheetAlert(title: "", message: Messenger.locationsEmpty, object: self, actionType: .default)
            return false
        }
        
        if specializationTableViewCell.specializations.count <= 0 {
            Alerts.DisplayActionSheetAlert(title: "", message: Messenger.specializationsEmpty, object: self, actionType: .default)
            return false
        }
     
        return true
    }
    
}
//MARK:-UITableViewDataSource
extension coachProfileViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView.tag == 0 { // LANGUAGES
            let num = self.languages.count
            return ( num % 2 == 0 ) ? num / 2 : ( num + 1 ) / 2
        }else if tableView.tag == 1 { // SPECIALIZATIONS
            let num = self.specializations.count
            return ( num % 2 == 0 ) ? num / 2 : ( num + 1 ) / 2
        }else { // SERVICE AREAS
            let num = self.serviceAreas.count
            return ( num % 2 == 0 ) ? ( num / 2 ) : ( num + 1 ) / 2
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView.tag == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: nib_identifier_languages, for: indexPath) as! coachLangTableViewCell
            
            let num = ( indexPath.row * 2 )
            
            if self.languages.indices.contains( num  ) {
                let lh = languages[num]
                if self.languages.indices.contains( num + 1 ) {
                    let rh = languages[num + 1]
                    cell.configCell(lbLang: lh, rbLang: rh)
                }else {
                    cell.configCell(lbLang: lh, rbLang: nil)
                }
                cell.leftButton.setTitleColor(.black, for: .normal)
                cell.rightButton.setTitleColor(.black, for: .normal)
                cell.leftButton.titleLabel?.font = Theme.FontLight(size: 16)
                cell.rightButton.titleLabel?.font = Theme.FontLight(size: 16)
                
            }
            
            return cell
            
        }else if tableView.tag == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: nib_identifier_specialties, for: indexPath) as! specializationTableViewCell
            cell.backgroundColor = UIColor.clear
            
            let num = ( indexPath.row * 2 )
            
            if specializations.indices.contains( num  ) {
                let lh = specializations[num]
                if specializations.indices.contains( num + 1 ) {
                    let rh = specializations[num + 1]
                    cell.configCell(lbSpecialization: lh, rbSpecialization: rh)
                }else {
                    cell.configCell(lbSpecialization: lh, rbSpecialization: nil)
                }
                cell.leftButton.setTitleColor(.black, for: .normal)
                cell.rightButton.setTitleColor(.black, for: .normal)
                cell.leftButton.titleLabel?.font = Theme.FontLight(size: 16)
                cell.rightButton.titleLabel?.font = Theme.FontLight(size: 16)
            }
            
            
            return cell
        } else {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: nib_identifier_serviceAreas, for: indexPath) as! locationsTableViewCell

            let num = ( indexPath.row * 2 )
            
            if serviceAreas.indices.contains( num  ) {
                let lh = serviceAreas[num]
                if serviceAreas.indices.contains( num + 1 ) {
                    
                    let rh = serviceAreas[num + 1]
                    cell.configCell(lbLocation: lh, rbLocation: rh)
                    cell.rightButton.titleLabel?.font = Theme.FontLight(size: 16)
                    cell.rightButton.setTitleColor(.black, for: .normal)
                }else {
                    cell.configCell(lbLocation: lh, rbLocation: nil)
                }
                cell.leftButton.titleLabel?.font = Theme.FontLight(size: 16)
                cell.leftButton.setTitleColor(.black, for: .normal)
            }
            return cell
        }
        
        
    }
    
    
}
//MARK:-UITableViewDelegate
extension coachProfileViewController: UITableViewDelegate {
    
}

