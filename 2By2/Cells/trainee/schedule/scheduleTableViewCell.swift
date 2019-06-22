//
//  scheduleTableViewCell.swift
//  trainee
//
//  Created by rocky on 12/20/18.
//  Copyright © 2018 personal. All rights reserved.
//

import UIKit

class scheduleTableViewCell: UITableViewCell {

    @IBOutlet weak var packageName: UILabel!
    @IBOutlet weak var avaliableSessions: UILabel!
    @IBOutlet weak var expiryDate: UILabel!
    @IBOutlet weak var coachName: UILabel!
    var closure: (()->())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.masksToBounds = true
        layer.cornerRadius = 8
        backgroundColor = UIColor(rgb: 0xF7F7F7).withAlphaComponent(0.7)
    }
    
    @IBAction func schdule(_ sender: UIButton) {
        closure?()
    }
    
    func configtable(package: String, avaliable: Int, expiry: String, coach: String) {
        self.packageName.text = package
        self.avaliableSessions.text = String(avaliable)
        self.expiryDate.text = expiry
        self.coachName.text = coach
    }
    
}
