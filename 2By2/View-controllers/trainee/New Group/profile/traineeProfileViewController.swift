//
//  traineeProfileViewController.swift
//  trainee
//
//  Created by rocky on 12/24/18.
//  Copyright © 2018 personal. All rights reserved.
//

import UIKit
import SwiftyJSON
import SDWebImage
import Firebase
import FirebaseAuth

class traineeProfileViewController: UIViewController {
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var profileName: UITextField!
    @IBOutlet weak var genderBtn: UIButton!
    @IBOutlet weak var ageBtn: UIButton!
    @IBOutlet weak var mobileNumber: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var shapesCV: UICollectionView!
    
    let nib_identifier: String = "shapesProfileCollectionViewCell"
    var genders = [GenderModel]()
    var ShapeGenderTypes = [JSON]()
    var imagePicker = UIImagePickerController()
    var selectedAge: Int = 0
    var selectedGender: Int = 0 // Male 1 , Female 2
    var imagePicked: Bool = false
    var shapesNumber: Int = 0
    var GenderShapes = [ShapesModel]()
    var password: String? = nil
    var selectedShape : Int = 0
    var changeMobileStatus: Bool = false
    
    var ageObserser: NSObjectProtocol?
    var genderObserser: NSObjectProtocol?
    var mobileObserser: NSObjectProtocol?
    var passwordObserser: NSObjectProtocol?
    var selectedShapeBool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.imagePicker.delegate = self as UIImagePickerControllerDelegate & UINavigationControllerDelegate
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        self.getUserCreateData {
            self.userProfileData()
            self.displayUserProfileInfo()
        } // get user register data first ......
        
