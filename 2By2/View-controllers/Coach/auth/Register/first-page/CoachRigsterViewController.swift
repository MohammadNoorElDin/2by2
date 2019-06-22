//
//  CoachRigsterViewController.swift
//  2By2
//
//  Created by mac on 10/30/18.
//  Copyright © 2018 personal. All rights reserved.
//


import UIKit

class CoachRigsterViewController: UIViewController {
    
    @IBOutlet weak var spokenLanguagesTV: UITableView!
    @IBOutlet weak var specializationTV: UITableView!
    @IBOutlet weak var fullNameTF: UITextField!
    @IBOutlet weak var genderButton: UIButton!
    @IBOutlet weak var ageButton: UIButton!
    @IBOutlet weak var doYouHave: UIButton!
    
    var yesIHaveCar: Bool = false
    
    var langs = [langsModel]()
    var specializations = [SpecializationModel]()
    var genders = [GenderModel]()
    var locations = [LocationsModel]()
    
    let lang_nib_identifier = "coachLangTableViewCell"
    let specialization_nib_identifier = "specializationTableViewCell"
    var ageObserver: NSObjectProtocol?
    var genderObserver: NSObjectProtocol?
    var coachModel: CoachRegisterModel? // these data are the coach register data (CoachRegisterModel)
    
    /*
     |------------------------------------------------------------
     | IN CASE USER LOGGED IN USING PLUGISN ( FACEBOOK | GMAIL )
     |------------------------------------------------------------
     | 1- fullName
     | 2- email >> send to the nextViewController
     | 3- ProviderIdFromPlugin
     | 4- LoginTypeFromPlugin
     */
    
    var fullNameFromPlugin: String? = nil
    var emailFromPlugin: String? = nil
    var ProviderIdFromPlugin: String? = nil
    var LoginTypeFromPlugin: Int? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if fullNameFromPlugin != nil {
            self.fullNameTF.text = fullNameFromPlugin
        }
        
        registerTable(tableView: spokenLanguagesTV, nib_identifier: lang_nib_identifier)
        registerTable(tableView: specializationTV, nib_identifier: specialization_nib_identifier)
        configCell(table: spokenLanguagesTV)
        configCell(table: specializationTV)
        
        self.coachModel = CoachRegisterModel()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        self.genderObserver = addCustomObserver(name: .gender, completion: { (notification) in
            if let gender = notification.object as? GenderPopUpViewController {
                self.coachModel!.gender = gender.selectedGenderId
                self.genderButton.setTitle("    \(gender.selectedGender)", for: .normal)
            }
        })
        
        self.ageObserver = addCustomObserver(name: .age, completion: { (notification) in
            if let age = notification.object as? AgePopUpViewController {
                self.coachModel!.age = age.selectedAge
                self.ageButton.setTitle("    \(age.selectedAge)", for: .normal)
            }
        })
        
        
        getData() // Langs and specializations
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        
        if let ageObserver = ageObserver {
            NotificationCenter.default.removeObserver(ageObserver)
        }
        
        if let genderObserver = genderObserver {
            NotificationCenter.default.removeObserver(genderObserver)
        }
    }
    
    // openIntitalViewPOPUP
    @IBAction func genderClicked(_ sender: UIButton){
        let vc = PopusHandle.openGenderPopup()
        vc.genders = genders
        present(vc, animated: true, completion: nil)
    }
    
    // openIntitalViewPOPUP
    @IBAction func ageClicked(_ sender: UIButton){
        let vc = PopusHandle.openAgePopup()
        present(vc, animated: true, completion: nil)
    }
    
    // Login
    @IBAction func loginClicked(_ sender: UIButton){
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func nextClicked(_ sender: UIButton){
        prepareToSendDataToNextRegisterViewController()
        performSegue(withIdentifier: segueIdentifier.toNextRegisterViewControllerSegue, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == segueIdentifier.toNextRegisterViewControllerSegue{
            if let dest = segue.destination as? CoachNextRegisterViewController {
                dest.Locations = locations
                dest.coachModel = self.coachModel
                if emailFromPlugin != nil {
                    dest.emailFromPlugin = emailFromPlugin!
                    dest.ProviderIdFromPlugin = ProviderIdFromPlugin!
                    dest.LoginTypeFromPlugin = LoginTypeFromPlugin!
                }
                // send object of CoachModel to the nextRegister
            }
        }
    }
    
    
    
    
    @IBAction func doYouHaveACar(_ sender: UIButton) {
        
        if self.doYouHave.currentImage == UIImage(named: "check-box") {
           self.doYouHave.setImage(UIImage(named: "un-check-box"), for: .normal)
            self.yesIHaveCar = false
        }else {
           self.doYouHave.setImage(UIImage(named: "check-box"), for: .normal)
            self.yesIHaveCar = true
        }
        
    }
    
}
