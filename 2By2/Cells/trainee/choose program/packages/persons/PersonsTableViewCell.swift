//
//  PersonsTableViewCell.swift
//  trainee
//
//  Created by Kamal on 12/10/18.
//  Copyright © 2018 personal. All rights reserved.
//

import UIKit

class PersonsTableViewCell: UITableViewCell {

    @IBOutlet weak var leftBtn: UIButton!
    @IBOutlet weak var rightBtn: UIButton!
    @IBOutlet weak var leftCounter: UIButton!
    @IBOutlet weak var rightCounter: UIButton!
    @IBOutlet weak var leftLabel: UILabel!
    @IBOutlet weak var rightLabel: UILabel!
    
    var closure: (()->())?
    var person: (()->())?
    
    @IBAction func choosenOpetion(_ sender: UIButton) { person?() }
    
    @IBAction func firtsList(_ sender: UIButton) { closure?() }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor.clear
    }
    
}
