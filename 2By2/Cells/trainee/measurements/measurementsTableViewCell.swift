//
//  measurementsTableViewCell.swift
//  trainee
//
//  Created by rocky on 11/23/18.
//  Copyright © 2018 personal. All rights reserved.
//

import UIKit

class measurementsTableViewCell: UITableViewCell {

    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var musclesLabel: UILabel!    
    @IBOutlet weak var FatLabel: UILabel!
    
    var closure: (()->())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.masksToBounds = true
        layer.cornerRadius = 8
    }
    
    @IBAction func measurement(_ sender: UIButton) {
        closure?()
    }
    
}
