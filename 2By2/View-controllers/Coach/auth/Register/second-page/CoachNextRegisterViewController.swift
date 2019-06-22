//
//  CoachNextRegisterViewController.swift
//  2By2
//
//  Created by mac on 11/1/18.
//  Copyright © 2018 personal. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class CoachNextRegisterViewController: UIViewController {

    @IBOutlet weak var locationTV: UITableView!
    
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var phoneNumberTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var confirmationNumber: UITextField!
    @IBOutlet weak var termsAndConditionsBtn: UIButton!
    @IBOutlet weak var termsAndConditionsLabel: UILabel!
    @IBOutlet weak var confirmBtn: UIButton!
    var agreed: Bool = false
    
    var Locations: [LocationsModel]!
    let locations_nib_identifier = "locationsTableViewCell"
    
    var coachModel: CoachRegisterModel! // these data are the coach register data (CoachRegisterModel)
    
    /*
     |------------------------------------------------------------
     | IN CASE USER LOGGED IN USING PLUGISN ( FACEBOOK | GMAIL )
     |------------------------------------------------------------
     | 1- email >> send to the nextViewController
     | 3- ProviderIdFromPlugin
     | 4- LoginTypeFromPlugin
     */
    
    var emailFromPlugin: String? = nil
    var ProviderIdFromPlugin: String? = nil
    var LoginTypeFromPlugin: Int? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if emailFromPlugin != nil {
            self.emailTF.text = emailFromPlugin!
        }
        
        registerTable(tableView: locationTV, nib_identifier: locations_nib_identifier)
        configCell(table: locationTV)
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(termsAndConditionsLabelClicked(tapGestureRecognizer:)))
        termsAndConditionsLabel.isUserInteractionEnabled = true
        termsAndConditionsLabel.addGestureRecognizer(tapGestureRecognizer)
        
         locationTV.isScrollEnabled = false
    }
    
    @objc func termsAndConditionsLabelClicked(tapGestureRecognizer: UITapGestureRecognizer)
    {
        ClickTo.OpenBrowser(link: "https://drive.google.com/open?id=1UES5hnTI6pP171PZGNwXbfVWSlB_NsYB")
    }
    
    @IBAction func checkTermsAndConditions(_ sender: UIButton) {
        if self.termsAndConditionsBtn.currentImage == UIImage(named: "check-box") {
            self.agreed = false
            self.termsAndConditionsBtn.setImage(UIImage(named: "un-check-box"), for: .normal)
        } else {
            self.agreed = true
            self.termsAndConditionsBtn.setImage(UIImage(named: "check-box"), for: .normal)
        }
    }
    
    @IBAction func confirmClicked(_ sender: UIButton) {
        
        guard var phone = phoneNumberTF.text, !phone.isEmpty, Validation.isValidPhoneNumber(phone) else {
            Alerts.DisplayActionSheetAlertWithButtonName(title: "", message: "Please check your phone number", object: self, actionType: .default, name: "OK")
            return
        }
        
        MobileAuthRequest.changeMobileForCoach(phone: phone, object: self) { (status) in
            if status == true {
                self.confirmBtn.setTitle("Resend", for: .normal)
            }
        }
        
    }
    
    @IBAction func showPassword(_ sender: UIButton) {
        if passwordTF.isSecureTextEntry == false {
            passwordTF.isSecureTextEntry = true
        }else {
            passwordTF.isSecureTextEntry = false
        }
    }
    
    @IBAction func registerClicked(_ sender: UIButton) {
       
        guard agreed == true else {
            Alerts.DisplayActionSheetAlertWithButtonName(title: "Terms & Conditions", message: "Agree to the terms and conditions", object: self, actionType: .default, name: "OK")
            return
        }
        
        if validateCoachModelData() == true {
            
            guard let phone = phoneNumberTF.text, !phone.isEmpty, Validation.isValidPhoneNumber(phone) else {
                return
            }
            self.sendRequestToRegister(phone: phone)
        }
        
    }
    
    @IBAction func backClicked(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }

    
    
}
