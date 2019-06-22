//
//  PaymentCreateModel.swift
//  theGymApp
//
//  Created by mac on 10/24/18.
//  Copyright © 2018 personal. All rights reserved.
//

import Foundation

class PaymentCreateModel {
    
    class PaymentPostRequest {
        static let nestedClassName = mainPayment.className + "create"
        
        struct params {
            struct UserReservationPayment {
                static let structName = "UserReservationPayment"
                static let Fk_PaymentOption = "Fk_PaymentOption"
                static let Fk_Reservation = "Fk_Reservation"
            }
            struct UserPaymentHistory {
                static let structName = "UserPaymentHistory"
                static let Fk_PaymentMethod = "Fk_PaymentMethod"
                static let Paid = "Paid"
            }
            struct UserCreditTransaction {
                static let structName = "UserCreditTransaction"
                static let Fk_UserCredit = "Fk_UserCredit"
            }
        }
        
    } // END OF PAYMENT POST REQUEST CLASS
    
    class PaymentGetRequest {
        static let nestedClassName = mainPayment.className + "create"
        
        struct returnData {

            struct PaymentOption {
                static let structName = "PaymentOption"
                static let Id = "Id"
                static let Name = "Name"
            }
            
            struct PaymentMethod { // dictionary.PaymentMethod.structName
                static let structName = "PaymentMethod"
                static let Id = "Id"
                static let Name = "Name"
            }
            
            struct UserCredit {
                static let structName = "UserCredit"
                static let PinMask = "PinMask"
                static let PaymentToken = "PaymentToken"
                struct CreditType {
                    static let structName = "CreditType"
                    static let Id = "Id"
                    static let Name = "Name"
                }
            }
            
        }
        struct params {
            static let Fk_User = "Fk_User"
        }
        
    } // END OF THE PAYMENT GET REQUEST CLASS 
    
    
}

