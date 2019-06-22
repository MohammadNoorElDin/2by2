//
//  workoutBuddyPOPUPViewController.swift
//  2By2
//
//  Created by rocky on 12/15/18.
//  Copyright © 2018 personal. All rights reserved.
//

import UIKit

class workoutBuddyPOPUPViewController: UIViewController {

    @IBOutlet weak var codeTF: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let tapGestureRecognizer1 = UITapGestureRecognizer(target: self, action: #selector(viewTapped(tapGestureRecognizer:)))
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(tapGestureRecognizer1)
    }
    
    @objc func viewTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func confirmClicked(_sender: UIButton) {
        guard let code = codeTF.text, !code.isEmpty else {
            Alerts.DisplayDefaultAlert(title: "", message: "Empty Code", object: self, actionType: .default)
            return
        }
        
        
        let params = [
            ReservationGetReservationsModel.AddUserToReservation.params.code: code,
            ReservationGetReservationsModel.AddUserToReservation.params.Fk_User: UserDataUsedThroughTheApp.userId
        ] as [String : Any]
        
        ReservationGetReservationsModel.AddUserToReservation.sendCodeRequest(object: self, params: params) { (response, error) in
            if error == false {
                print("DONE  !!!!!!!")
                // open upcoming reservation 
            }
            
        }
        
    }

}
