//
//  traineeHomeViewController.swift
//  trainee
//
//  Created by rocky on 11/29/18.
//  Copyright © 2018 personal. All rights reserved.
//

import UIKit
import SideMenuSwift
import UICircularProgressRing
import OneSignal

class traineeHomeViewController: UIViewController {
    @IBOutlet weak var newLiftLabel: customDesignableLabel!
    @IBOutlet weak var newSecLabel: customDesignableLabel!
    @IBOutlet weak var newLiftPic: UIImageView!
    
    @IBOutlet weak var newNotificationLabel: UILabel!
    @IBOutlet weak var freeSessionImage: UIImageView!
    @IBOutlet weak var freeSession: customDesignableView!
    @IBOutlet weak var profileImage: UIButton!
    @IBOutlet weak var bmiProgress: UICircularProgressRing!
    @IBOutlet weak var height: UILabel!
    @IBOutlet weak var weight: UILabel!
    @IBOutlet weak var BMI_Result_Label: UILabel!
    @IBOutlet weak var BMI_Result_Result: UILabel!
    @IBOutlet weak var heightView: UIView!
    @IBOutlet weak var weightView: UIView!
    @IBOutlet weak var notificationCoachName: UILabel!
    @IBOutlet weak var notificationShift: UILabel!
    @IBOutlet weak var freeLabel: UILabel!
    @IBOutlet weak var challengeLabel: UILabel!
    @IBOutlet weak var leftNewView: customDesignableView!
    
    var selectedHeight: Int = 0
    var selectedWeight: Int = 0
    var openOnHeight: Int = 0
    var openOnWeight: Int = 0
    
