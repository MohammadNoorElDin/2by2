//
//  paymentHistoryTableViewCell.swift
//  trainee
//
//  Created by rocky on 11/30/18.
//  Copyright © 2018 personal. All rights reserved.
//

import UIKit

class paymentHistoryTableViewCell: UITableViewCell {

    @IBOutlet weak var packageLabel: UILabel!
    @IBOutlet weak var paidLabel: UILabel!
    @IBOutlet weak var outStandingLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var methodLabel: UILabel!
    @IBOutlet weak var backBtnView: UIView!

    var closure: (()->())?
    
    func configCell(package: String, paid: String, outStanding: Int, date: String, method: String) {
        self.packageLabel.text = package
        self.dateLabel.text = date
        self.methodLabel.text = method
        self.outStandingLabel.text = String(outStanding)
        self.paidLabel.text = paid
        
        if outStanding == 0 {
            self.backBtnView.isHidden = true
        }else {
            self.backBtnView.isHidden = false 
        }
        layer.cornerRadius = 8
        layer.masksToBounds = true
    }
    
    @IBAction func paymentClicked(_ sender: UIButton) {
        closure?()
    }
    
}

