//
//  traineeGiftsTableViewCell.swift
//  trainee
//
//  Created by rocky on 11/29/18.
//  Copyright © 2018 personal. All rights reserved.
//

import UIKit

class traineeGiftsTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var count: UILabel!
    @IBOutlet weak var desc: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.masksToBounds = true
        layer.cornerRadius = 8
        desc.sizeToFit()
        titleLabel.sizeToFit()
    }
    
    var closure: ( () -> () )?
    
    @IBAction func claimClicked(_ sender: UIButton) {
        closure?()
    }
    
}