        self.ageObserser = self.addCustomObserver(name: .age) { (notification) in
            if let vc = notification.object as? AgePopUpViewController {
                self.selectedAge = vc.selectedAge // SET AGE FIRST
                self.ageBtn.setTitle("    \(vc.selectedAge)", for: .normal)
                self.DisplayShape()
            }
        }
        self.genderObserser = self.addCustomObserver(name: .gender) { (notification) in
            if let vc = notification.object as? GenderPopUpViewController {
                // SET GENDER FIRST
                self.selectedGender = vc.selectedGenderId
                self.genderBtn.setTitle("  \(vc.selectedGender)", for: .normal)
                self.DisplayShape()
            }
        }
        self.mobileObserser = self.addCustomObserver(name: .changeMobile) { (notification) in
            if let _ = notification.object as? changePOPUPViewController {
                self.changeMobileStatus = true
            }
        }
        self.passwordObserser = self.addCustomObserver(name: .changePassword) { (notification) in
            if let changePasswordVC = notification.object as? changePasswordPOPUPViewController {
                self.password = changePasswordVC.password
            }
        }
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(viewTapped(tapGestureRecognizer:)))
        profileImage.isUserInteractionEnabled = true
        profileImage.addGestureRecognizer(tapGestureRecognizer)
        
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
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        
        if let ageObserser = ageObserser { NotificationCenter.default.removeObserver(ageObserser) }
        if let genderObserser = genderObserser { NotificationCenter.default.removeObserver(genderObserser) }
        if let mobileObserser = mobileObserser { NotificationCenter.default.removeObserver(mobileObserser) }
        if let passwordObserser = passwordObserser { NotificationCenter.default.removeObserver(passwordObserser) }
        
    }
    
    @IBAction func openSideMenu(_ sender: Any) {
        self.sideMenuController?.revealMenu()
    }
    
    @IBAction func mobileChange(_ sender: UIButton) {
        
        guard let phone = mobileNumber.text, !phone.isEmpty, Validation.isValidPhoneNumber(phone) else {
            return
        }
        
        MobileAuthRequest.changeMobile(phone: phone, object: self) { (status) in
            if status == true {
                let tab = PopusHandle.changePOPUPViewController()
                self.present(tab, animated: true, completion: nil)
            }
        }
        
    }
    @IBAction func saveClicked(_ sender: UIButton) {
        
        self.shapesCV.visibleCells.forEach { (cell) in
            if let cell = cell as? shapesCollectionViewCell {
                if cell.shapeImage.backgroundColor == .lightGray {
                    self.selectedShapeBool = true
                    return
                }
            }
        }
        
        guard self.selectedShapeBool == true else  {
            Alerts.DisplayDefaultAlert(title: "", message: "Please select Shape", object: self, actionType: .default)
            return
        }
        
        self.selectedShapeBool = false
        
        if validateUserData() == true {
            if imagePicked == true {
                
                let paramsImage = [
                    "Id": String(UserDataUsedThroughTheApp.userId),
                ]
                APIRequests.uploadImage(toUrl: Constants.uploadImage, parameters: paramsImage, selectedImage: self.profileImage.image!) { (status, data) in
                    if status == true {
                        let image = data as! String
                        self.saveNewUserData(image: image)
                    }
                }
            }else {
                self.saveNewUserData(image: nil)
            }
        }
        
    }
    @IBAction func changePassword(_ sender: UIButton) {
        
        let tab = PopusHandle.changePasswordPopupViewController()
        present(tab, animated: true, completion: nil)
        
    }
    
    @IBAction func genderClicked(_ sender: UIButton) {
        let tab = PopusHandle.openGenderPopup()
        tab.genders = genders
        present(tab, animated: true, completion: nil)
    }
    @IBAction func ageClicked(_ sender: UIButton) {
        let tab = PopusHandle.openAgePopup()
        tab.startingFrom = 7 
        present(tab, animated: true, completion: nil)
    }
    
    func saveNewUserData(image: String?) {
        
        var params = [
            UserCreateModel.UserCreatePostRequest.Params.Id: UserDataUsedThroughTheApp.userId,
            UserCreateModel.UserCreatePostRequest.Params.Name: self.profileName.text!,
            UserCreateModel.UserCreatePostRequest.Params.Fk_Gender: self.selectedGender,
            UserCreateModel.UserCreatePostRequest.Params.Age: self.selectedAge,
            UserCreateModel.UserCreatePostRequest.Params.Fk_BodyShapeGenderType: self.selectedShape,
            UserCreateModel.UserCreatePostRequest.Params.Email: self.emailTF.text!
            ] as [String: Any]
        
        if image != nil {
            params[UserCreateModel.UserCreatePostRequest.Params.Image] = image
            SDImageCache.shared().clearDisk(onCompletion: {
                SDImageCache.shared().clearMemory()
                UserDataUsedThroughTheApp.userImage = image!
            })
        }
        
        if let pass = self.password {
            params[UserCreateModel.UserCreatePostRequest.Params.Password] = pass
        }
        
        if self.changeMobileStatus == true {
            params[UserCreateModel.UserCreatePostRequest.Params.Phone] = self.mobileNumber.text!
        }
        
        UserEditModel.UserEdit(params: params, object: self) { (response, error) in
            
            if error == true {
                Alerts.DisplayActionSheetAlert(title: "", message: (response[Constants.Message]?.string)!, object: self, actionType: .default)
                
                return
            }else {
                // THIS IN CASE USER LOGGED IN USING ANY PLUGIN
                if let ProviderID = response[UserCreateModel.UserCreatePostRequest.Params.ProviderID]?.string {
                    
                    PersistentStructure.saveData(data: [
                        PersistentStructureKeys.ProviderID : ProviderID,
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
                UserDataUsedThroughTheApp.userFullName = self.profileName.text!
                
                // MOVE TO THE HOME-COACH STORYBOARD
                self.present(MoveToStoryBoard.moveTo(sb: MoveToStoryBoard.trainee_home), animated: true, completion: nil )
                
            }
        }
        
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
    func displayUserProfileInfo() {
        if imagePicked == false {
            self.profileImage.findMe(url: UserDataUsedThroughTheApp.userImage)
        }
        self.profileName.text = UserDataUsedThroughTheApp.userFullName
    }
}

// MARK:- COLLECTION VIEW DATA SOURCE
extension traineeProfileViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return shapesNumber
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: nib_identifier, for: indexPath) as! shapesCollectionViewCell
        
        let imagePath = self.GenderShapes[indexPath.row].Image
        cell.shapeImage.findMe(url: imagePath ?? "", mode: true)
        cell.shapeTitle.text = self.GenderShapes[indexPath.row].Name
        
        if self.selectedShape == GenderShapes[indexPath.row].Id {
            cell.shapeImage.backgroundColor = .lightGray
        } else {
            cell.shapeImage.backgroundColor = .clear
        }
        
        return cell
    }
    
    
}

