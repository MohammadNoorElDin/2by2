//
//  coachAgendaTableViewCell.swift
//  2By2
//
//  Created by rocky on 11/17/18.
//  Copyright © 2018 personal. All rights reserved.
//

import UIKit

class coachAgendaTableViewCell: UITableViewCell {

    @IBOutlet weak var fromLabel: UILabel!
    @IBOutlet weak var toLabel: UILabel!
    var cancel: (() -> ())?
    var modify: (() -> ())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.fromLabel.textColor = Theme.setColor()
        self.toLabel.textColor = Theme.setColor()
        self.backgroundColor = UIColor(rgb: 0xF7F7F7).withAlphaComponent(0.5)
    }
    
    
    @IBAction func cancelBtn(_ sender: UIButton) {
        cancel?()
    }
    
    @IBAction func modifyBtn(_ sender: UIButton) {
        modify?()
    }
    
}
