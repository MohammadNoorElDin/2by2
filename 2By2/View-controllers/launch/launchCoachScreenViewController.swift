//
//  launchCoachScreenViewController.swift
//  2By2
//
//  Created by rocky on 12/16/18.
//  Copyright © 2018 personal. All rights reserved.
//

import UIKit
import AVFoundation
import OneSignal

class launchCoachScreenViewController: UIViewController {
    
    var avPlayer: AVPlayer!
    var avPlayerLayer: AVPlayerLayer!
    var paused: Bool = false
    
    override func viewDidLoad() {
        
        let theURL = Bundle.main.url(forResource: "final_motion", withExtension: "mp4")
        
        avPlayer = AVPlayer(url: theURL!)
        avPlayerLayer = AVPlayerLayer(player: avPlayer)
        avPlayerLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        avPlayer.volume = 0
        avPlayer.actionAtItemEnd = AVPlayer.ActionAtItemEnd.none
        
        avPlayerLayer.frame = view.layer.bounds
        view.backgroundColor = UIColor.clear
        view.layer.insertSublayer(avPlayerLayer, at: 0)
        
        self.sendAuthRequest() // check if user data is avilable or not
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil, queue: OperationQueue.main) { (notification) in
            
            if let p = notification.object as? AVPlayerItem {
                p.seek(to: CMTime.zero)
                self.changeVideoStatus(status: true)
            }
            
            #if trainee
                self.moveToViewController(trainee: MoveToStoryBoard.trainee_auth, coach: nil)
            #else
                self.moveToViewController(trainee: nil, coach: MoveToStoryBoard.auth)
            #endif
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        changeVideoStatus(status: false)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        changeVideoStatus(status: true)
    }
    
    func changeVideoStatus(status: Bool) {
        if status == false {
            avPlayer.play()
        }else {
            avPlayer.pause()
        }
        paused = status
    }
    
    func sendAuthRequest() {
        DispatchQueue.main.asyncAfter(wallDeadline: .now() + 3.5) {
            #if trainee
                self.checkIfUserPasswordStillValidTrainee()
            #else
                self.checkIfUserPasswordStillValid()
            #endif
        }
    }
    
    /*
     |---------------------------------------
     | first three function for coach
     |---------------------------------------
     | 1- checkIfUserPasswordStillValid
     | 2- login
     | 3- loginWithPlugin
     */
    
    func checkIfUserPasswordStillValid() {
        
        PersistentStructure.getObject(key: PersistentStructureKeys.coachLoginType) { (value, exist) in
            if exist == true {
                if let type = value as? Int {
                    
                    if type == 1 || type == 2 {
                        // USER LOGGED IN USING FACEBOOK OR GMAIL
                        // USER LOGGGED IN USING DEFAULT WAY
                        let providerId = PersistentStructure.getKey(key: PersistentStructureKeys.ProviderID)!
                        let LoginType = Int(type)
                        self.loginWithPlugin(ProviderId: providerId, loginType: LoginType)
                    } else if type == 3 {
                        // USER LOGGGED IN USING DEFAULT WAY
                        if let phone = PersistentStructure.getKey(key: PersistentStructureKeys.coachPhone) {
                            if let pass = PersistentStructure.getKey(key: PersistentStructureKeys.coachPassword) {
                                self.login(phone: phone, password: pass, logintype: 3)
                            }
                        }
                        
                    }
                }
            }else {
                //self.moveToViewController(trainee: nil, coach: MoveToStoryBoard.auth)
                if let p = self.avPlayerLayer.player?.currentItem {
                    p.seek(to: CMTime.zero)
                    self.changeVideoStatus(status: true)
                    
                    self.moveToViewController(trainee: nil, coach: MoveToStoryBoard.auth)
                }
            }
        } // login Type ......
        
    }
    
