//
//  CoachMyWalletViewControllerExt.swift
//  2By2
//
//  Created by rocky on 11/13/18.
//  Copyright © 2018 personal. All rights reserved.
//

import UIKit

extension CoachMyWalletViewController {

    func fetchWallet() {
        let params = [
            CoachGetWalletModel.Params.Fk_Coach: CoachDataUsedThroughTheApp.coachId,
        ]
        
        CoachGetWalletModel.CoachGetWallet(object: self, params: params) { (response, status) in
     
            if status == false {
                self.TotalCredit.text = "\(response["TotalCredit"]?.int ?? 0) L.E"
                self.TotalPending.text = "\(response["TotalPending"]?.int ?? 0) L.E"
                self.SessionsCount.text = "\(response["SessionsCount"]?.int ?? 0)"
                self.DueDate.text = response["DueDate"]?.string ?? ""
                
                if let arr = response["ReservationWallets"]?.array {
                    self.coachWalletResponse = arr
                    self.walletTV.reloadData()
                }
                
            }
            
            
        }
        
    }
    
}
