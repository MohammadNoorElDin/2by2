//
//  changePOPUPViewController.swift
//  2By2
//
//  Created by rocky on 1/7/19.
//  Copyright © 2019 personal. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class changePOPUPViewController: UIViewController {
    
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
        
        let credential = PhoneAuthProvider.provider().credential(
            withVerificationID: PersistentStructure.getKey(key: "verificationID")!,
            verificationCode: code)
        
        Auth.auth().signInAndRetrieveData(with: credential) { (response, error) in
            
            if let error = error as NSError? {
                Alerts.DisplayActionSheetAlertWithButtonName(title: "", message: error.localizedDescription, object: self, actionType: .default, name: "OK")
                
                return
            } else {
                
                self.dismiss(animated: true, completion: {
                  NotificationCenter.default.post(name: .changeMobile, object: self)
                })
            }
                
        }
        
    }
    
}
