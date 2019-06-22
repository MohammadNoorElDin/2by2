//
//  BookingDataModel.swift
//  trainee
//
//  Created by rocky on 12/31/18.
//  Copyright © 2018 personal. All rights reserved.
//

import Foundation

class BookingDataModel {
    
    /* 1-
     * DATA TAKEN FROM ( ChooseProgramViewController )
     */
    
    var Second_Category_Program: Int = 0
    var Second_Category_Program_Name: String = ""
    
    /* 2-
     * DATA TAKEN FROM ( traineeMapViewController )
     */
    
    var latitude: Double = 0.0
    var lngitude: Double = 0.0
    
    /* 3- 
     * DATA TAKEN FROM ( ChoosePackageViewController )
     */
    
    var Package_Name: String = ""
    var packagePrice: Int = 0
    var Fk_PackagePersonRangePrice: Int = 4
    var availableSessions: Int = 0
    var friends = [FriendsInfo]()
    
    /* 3-
     * DATA TAKEN FROM ( AboutTraineeViewController )
     */
    
    var height: Int = 0
    var weight: Int = 0
    var level: Int = 0
    var ageGroup: Int = 0
    
    /* 3-
     * DATA TAKEN FROM ( PickYourCoachViewController )
     */
    
    var coachId: Int = 0
    var coachName: String = ""
    var coachImage: String = ""
    
    /* 3-
     * DATA TAKEN FROM ( traineeAgendaHomeViewController )
     */
    
    var FK_Agenda = [Int]()
    var isFree: Bool = false
    var isDuplicate: Bool = false
    
    /* 3-
     * DATA TAKEN FROM ( ConfirmPaymentViewController )
     */
    
    var paymentOption: Int = 1
    var paymentMethod: Int = 0
    var CreditId: Int = 0
    var totalPaid: Int = 0
    
    
    /* 3-
     * DATA TAKEN FROM ( traineeSessionViewController ) // modifying 
     */
    
    var isModifyingPrograms: Bool = false
    var dateWhichNeedsToBeUpdated: String = ""
    var timeWhichNeedsToBeUpdated: String = ""
    var isModifyingFk_SecondCategoryProgram:Int = 0
    var isModifyingFk_Reservation: Int = 0
    var isModifyingFk_ReservationInfoId: Int = 0
    var isModifyingFk_State: Int = 0
    var isscheduling: Bool = false 
    
    
    /* 3-
     * DATA TAKEN FROM ( traineeGiftsViewController )
     */
    
    var FK_Gift: Int = 0
    var DisCount: Int = 0
    
    class func returnJsonRequest(object: BookingDataModel) -> [String: Any] {
        var option : Int = 0 
        
        if object.isFree == true {
            option = 3
        }else {
            option = object.paymentOption
        }
        
        var params = [
            "IsFree": object.isFree,
            "IsReplicated":object.isDuplicate,
            "Reservation": [
                "Fk_UserOwner": UserDataUsedThroughTheApp.userId,
                "Fk_PackagePersonRangePrice": object.Fk_PackagePersonRangePrice,
                "IsGroup": ( object.friends.count > 0 ) ? true : false ,
                "Fk_PaymentOption": option
            ],
            "ReservationGroupInfo": [
                "Fk_AgeGroupRange": object.ageGroup,
                "Fk_Level":object.level
            ],
            "UserCreditTransaction": [
                "Fk_UserCredit": object.CreditId
            ],
            "UserPaymentHistory": [
                "Fk_PaymentMethod":object.paymentMethod,
                "Paid":object.totalPaid,
                "Fk_User": UserDataUsedThroughTheApp.userId
            ]
        ] as [String: Any]
        
        var agendas = [Any]()
        
        object.FK_Agenda.forEach { (agenda) in
            let ob = [
                "Fk_Agenda":agenda,
                "Fk_SecondCategoryProgram":object.Second_Category_Program,
                "Latitude":object.latitude,
                "Longitude":object.lngitude
            ] as [String : Any]
            agendas.append(ob)
        }
        
        params["ReservationsInfos"] = agendas
        
        var ReservationGroupMembers = [Any]()
        object.friends.forEach { (friend) in
            let ob = [
                "Name": friend.name,
                "Phone":friend.mobile
            ]
            ReservationGroupMembers.append(ob)
        }
        
        params["ReservationGroupMembers"] = ReservationGroupMembers
        
        if object.FK_Gift != 0 {
            params["FK_Gift"] = object.FK_Gift
        }
        
        return params
    }
    
    class func returnScheduleRequest(object: BookingDataModel) -> [String: Any] {
        
        var params = [
            "IsReplicated":object.isDuplicate
        ] as [String: Any]
        
        var agendas = [Any]()
        
        object.FK_Agenda.forEach { (agenda) in
            let ob = [
                "Fk_Agenda": agenda,
                "Fk_SecondCategoryProgram": object.isModifyingFk_SecondCategoryProgram,
                "Fk_Reservation": object.isModifyingFk_Reservation,
                "Longitude": object.lngitude,
                "Fk_State": object.isModifyingFk_State,
                "Latitude": object.latitude
            ] as [String : Any]
            agendas.append(ob)
        }
        
        params["ReservationsInfos"] = agendas
        
        return params
    }
    
    
    class func returnEditRequest(object: BookingDataModel) -> [String: Any] {
     
        let params = [
            "Id": object.isModifyingFk_ReservationInfoId,
            "Fk_Agenda": object.FK_Agenda[0],
            "Fk_SecondCategoryProgram": object.Second_Category_Program,
            "Fk_Reservation": object.isModifyingFk_Reservation,
            "Fk_State": object.isModifyingFk_State,
            "Longitude": object.lngitude,
            "Latitude": object.latitude
        ] as [String: Any]
        
        return params
        
    }
    
}