    func login(phone: String, password: String, logintype: Int?) {
        
        guard !phone.isEmpty, Validation.isValidPhoneNumber(phone) else {
            
            Alerts.DisplayActionSheetAlert(title: "", message: Messenger.wrongPhoneNumber, object: self, actionType: .cancel)
            return
        }
        
        guard !password.isEmpty, Validation.isBetween(str: password, from: 6, to: 100)  else {
            Alerts.DisplayActionSheetAlert(title: "", message: Messenger.emptyPassword, object: self, actionType: .cancel)
            return
        }
        
        let params = [CoachLoginModel.Params.Phone: phone, CoachLoginModel.Params.Password: password,
                      CoachLoginModel.Params.Fk_LoginType: logintype ?? 3 ] as [String : Any]
        
        CoachLoginModel.CoachLogin(params: params, object: self, completion: { (user, error) in
            
            // I THINK U WILL NEED TO SEE THE RETURNED DATA AND SAVE THE COACH ID IN THE
            // USER DEFAULTS
            
            if error == true {
                //self.moveToViewController(trainee: nil, coach: MoveToStoryBoard.auth)
                if let p = self.avPlayerLayer.player?.currentItem {
                    p.seek(to: CMTime.zero)
                    self.changeVideoStatus(status: true)
                    self.moveToViewController(trainee: nil, coach: MoveToStoryBoard.auth)
                }
            }
            
            
            let coach = user[CoachLoginModel.returnData.Coach.structName]
            
            if let phone = coach?[CoachLoginModel.returnData.Coach.Phone].string,
                let password = coach?[CoachLoginModel.returnData.Coach.Password].string,
                let coachId = coach?[CoachLoginModel.returnData.Coach.Id].int {
                PersistentStructure.saveData(data: [PersistentStructureKeys.coachPhone : phone, PersistentStructureKeys.coachPassword : password, PersistentStructureKeys.coachLoginType : 3,
                                                    PersistentStructureKeys.coachId : coachId,
                                                    ])
            }
            
            CoachDataUsedThroughTheApp.saveCoachInfo(user: user)
            
            // MOVE TO THE MAIN STORYBOARD
            
            if let p = self.avPlayerLayer.player?.currentItem {
                p.seek(to: CMTime.zero)
                self.changeVideoStatus(status: true)
                self.moveToViewController(trainee: nil, coach: MoveToStoryBoard.home_coach)
            }
            
        })
    }
    
    func loginWithPlugin(ProviderId id: String, loginType: Int){
        
        let params = [
            CoachLoginModel.Params.Fk_LoginType: loginType,
            CoachLoginModel.Params.ProviderID: id
            ] as [String : Any]
        
        CoachLoginModel.CoachLogin(params: params, object: self, completion: { (user, error) in
            
            if let ProviderID = user[CoachLoginModel.returnData.Coach.structName]?[CoachLoginModel.returnData.Coach.ProviderID].string, let coachId = user[CoachLoginModel.returnData.Coach.structName]?[CoachLoginModel.returnData.Coach.Id].int {
                
                PersistentStructure.saveData(data: [
                    PersistentStructureKeys.ProviderID : ProviderID,
                    PersistentStructureKeys.coachId : coachId,
                    PersistentStructureKeys.coachLoginType : loginType
                    ]
                )
                
                CoachDataUsedThroughTheApp.saveCoachInfo(user: user)
                
                
                if let p = self.avPlayerLayer.player?.currentItem {
                    
                    p.seek(to: CMTime.zero)
                    self.changeVideoStatus(status: true)
                    self.moveToViewController(trainee: nil, coach: MoveToStoryBoard.home_coach)
                    
                }
                
            } // else complete the video
            
        })
        
    }
    
    /*
     |---------------------------------------
     | first three function for coach
     |---------------------------------------
     | 1- checkIfUserPasswordStillValidTrainee
     | 2- loginForTrainee
     | 3- loginWithPluginTrainee
     */
    
