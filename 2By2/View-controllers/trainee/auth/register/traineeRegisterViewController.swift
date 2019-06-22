//
//  traineeRegisterViewController.swift
//  trainee
//
//  Created by rocky on 11/21/18.
//  Copyright © 2018 personal. All rights reserved.
//

import UIKit
import SwiftyJSON
import Firebase
import FirebaseAuth

class traineeRegisterViewController: UIViewController {
    
    @IBOutlet weak
    var phoneNumberTF: UITextField!
    @IBOutlet weak var confirmationNumber: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var fullNameTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var shapesCV: UICollectionView!
    @IBOutlet weak var ageButton: UIButton!
    @IBOutlet weak var genderButton: UIButton!
    @IBOutlet weak var confirmBtn: UIButton!
    @IBOutlet weak var termsAndConditionsBtn: UIButton!
    @IBOutlet weak var termsAndConditionsLabel: UILabel!
    var agreed: Bool = false
    let nib_identifier: String = "shapeCollectionViewCelllIdentifier"
    /*
     |------------------------------------------------------------
     | IN CASE USER LOGGED IN USING PLUGISN ( FACEBOOK | GMAIL )
     |------------------------------------------------------------
     | 1- email >> send to the nextViewController
     | 3- ProviderIdFromPlugin
     | 4- LoginTypeFromPlugin
     */
    
    var ProviderIdFromPlugin: String? = nil
    var LoginTypeFromPlugin: Int = 3
    
    var genders = [GenderModel]()
    var ShapeGenderTypes = [JSON]()
    
    var selectedAge: Int = 0
    var selectedGender: Int = 0 // Male 1 , Female 2
    
    var shapesNumber: Int = 0
    var GenderShapes = [ShapesModel]()
    
    var selectedShape : Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(forName: .age, object: nil, queue: OperationQueue.main) { (notification) in
            if let vc = notification.object as? AgePopUpViewController {
                self.selectedAge = vc.selectedAge // SET AGE FIRST
                self.ageButton.setTitle("    \(vc.selectedAge)", for: .normal)
                self.DisplayShape()
            }
        }
        
