//
//  coachProfileViewController.swift
//  2By2
//
//  Created by rocky on 11/17/18.
//  Copyright © 2018 personal. All rights reserved.
//

import UIKit
import SwiftyJSON
import SDWebImage
import Firebase
import FirebaseAuth

class coachProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var scroller: UIScrollView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var fullNameTF: CustomDesignableTextField!
    @IBOutlet weak var genderButton: UIButton!
    @IBOutlet weak var ageButton: UIButton!
    @IBOutlet weak var languagesTV: UITableView!
    @IBOutlet weak var specialtiesTV: UITableView!
    @IBOutlet weak var serviceAreasTV: UITableView!
    @IBOutlet weak var mobileTF: CustomDesignableTextField!
    @IBOutlet weak var emailTF: CustomDesignableTextField!
    
    let nib_identifier_languages = "coachLangTableViewCell"
    let nib_identifier_serviceAreas = "locationsTableViewCell"
    let nib_identifier_specialties = "specializationTableViewCell"
    
    
    var imagePicker = UIImagePickerController()
    var languages = [langsModel]()
    var specializations = [SpecializationModel]()
    var serviceAreas = [LocationsModel]()
    var genders = [GenderModel]()
    
    var user: [String: JSON]!
    var coachModel = CoachRegisterModel()
    var imagePicked: Bool = false
    var password: String = ""
    var changeMobileStatus: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //TABLE REGISTERATION
        registerTable(tableView: languagesTV, nib_identifier: nib_identifier_languages)
        registerTable(tableView: specialtiesTV, nib_identifier: nib_identifier_specialties)
        registerTable(tableView: serviceAreasTV, nib_identifier: nib_identifier_serviceAreas)
        
        mobileTF.text = PersistentStructure.getKey(key: PersistentStructureKeys.coachPhone)
        fullNameTF.text = CoachDataUsedThroughTheApp.coachFullName
        
        scroller.isScrollEnabled = true
        
        // gender observer and age observer
        NotificationCenter.default.addObserver(forName: .gender, object: nil, queue: OperationQueue.main) { (notification) in
            if let gender = notification.object as? GenderPopUpViewController {
                self.coachModel.gender = gender.selectedGenderId
                self.genderButton.setTitle("   \(gender.selectedGender)", for: .normal)
            }
        }
        
        NotificationCenter.default.addObserver(forName: .age, object: nil, queue: OperationQueue.main) { (notification) in
            if let age = notification.object as? AgePopUpViewController {
                self.coachModel.age = age.selectedAge
                self.ageButton.setTitle("   \(age.selectedAge)", for: .normal)
            }
        }
        
        NotificationCenter.default.addObserver(forName: .changePassword, object: nil, queue: OperationQueue.main) { (notification) in
            if let changePasswordVC = notification.object as? changePasswordPOPUPViewController {
                self.password = changePasswordVC.password
            }
        }
        
        NotificationCenter.default.addObserver(forName: .changeMobile, object: nil, queue: OperationQueue.main) { (notification) in
            if let _ = notification.object as? changePOPUPViewController {
                self.changeMobileStatus = true
            }
        }
        
        self.languagesTV.allowsSelection = false
        self.serviceAreasTV.allowsSelection = false
        self.specialtiesTV.allowsSelection = false
        self.imagePicker.delegate = self as! UIImagePickerControllerDelegate & UINavigationControllerDelegate
        
        self.sideMenuController?.cache(viewControllerGenerator: { self.storyboard?.instantiateViewController(withIdentifier: "coachhomeView") }, with: "coach-home")
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if imagePicked == false {
            displayUserProfileImage()
        }
        getUserData {
            self.setUserData()
        }
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(viewTapped(tapGestureRecognizer:)))
        profileImage.isUserInteractionEnabled = true
        profileImage.addGestureRecognizer(tapGestureRecognizer)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        self.resetFunc()
    }
    
    @objc func viewTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        let alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
            self.openCamera()
        }))
        
        alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { _ in
            self.openGallary()
        }))
        
        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        
        switch UIDevice.current.userInterfaceIdiom {
        case .pad:
            
            alert.popoverPresentationController?.permittedArrowDirections = .up
        default:
            break
        }
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    @IBAction func reset(_ sender: UIButton) {
        self.resetFunc()
        self.imagePicked = false
        self.displayUserProfileImage()
        self.viewDidAppear(true)
    }
    
    func resetFunc() {
        self.languages.removeAll()
        self.genders.removeAll()
        self.serviceAreas.removeAll()
        self.specializations.removeAll()
        coachLangTableViewCell.langs.removeAll()
        specializationTableViewCell.specializations.removeAll()
        locationsTableViewCell.locations.removeAll()
    }

    @IBAction func ageButtonCicked(_ sender: UIButton) {
        let vc = PopusHandle.openAgePopup()
        present(vc, animated: true, completion: nil)
    }
    
    @IBAction func genderButtonCicked(_ sender: UIButton) {
        let vc = PopusHandle.openGenderPopup()
        vc.genders = genders
        present(vc, animated: true, completion: nil)
    }
    
    @IBAction func changeMobileButton(_ sender: UIButton) {
        
        guard let phone = mobileTF.text, !phone.isEmpty, Validation.isValidPhoneNumber(phone) else {
            return
        }
        
        MobileAuthRequest.changeMobileForCoach(phone: phone, object: self) { (status) in
            if status == true {
                let tab = PopusHandle.changePOPUPViewController()
                self.present(tab, animated: true, completion: nil)
            }
        }
        
    }
    
    @IBAction func changePassword(_ sender: UIButton) {
        
        let tab = PopusHandle.changePasswordPopupViewController()
        present(tab, animated: true, completion: nil)
        
    }
    
    @IBAction func viewMYCertificates(_ sender: UIButton) {
        
    }
    
    @IBAction func save(_ sender: UIButton) {
        
        guard validateRequestData() == true else  {
            return
        }
        
        let paramsImage = [
            "Id": String(CoachDataUsedThroughTheApp.coachId),
        ]
        
        print(paramsImage)
        
        APIRequests.uploadImage(toUrl: Constants.uploadImage, parameters: paramsImage, selectedImage: self.profileImage.image!) { (status, data) in
            
            if status == true {
                
                var params = [
                    CoachEditModel.Params.Id: CoachDataUsedThroughTheApp.coachId,
                    CoachEditModel.Params.Age: self.coachModel.age,
                    CoachEditModel.Params.Fk_Gender: self.coachModel.gender,
                    CoachEditModel.Params.Name: self.fullNameTF.text ?? "",
                    CoachEditModel.Params.Image: data as! String,
                    CoachEditModel.Params.FK_LoginType: PersistentStructure.getKeyInt(key: PersistentStructureKeys.coachLoginType)!,
                    CoachEditModel.Params.Languages.structName: Generate.generateIntKeysFromIntDictionary(dic: coachLangTableViewCell.langs),
                    CoachEditModel.Params.Locations.structName: Generate.generateIntKeysFromIntDictionary(dic: locationsTableViewCell.locations),
                    CoachEditModel.Params.FirstCategoryPrograms.structName: Generate.generateIntKeysFromIntDictionary(dic: specializationTableViewCell.specializations),
                ] as [String: Any]
              
                
                if self.password.isEmpty == false {
                    params[CoachEditModel.Params.Password] = self.password
                    PersistentStructure.addKey(key: PersistentStructureKeys.coachPassword, value: self.password)
                }
                
                if self.changeMobileStatus == true {
                    params[CoachEditModel.Params.Phone] = self.mobileTF.text ?? ""
                    PersistentStructure.addKey(key: PersistentStructureKeys.coachPhone, value: self.mobileTF.text!)
                }
                
                CoachEditModel.CoachEditProfileRequest(object: self, params: params) { (response, status) in
                    
                    if status == false {
                        
                        SDImageCache.shared().clearDisk(onCompletion: {
                            SDImageCache.shared().clearMemory()
                            
                            CoachDataUsedThroughTheApp.coachImage = data as! String
                            CoachDataUsedThroughTheApp.coachFullName = self.fullNameTF.text!
                            self.sideMenuController?.setContentViewController(with: "coach-home")
                        })
                    }
                    
                }
                
            }else {
                Alerts.DisplayDefaultAlert(title: "", message: "Couldn't Upload Image", object: self, actionType: .default)
            }
        }
        
    }

    
    @IBAction func openSideMenu(_ sender: UIBarButtonItem) {
        self.sideMenuController?.revealMenu()
    }
    
    
    @IBAction func openIMageGallery(_ sender: UIButton) {

        let alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
            self.openCamera()
        }))
        
        alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { _ in
            self.openGallary()
        }))
        
        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        
        switch UIDevice.current.userInterfaceIdiom {
        case .pad:
            alert.popoverPresentationController?.sourceView = sender
            alert.popoverPresentationController?.sourceRect = sender.bounds
            alert.popoverPresentationController?.permittedArrowDirections = .up
        default:
            break
        }
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func openCamera()
    {
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerController.SourceType.camera))
        {
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
        else
        {
            let alert  = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func openGallary()
    {
        imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
        imagePicker.allowsEditing = true
        
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            self.profileImage.image = image
            self.imagePicked = true
            dismiss(animated: true, completion: nil)
        }
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    
}
