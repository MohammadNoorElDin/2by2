//
//  traineeHomeViewControllerExt.swift
//  trainee
//
//  Created by rocky on 12/9/18.
//  Copyright © 2018 personal. All rights reserved.
//

import UIKit
import SDWebImage

extension traineeHomeViewController {

    
    func getUserHomeData(completion: @escaping (_ bmi: Double?) -> () ) {
        
        let params = [UserHomeModel.Params.Fk_User: UserDataUsedThroughTheApp.userId]
        UserHomeModel.UserHomeRequest(object: self, params: params) { (response, error) in
            if error == false {
                
                print(response)
                
                if let FreeCount = response["FreeCount"]?.int {
                    if FreeCount > 0 {
                        self.freeSessionImage.isHidden = false
                        self.freeSession.isHidden = false
                        self.hasFreeBooking = true
                    } else if FreeCount == 0 {
                        if let hasGifit = response["HasGift"]?.bool {
                          //  print(hasGifit)
                            self.challengeLabel.text = "Gifts"
                            self.hasGifts = true
                            self.freeSessionImage.image = UIImage(named: "present")
                            self.freeSessionImage.isHidden = false
                        }
                    }else {
                        self.freeSessionImage.isHidden = true
                        self.freeSession.isHidden = true
                    }
                }
              //  print(response["Challenge"]?["Id"].int)
                self.newLiftPic.image = UIImage(named: "racing")
                self.newLiftPic.isHidden = false
                self.newSecLabel.text = "Challenge"
                self.newLiftLabel.text = "new"
               // print(response["HomeMessage"]?.string)
                if let challangeId = response["Challenge"]?["Id"].int, challangeId != 0 {
                   // self.freeSession.isHidden = false
                    self.ChallengeExist = true
                    self.Fk_ChallengeState = challangeId
                    if let title = response["Challenge"]?["Title"].string {
                        self.ChallengeTitle = title
                    }
                    if let desc = response["Challenge"]?["Description"].string {
                        self.ChallengeDescr = desc
                    }
                }
                if let notification = response["HomeMessage"]?.string {
                    self.newNotificationLabel.text = notification
                } else {
                    self.newNotificationLabel.text = ""
                }
                if let MBI_Result = response[UserHomeModel.returnData.BMIResult]?.double {
                    
                    if let height = response[UserHomeModel.returnData.Height]?.int {
                        self.height.text = "\(height) CM"
                        self.openOnHeight = height
                        UserDataUsedThroughTheApp.height = height
                    }
                    
                    if let weight = response[UserHomeModel.returnData.Weight]?.int  {
                        self.weight.text = "\(weight) KG"
                        self.openOnWeight = weight
                        UserDataUsedThroughTheApp.weight = weight
                    }
                    
                    completion(MBI_Result)
                }else {
                    completion(nil)
                }

            }else {
                completion(nil)
            }
            
            
        }
    }
    
    // Display UserProfile Image
    func displayUserProfileInfo() {
        if UserDataUsedThroughTheApp.userImage.isEmpty == false {
            let imagePath = UserDataUsedThroughTheApp.userImage
            self.profileImage.findMe(url: imagePath)
            self.profileImage.radiusButtonImage()
        }
        self.notificationShift.text = Generate.dayStatus
        self.notificationCoachName.text = UserDataUsedThroughTheApp.userFullName
    }
    

    
}