        NotificationCenter.default.addObserver(forName: .gender, object: nil, queue: OperationQueue.main) { (notification) in
            if let vc = notification.object as? GenderPopUpViewController {
                // SET GENDER FIRST
                self.selectedGender = vc.selectedGenderId
                self.genderButton.setTitle("    \(vc.selectedGender)", for: .normal)
                self.DisplayShape()
            }
            
        }
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(termsAndConditionsLabelClicked(tapGestureRecognizer:)))
        termsAndConditionsLabel.isUserInteractionEnabled = true
        termsAndConditionsLabel.addGestureRecognizer(tapGestureRecognizer)
        
        self.getUserCreateData()
        self.shapesCV.allowsSelection = true
        
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.fullNameTF.text = UserDataUsedThroughTheApp.userFullName
        self.emailTF.text = UserDataUsedThroughTheApp.userEmailAddress
    }
    
    @IBAction func registerClicked(_ sender: UIButton) {
        
        guard agreed == true else {
            Alerts.DisplayActionSheetAlertWithButtonName(title: "Terms & Conditions", message: "Agree to the terms and conditions", object: self, actionType: .default, name: "OK")
            return
        }
        
        if validateUserData() == true {
            
            guard let phone = phoneNumberTF.text, !phone.isEmpty, Validation.isValidPhoneNumber(phone) else {
                return
            }
            
            let credential = PhoneAuthProvider.provider().credential(
                withVerificationID: PersistentStructure.getKey(key: "verificationID") ?? "",
                verificationCode: self.confirmationNumber.text!)
            
            Auth.auth().signInAndRetrieveData(with: credential) { (user, error) in
                
                guard error == nil else {
                    if let error = error as NSError? {
                        Alerts.DisplayActionSheetAlertWithButtonName(title: "", message: error.localizedDescription, object: self, actionType: .default, name: "OK")
                    }
                    return
                } // else {
                    
                    var params = [
                        UserCreateModel.UserCreatePostRequest.Params.Name: self.fullNameTF.text!,
                        UserCreateModel.UserCreatePostRequest.Params.Phone: phone,
                        UserCreateModel.UserCreatePostRequest.Params.Password: self.passwordTF.text!,
                        UserCreateModel.UserCreatePostRequest.Params.Fk_Gender: self.selectedGender,
                        UserCreateModel.UserCreatePostRequest.Params.Fk_LoginType: self.LoginTypeFromPlugin,
                        UserCreateModel.UserCreatePostRequest.Params.Age: self.selectedAge,
                        UserCreateModel.UserCreatePostRequest.Params.Fk_BodyShapeGenderType: self.selectedShape,
                        UserCreateModel.UserCreatePostRequest.Params.Email: self.emailTF.text!
                    ] as [String: Any]
                    print(params)
                    
                    if self.ProviderIdFromPlugin != nil {
                        params[UserCreateModel.UserCreatePostRequest.Params.ProviderID] = self.ProviderIdFromPlugin
                        if self.LoginTypeFromPlugin == 1 {
                            // FACEBOOK
                            params[UserCreateModel.UserCreatePostRequest.Params.Image] =
                            "https://graph.facebook.com/\(self.ProviderIdFromPlugin!)/picture?type=large"
                        }
                        
                        if self.LoginTypeFromPlugin == 2 {
                            // GMAIL
                            if UserDataUsedThroughTheApp.userImage.isEmpty == false {
                                params[UserCreateModel.UserCreatePostRequest.Params.Image] =
                                    CoachDataUsedThroughTheApp.coachImage
                            }
                        }
                    }
                    print(params)
                    
                    UserCreateModel.UserCreatePostRequest.UserPostCreateRequest(object: self, params: params) { (response, error) in
                        if error == true {
                            // ERROR MESSAGE
                            Alerts.DisplayActionSheetAlert(title: "", message: (response[Constants.Message]?.string)!, object: self, actionType: .default)
                            
                            return
                        }else {
                            
                            // THIS IN CASE USER LOGGED IN USING ANY PLUGIN
                            if let ProviderID = response[UserCreateModel.UserCreatePostRequest.Params.ProviderID]?.string {
                                
                                PersistentStructure.saveData(data: [
                                    PersistentStructureKeys.ProviderID : ProviderID,
                                    PersistentStructureKeys.userLoginType : self.LoginTypeFromPlugin
                                    ]
                                )
                                
                            } else {
                                // USER SIGNNED IN USING THE NORMAL WAY
                                if let phone = response[UserLoginModel.Params.Phone]?.string,
                                    let password = response[UserLoginModel.Params.Password]?.string {
                                    
                                    PersistentStructure.saveData(data: [PersistentStructureKeys.userPhone : phone, PersistentStructureKeys.userPassword : password, PersistentStructureKeys.userLoginType : 3])
                                    // MOVE TO THE SECOND STORYBOARD
                                }
                            }
                            
                            UserDataUsedThroughTheApp.saveUserInfo(user: response)
                            // MOVE TO THE HOME-COACH STORYBOARD
                            self.present(MoveToStoryBoard.moveTo(sb: MoveToStoryBoard.trainee_home), animated: true, completion: nil )
                            
                            
                        }
                        
                    }
                    
                // } // end of else
                
            }
            
        }
        
    }
    
    @IBAction func confirmClicked(_ sender: UIButton) {
        
        guard let phone = phoneNumberTF.text, !phone.isEmpty, Validation.isValidPhoneNumber(phone) else {
            return
        }
        
        MobileAuthRequest.changeMobile(phone: phone, object: self) { (status) in
            if status == true {
                self.confirmBtn.setTitle("Resend", for: .normal)
            }
        }
        
    }
    
    @IBAction func ageClicked(_ sender: UIButton) {
        let tab = PopusHandle.openAgePopup()
        tab.startingFrom = 5 
        present(tab, animated: true, completion: nil)
    }
    
    @IBAction func genderClicked(_ sender: UIButton) {
        let tab = PopusHandle.openGenderPopup()
        tab.genders = genders
        present(tab, animated: true, completion: nil)
    }
    
    
    @IBAction func backClicked(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func DisplayShape() {
        
        guard self.selectedAge != 0 , self.selectedGender != 0 else {
            
            return
        }
        
        if selectedAge > 15 && selectedGender == 1 { // CASE 1
            if let firstShapeCollection = ShapeGenderTypes[0].dictionary {
                getShapesToDisplay(firstShapeCollection: firstShapeCollection)
            }
        } else if selectedAge > 15 && selectedGender == 2 { // CASE 2
            if let firstShapeCollection = ShapeGenderTypes[1].dictionary {
                getShapesToDisplay(firstShapeCollection: firstShapeCollection)
            }
        } else if selectedAge <= 15 && selectedGender == 1 { // CASE 3
            
            if let firstShapeCollection = ShapeGenderTypes[2].dictionary {
                getShapesToDisplay(firstShapeCollection: firstShapeCollection)
            }
        } else if selectedAge <= 15 && selectedGender == 2 { // CASE 4
            if let firstShapeCollection = ShapeGenderTypes[3].dictionary {
                getShapesToDisplay(firstShapeCollection: firstShapeCollection)
            }
        }
        
    }
    
    func getShapesToDisplay(firstShapeCollection: Dictionary<String, JSON>) {
        
        if let BodyShapeGenderTypes = firstShapeCollection[UserCreateModel.UserCreateGetRequest.returnData.Data.ShapeGenderTypes.BodyShapeGenderTypes.structName]?.array {
            self.shapesNumber =  0 // SET IMAGES NUMBER
            self.GenderShapes.removeAll() // REMOVE BEFORE APPENDING
            BodyShapeGenderTypes.forEach { (BodyShapeGenderType) in
                print(BodyShapeGenderType)
                if let Image = BodyShapeGenderType["Image"].string, let Fk_ShapeGenderType = BodyShapeGenderType["Id"].int {
                    
                    if let BodyShape = BodyShapeGenderType["BodyShape"].dictionary {
                        if let Name = BodyShape["Name"]?.string {
                            let shapeModel = ShapesModel(Id: Fk_ShapeGenderType, Image: Image, Name: Name)
                            self.GenderShapes.append(shapeModel)
                            self.shapesNumber =  self.shapesNumber + 1
                        }
                    }
                }
            }
            
            self.shapesCV.reloadData() // RELOAD SHAPES
        }
        
    }
    
}

extension traineeRegisterViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return shapesNumber
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: nib_identifier, for: indexPath) as! shapesCollectionViewCell
        
        
        let imagePath = self.GenderShapes[indexPath.row].Image
        DispatchQueue.main.async {
            cell.shapeImage.findMe(url: imagePath ?? "", mode: true)
        }
        
        cell.shapeTitle.text = self.GenderShapes[indexPath.row].Name
        return cell
    }
    
}

extension traineeRegisterViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        collectionView.visibleCells.forEach { (cell) in
            if let cell = cell as? shapesCollectionViewCell {
                cell.shapeImage.backgroundColor = .clear
            }
        }
        
        self.selectedShape = GenderShapes[indexPath.row].Id
        
        if let cell = collectionView.cellForItem(at: indexPath) as? shapesCollectionViewCell {
            cell.shapeImage.backgroundColor = UIColor.lightGray
        }
        
    }
    
}
