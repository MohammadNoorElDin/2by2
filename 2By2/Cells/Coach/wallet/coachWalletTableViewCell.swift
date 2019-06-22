//
//  coachWalletTableViewCell.swift
//  2By2
//
//  Created by rocky on 11/14/18.
//  Copyright © 2018 personal. All rights reserved.
//

import UIKit

class coachWalletTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = 2
        layer.masksToBounds = true
        backgroundColor = UIColor(rgb: 0xF7F7F7).withAlphaComponent(0.7)
    }
    
    func configCell(name: String, date: String, amount: String, status: String){
        self.nameLabel.text = name
        self.dateLabel.text = date
        self.amountLabel.text = " \(amount)"
        self.statusLabel.text = " \(status)"
        self.nameLabel.font = Theme.FontLight(size: 14)
        self.dateLabel.font = Theme.FontLight(size: 14)
        self.amountLabel.font = Theme.FontLight(size: 14)
        self.statusLabel.font = Theme.FontLight(size: 14)
    }
    
}
