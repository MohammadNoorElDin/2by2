//
//  payMyInstallmentPOPUPViewController.swift
//  2By2
//
//  Created by rocky on 1/19/19.
//  Copyright © 2019 personal. All rights reserved.
//

import UIKit

class payMyInstallmentPOPUPViewController: UIViewController {

    @IBOutlet weak var credit: UILabel!
    @IBOutlet weak var info: UILabel!
    
    var creditCard: String!
    var price: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.info.text = "Confirm to pay \(String(price)) L.E from your account:"
        self.credit.text = creditCard
        
    }

    
    @IBAction func cancel(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func confirm(_ sender: UIButton) {
        dismiss(animated: true) {
            NotificationCenter.default.post(name: .paymMYinstallment, object: self)
        }
    }
}