    func loginForTrainee(phone: String, password: String, logintype: Int?) {
        
        guard !phone.isEmpty, Validation.isValidPhoneNumber(phone) else {
            Alerts.DisplayActionSheetAlert(title: "", message: Messenger.wrongPhoneNumber, object: self, actionType: .cancel)
            return
        }
        
        guard !password.isEmpty, Validation.isBetween(str: password, from: 6, to: 100)  else {
            Alerts.DisplayActionSheetAlert(title: "", message: Messenger.emptyPassword, object: self, actionType: .cancel)
            return
        }
        
        let params = [UserLoginModel.Params.Phone: phone, UserLoginModel.Params.Password: password,
                      UserLoginModel.Params.Fk_LoginType: logintype ?? 3 ] as [String : Any]
        
        UserLoginModel.UserLogin(params: params, object: self, completion: { (response, error) in
            
            // I THINK U WILL NEED TO SEE THE RETURNED DATA AND SAVE THE COACH ID IN THE
            // USER DEFAULTS
            
            if error == true {
                // Display Alert To The User
                Alerts.DisplayDefaultAlert(title: "", message: (response[Constants.Message]?.string)!, object: self, actionType: .cancel)
                
                return
            }
            
            
            if let phone = response[UserLoginModel.returnData.User.Phone]?.string,
                let password = response[UserLoginModel.returnData.User.Password]?.string {
                
                PersistentStructure.saveData(data: [PersistentStructureKeys.userPhone : phone, PersistentStructureKeys.userPassword : password, PersistentStructureKeys.userLoginType : 3])
            }
            
            UserDataUsedThroughTheApp.saveUserInfo(user: response)

            
            if let p = self.avPlayerLayer.player?.currentItem {
                p.seek(to: CMTime.zero)
                self.changeVideoStatus(status: true)
                self.moveToViewController(trainee: MoveToStoryBoard.trainee_home, coach: nil)
            }
            
        })
    }
    
    func checkIfUserPasswordStillValidTrainee() {
        
        PersistentStructure.getObject(key: PersistentStructureKeys.userLoginType) { (value, exist) in
            if exist == true {
                if let type = value as? Int {
                    
                    if type == 1 || type == 2 {
                        // USER LOGGED IN USING FACEBOOK OR GMAIL
                        let providerId = PersistentStructure.getKey(key: PersistentStructureKeys.ProviderID)!
                        let LoginType = type
                        self.loginWithPluginTrainee(ProviderId: providerId, loginType: LoginType)
                    } else if type == 3 {
                        // USER LOGGGED IN USING DEFAULT WAY
                        let phone = PersistentStructure.getKey(key: PersistentStructureKeys.userPhone)!
                        let pass = PersistentStructure.getKey(key: PersistentStructureKeys.userPassword)!
                        self.loginForTrainee(phone: phone, password: pass, logintype: 3)
                    }
                }
            }else {
            
                if let p = self.avPlayerLayer.player?.currentItem {
                    p.seek(to: CMTime.zero)
                    self.changeVideoStatus(status: true)
                    self.moveToViewController(trainee: MoveToStoryBoard.trainee_auth, coach: nil)
                }
            }
        } // login Type ......
        
    }
    
    func loginWithPluginTrainee(ProviderId id: String, loginType: Int){
        
        let params = [
            UserLoginModel.Params.Fk_LoginType: loginType,
            UserLoginModel.Params.ProviderID: id
            ] as [String : Any]
        
        UserLoginModel.UserLogin(params: params, object: self, completion: { (user, error) in
            
            if let ProviderID = user[UserLoginModel.returnData.User.ProviderID]?.string {
                
                PersistentStructure.saveData(data: [
                    PersistentStructureKeys.ProviderID : ProviderID,
                    PersistentStructureKeys.userLoginType : loginType
                    ]
                )
                
                UserDataUsedThroughTheApp.saveUserInfo(user: user)
                
                if let p = self.avPlayerLayer.player?.currentItem {
                    p.seek(to: CMTime.zero)
                    self.changeVideoStatus(status: true)
                    self.moveToViewController(trainee: MoveToStoryBoard.trainee_home, coach: nil)
                }
                
                
            }
            
        })
        
    }
    
    
}