// MARK:- COLLECTIONVIEW DELEGATE
extension traineeProfileViewController: UICollectionViewDelegate {
    
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

//MARK:- GET USER DATA
extension traineeProfileViewController {
    
    func getUserCreateData(completion: @escaping () -> () ) {
        
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
  
                
            }
            completion()
        }
    }
    
    func userProfileData() {
        
        let phone = PersistentStructure.getKey(key: PersistentStructureKeys.userPhone) ?? ""
        let password = PersistentStructure.getKey(key: PersistentStructureKeys.userPassword) ?? ""
        let loginType = PersistentStructure.getKeyInt(key: PersistentStructureKeys.userLoginType)!
        let providerId = PersistentStructure.getKey(key: PersistentStructureKeys.ProviderID) ?? ""
        
        let params = [
            UserLoginModel.Params.Phone: phone,
            UserLoginModel.Params.Password: password,
            UserLoginModel.Params.Fk_LoginType: loginType,
            UserLoginModel.Params.ProviderID: providerId
            ] as [String : Any]
        
        UserLoginModel.UserLogin(params: params, object: self, completion: { (response, error) in
            
            // I THINK U WILL NEED TO SEE THE RETURNED DATA AND SAVE THE COACH ID IN THE
            // USER DEFAULTS
            
            if error == true {
                // Display Alert To The User
                Alerts.DisplayDefaultAlert(title: "", message: (response[Constants.Message]?.string)!, object: self, actionType: .cancel)
                
                return
            }
            
            if let genderSelect = response["Gender"]?["Id"].int {
                self.selectedGender = genderSelect
                if let ageSelect = response["Age"]?.int {
                    
                    if let email = response["Email"]?.string {
                        self.emailTF.text = email
                    }
                    
                    self.selectedAge = ageSelect
                    let genderName = ( response["Gender"]?["Name"].string ?? "Male" )
                    self.genderBtn.setTitle("  \(genderName)", for: .normal)
                    self.ageBtn.setTitle("    \(self.selectedAge)", for: .normal)
                    
                    if let selectedOne = response["BodyShapeGenderType"]?["Id"].int {
                        self.selectedShape = selectedOne
                        self.DisplayShape()
                        self.shapesCV.reloadData()
                    }
                }
            }
            
        })
    }
    
    func validateUserData() -> Bool {
        
        guard let fullName = profileName.text, !fullName.isEmpty else {
            Alerts.DisplayActionSheetAlert(title: "", message: Messenger.emptyName, object: self, actionType: .default)
            return false
        }
        
        guard let phone = mobileNumber.text, !phone.isEmpty else {
            Alerts.DisplayActionSheetAlert(title: "", message: Messenger.wrongPhoneNumber, object: self, actionType: .default)
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
    
    @IBAction func reset(_ sender: UIButton) {
        self.viewDidAppear(true)
    }
    
}


// MARK:- UPLOAD AN IMAGE
extension traineeProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBAction func uploadProfileImage(_ sender: UIButton) {
        
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
    
    func openCamera(){
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
    func openGallary(){
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
