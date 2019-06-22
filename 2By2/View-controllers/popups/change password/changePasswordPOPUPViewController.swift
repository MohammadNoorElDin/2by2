//
//  changePasswordPOPUPViewController.swift
//  2By2
//
//  Created by rocky on 1/7/19.
//  Copyright © 2019 personal. All rights reserved.
//

import UIKit

class changePasswordPOPUPViewController: UIViewController {
    
    @IBOutlet weak var oldPassword: CustomDesignableTextField!
    @IBOutlet weak var newPassword: CustomDesignableTextField!
    @IBOutlet weak var conPassword: CustomDesignableTextField!
    @IBOutlet weak var rateView: customDesignableView!
    
    var password: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGestureRecognizer1 = UITapGestureRecognizer(target: self, action: #selector(viewTapped(tapGestureRecognizer:)))
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(tapGestureRecognizer1)
        
        let tapGestureRecognizer2 = UITapGestureRecognizer(target: self, action: #selector(rateViewTapped(tapGestureRecognizer:)))
        rateView.isUserInteractionEnabled = true
        rateView.addGestureRecognizer(tapGestureRecognizer2)
        
    }
    
    
    
    @objc func viewTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        if tapGestureRecognizer.view == rateView {
            return
        }
        dismiss(animated: true, completion: nil)
    }
    
    @objc func rateViewTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        return
    }
    
    
    @IBAction func changePasswordConfirmBtn(_ sender: UIButton) {
       
        guard let oldPass = self.oldPassword.text, !oldPass.isEmpty else {
            Alerts.DisplayDefaultAlert(title: "", message: Messenger.emptyPassword, object: self, actionType: .default)
            return
        }
        
        guard let newPass = self.newPassword.text, !newPass.isEmpty else {
            Alerts.DisplayDefaultAlert(title: "", message: Messenger.emptyPassword, object: self, actionType: .default)
            return
        }
        
        guard let conPass = self.conPassword.text, !conPass.isEmpty else {
            Alerts.DisplayDefaultAlert(title: "", message: Messenger.emptyPassword, object: self, actionType: .default)
            return
        }
        
        guard newPass == conPass  else {
            Alerts.DisplayDefaultAlert(title: "", message: "Confirm password is not match", object: self, actionType: .default)
            return
        }
        
        
        guard oldPass == PersistentStructure.getKey(key: PersistentStructureKeys.coachPassword) else {
            Alerts.DisplayDefaultAlert(title: "", message: "Old password is wrong", object: self, actionType: .default)
            return
        }

        self.password = newPass
        
        self.dismiss(animated: true) {
            NotificationCenter.default.post(name: .changePassword, object: self)
        }
        
    }

}