    var baseBMIResult: Double = 0.0
    var replicated: Double = 0.0
    var timeinterval: Double = 0.02
    var stopAt: Double = 0.02 // 2 sec
    var timer: Timer!
    var bookingModel: BookingDataModel!
    var addCreditCardFirst: Bool = false
    var heightViewClicked: Bool = false // true >> weightViewClicked
    var heightWeightObserver:NSObjectProtocol?
    // to know if he have a gifts or have a Free Booking
    var hasGifts: Bool = false
    var hasFreeBooking: Bool = false
    // challange
    var ChallengeTitle: String = ""
    var ChallengeDescr: String = ""
    var ChallengeExist: Bool = false
    var Fk_ChallengeState: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bmiProgress.maxValue = 40
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(heightViewClicked(tapGestureRecognizer:)))
        heightView.isUserInteractionEnabled = true
        heightView.addGestureRecognizer(tapGestureRecognizer) // for the height
        
        let tapGestureRecognizer2 = UITapGestureRecognizer(target: self, action: #selector(weighthtViewClicked(tapGestureRecognizer:)))
        weightView.isUserInteractionEnabled = true
        weightView.addGestureRecognizer(tapGestureRecognizer2) // for the weight popup
     
        let tapGestureRecognizer3 = UITapGestureRecognizer(target: self, action: #selector(viewTapped(tapGestureRecognizer:)))
        freeSession.isUserInteractionEnabled = true
        freeSession.addGestureRecognizer(tapGestureRecognizer3) // for the free session view
        
        let tapGestureRecognizer4 = UITapGestureRecognizer(target: self, action: #selector(challengeViewTapped(tapGestureRecognizer:)))
        leftNewView.isUserInteractionEnabled = true
        leftNewView.addGestureRecognizer(tapGestureRecognizer4) // for challange taped
        
        self.bookingModel = BookingDataModel()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        // MARK:- BMI SETTINGS
        bmiProgress.outerRingColor = .lightGray
        bmiProgress.outerRingWidth = 5
        bmiProgress.ringStyle = .ontop
        
        getUserHomeData { (bmi) in
            if let bmi = bmi {
                self.bmiResult(bmi: bmi)
            }
        }
        
        self.displayUserProfileInfo()
        
        self.sideMenuController?.cacheViewController(withIdentifier: "traineeprofileView", with: "trainee-profile")
        
        self.heightWeightObserver = addCustomObserver(name: .hw, completion: { (notification) in
            if let vc = notification.object as? HWPopupViewController {
                
                guard vc.selectedHeight != 0, vc.selectedWeight != 0 else {
                    return
                }
                self.selectedHeight = vc.selectedHeight
                self.height.text = "\(self.selectedHeight) CM"
                self.selectedWeight = vc.selectedWeight
                self.weight.text = "\(self.selectedWeight) KG"
                
                self.updateUserData {
                    self.selectedWeight = 0
                    self.selectedHeight = 0
                    self.rootViewController()
                }
            }
        })
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        
        if let heightWeightObserver = heightWeightObserver {
            NotificationCenter.default.removeObserver(heightWeightObserver)
        }
    }
    
    /*
     | ========================================================
     | GESTURERECOGNISER STATUS
     | ========================================================
     | 1- free session tapped
     | 2- hight tapped
     | 2- weight tapped
     */
    
    @objc func viewTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
       //  self.performSegue(withIdentifier: "toGifts", sender: self)
       if hasFreeBooking == true {
            self.bookingModel.isFree = true
            self.performSegue(withIdentifier: segueIdentifier.toChooseYourProgramSegue, sender: self)
        }
        else if hasGifts == true {
           // self.rootViewController()
            self.performSegue(withIdentifier: "toGifts", sender: self)
        }
    }
    
    @objc func challengeViewTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        if self.ChallengeExist == true {
            Alerts.DisplayDefaultAlertWithActions(title: self.ChallengeTitle, message: self.ChallengeDescr, object: self, buttons: ["CANCEL": .cancel, "OK": .default], actionType: .default) { (name) in
                if name == "OK" {
                    let params = [
                        "Fk_User": UserDataUsedThroughTheApp.userId,
                        "Fk_Notification": self.Fk_ChallengeState,
                        "Fk_ChallengeState": 1
                        ] as [String : Any]
                    
                    UserChallangesModel.EditUserChallangeRequest(object: self, params: params, completion: { (reponse, error) in
                        if error == false {
                            self.rootViewController()
                        }else {
                            print("true errors")
                        }
                    })
                }
            }
        }
        else {
            Alerts.DisplayDefaultAlert(title: "Error" , message: "You Have no Challanges", object: self, actionType: .cancel)
        }
    }
    
    @objc func heightViewClicked(tapGestureRecognizer: UITapGestureRecognizer)
    {
        openBMIPOPUP(choosen: true)
    }
    
    @objc func weighthtViewClicked(tapGestureRecognizer: UITapGestureRecognizer)
    {
        openBMIPOPUP(choosen: false)
    }
    
    @objc func update() {
        
        if Int(self.stopAt) == 2 {
            
            self.timer.invalidate()
            self.BMI_Result_Result.text = "\(self.baseBMIResult)"
            
        } else {
            let theIncreaseseEveryTimeInterval = self.baseBMIResult * 0.01 // half of the timeInterval
            self.replicated += theIncreaseseEveryTimeInterval
            self.BMI_Result_Result.text = "\(Double( round( self.replicated * 10 )) / 10)"
            self.stopAt += self.timeinterval
        }
    }
    
    /*
     | ==========================================
     | CLASS @IBACTIONS
     | ==========================================
     | 1- openProfileController
     | 2- openSideMenu
     | 3- letsGoChamp
     */
    
    @IBAction func openProfileController(_ sender: UIButton) {
        self.sideMenuController?.setContentViewController(with: "trainee-profile")
    }
    
    @IBAction func openSideMenu(_ sender: UIBarButtonItem) {
        self.sideMenuController?.revealMenu()
    }
    
    @IBAction func letsGoChamp(_ sender: UIButton) {
        self.bookingModel.isFree = false
        performSegue(withIdentifier: segueIdentifier.toChooseYourProgramSegue, sender: self)
    }
    
    /*
     | ==========================================
     | FUNCTIONS OF THE CLASS
     | ==========================================
     | 1- updateUserData
     | 2- openBMIPOPUP
     | 3- bmiResult
     | 4- changeProgressColor
     | 5- prepare function
     */
    
    func updateUserData(completion: @escaping () -> ()) {
        
        let params = [
            UserEditModel.params.Id : UserDataUsedThroughTheApp.userId,
            UserEditModel.params.Height: selectedHeight,
            UserEditModel.params.Weight: selectedWeight,
        ]
        
        UserEditModel.UserEdit(params: params, object: self) { (response, error) in
            if error == false {
                completion()
            }
        }
    }
    
    func openBMIPOPUP(choosen: Bool) {
        
        heightViewClicked = choosen
        let tab = PopusHandle.HWPopupViewController()
        
        tab.selectedHeight = self.openOnHeight
        tab.selectedWeight = self.openOnWeight
        
        present(tab, animated: true, completion: nil)
        
    }
    
    func bmiResult(bmi: Double){
        
        var bmi: Double = bmi
        var color : UIColor = Theme.bmiObese()
        self.baseBMIResult = bmi
        
        if bmi > 40 {
            bmi = 39.0;
            self.BMI_Result_Label.text = "30.0 and above Obese";
            self.BMI_Result_Label.textColor = Theme.bmiObese()
        } else if (bmi >= 30) {
            self.BMI_Result_Label.text = "30.0 and above Obese";
            self.BMI_Result_Label.textColor = Theme.bmiObese()
            
        } else if (bmi >= 25) {
            self.BMI_Result_Label.text = "25.0 – 29.9 Overweight";
            self.BMI_Result_Label.textColor = Theme.bmiOver()
            color = Theme.bmiOver()
        } else if (bmi >= 18.5) {
            self.BMI_Result_Label.text = "18.5 – 24.9 Normal";
            self.BMI_Result_Label.textColor = Theme.bmiNormal()
            color = Theme.bmiNormal()
        } else if (bmi == 0) {
            self.BMI_Result_Label.text = "You should set your height and weight.";
        } else {
            self.BMI_Result_Label.text = "Below 18.5 Underweight";
            self.BMI_Result_Label.textColor = Theme.bmiUnder()
            color = Theme.bmiUnder()
        }
        
        if bmi == 0 {
            self.BMI_Result_Result.text = "BMI"
            self.height.text = "Height"
            self.weight.text = "Weight"
        }else {
            if self.replicated == 0.0 {
                self.timer = Timer.scheduledTimer(timeInterval: self.timeinterval, target: self, selector: #selector(update), userInfo: nil, repeats: true)
            }
        }
        
        self.BMI_Result_Result.textColor = color
        changeProgressColor(to: CGFloat(bmi), color: color)
    }
    
    func changeProgressColor(to: CGFloat, color: UIColor) {
        self.bmiProgress.startAngle = 270
        self.bmiProgress.innerRingColor = color
        bmiProgress.startProgress(to: to, duration: 2.0) {}
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == segueIdentifier.toChooseYourProgramSegue {
            if let dest = segue.destination as? ChooseProgramViewController {
                self.bookingModel.height = self.openOnHeight
                self.bookingModel.weight = self.openOnWeight
                dest.bookingModel = self.bookingModel
            }
        }
        if segue.identifier == segueIdentifier.toTraineePaymentsViewControllerSegue {
            if let dest = segue.destination as? traineePaymentViewController {
                if self.addCreditCardFirst == true {
                    dest.addCreditCardFirst = self.addCreditCardFirst
                }
            }
        }
    }
    
}
