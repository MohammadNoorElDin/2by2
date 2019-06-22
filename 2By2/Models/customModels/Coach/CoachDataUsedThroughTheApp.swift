//
//  CoachDataUsedThroughTheApp.swift
//  2By2
//
//  Created by rocky on 11/15/18.
//  Copyright © 2018 personal. All rights reserved.
//

import Foundation
import SwiftyJSON
import SDWebImage
import OneSignal

class CoachDataUsedThroughTheApp {
    
    static var coachFullName : String = ""
    static var coachImage : String = ""
    static var coachId : Int = 0
    
    class func saveCoachInfo(user: [String: JSON]) {
        
        if let coach = user[CoachLoginModel.returnData.Coach.structName]?.dictionary {
            print(coach)
            print(coach[CoachLoginModel.returnData.Coach.Name]?.string)
            
            CoachDataUsedThroughTheApp.coachFullName = (coach[CoachLoginModel.returnData.Coach.Name]?.string)!
            
            if let image = coach[CoachLoginModel.returnData.Coach.Image]?.string, image != "null" {
                CoachDataUsedThroughTheApp.coachImage = image
            }
            
            if let id = coach[CoachLoginModel.returnData.Coach.Id]?.int {
                CoachDataUsedThroughTheApp.coachId = id
            }
            
            if let playerId = OneSignal.getPermissionSubscriptionState().subscriptionStatus.userId {
                CoachDataUsedThroughTheApp.updateUserToken(playerId: playerId)
            }
        }
        
        
    }
    
    class func removeAll() {
        CoachDataUsedThroughTheApp.coachFullName = ""
        CoachDataUsedThroughTheApp.coachImage = ""
        CoachDataUsedThroughTheApp.coachId = 0
    }
    
    class func updateUserToken(playerId: String) {
        
        let coachId = CoachDataUsedThroughTheApp.coachId
        let params = ["Id": coachId, "NotificationToken": playerId] as [String: Any]
        CoachEditModel.CoachEditProfileRequest(object: UIViewController(), params: params) { (response, error) in
            if error == false {
                print("no eerorrs")
            }
        }
        
    }
    
    
    
    
}

class UserDataUsedThroughTheApp {
    
    static var userFullName : String = ""
    static var userEmailAddress : String = ""
    static var userImage : String = ""
    static var userAge : Int = 22
    static var userId : Int = 0
    static var height : Int = 0
    static var weight : Int = 0 
    static var Fk_BodyShapeGenderType : Int = 0
    static var NotificationToken : String = ""
    
    class func saveUserInfo(user: [String: JSON]) {
        
        if let Fk_BodyShapeGenderType = user[UserLoginModel.returnData.User.Fk_BodyShapeGenderType]?.int {
            UserDataUsedThroughTheApp.Fk_BodyShapeGenderType = Fk_BodyShapeGenderType
        }
        
        if let Image = user[UserLoginModel.returnData.User.Image]?.string, Image != "null" {
            UserDataUsedThroughTheApp.userImage = Image
        }
        
        if let Id = user[UserLoginModel.returnData.User.Id]?.int {
            UserDataUsedThroughTheApp.userId = Id
        }
        
        if let fullName = user[UserLoginModel.returnData.User.Name]?.string {
            UserDataUsedThroughTheApp.userFullName = fullName
        }
        
        if let age = user[UserLoginModel.returnData.User.Age]?.int  {
            UserDataUsedThroughTheApp.userAge = age
        }
        
        if let playerId = OneSignal.getPermissionSubscriptionState().subscriptionStatus.userId {
            UserDataUsedThroughTheApp.updateUserToken(playerId: playerId)
        }
    }
    
    
    class func removeAll() {
        UserDataUsedThroughTheApp.userFullName = ""
        UserDataUsedThroughTheApp.userImage = ""
        UserDataUsedThroughTheApp.userId = 0 
    }
    
    class func updateUserToken(playerId: String) {
        let userId = UserDataUsedThroughTheApp.userId
        let params = ["Id": userId, "NotificationToken": playerId] as [String: Any]
        
        UserEditModel.UserEdit(params: params, object: UIViewController()) { (response, error) in
            if error == false {
                print("no errorrs ")
            }
        }
    }
    
}
