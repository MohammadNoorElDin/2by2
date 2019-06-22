//
//  sessionExperiencesTableViewCell.swift
//  2By2
//
//  Created by rocky on 1/28/19.
//  Copyright © 2019 personal. All rights reserved.
//

import UIKit

class sessionExperiencesTableViewCell: UITableViewCell {

    @IBOutlet weak var btn: UIButton!
    var closure: (()->())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = UIColor.clear
    }

    func configCell(name: String, checked: Bool, tag: Int) {
        self.btn.setTitle("  \(name)", for: .normal)
        self.btn.tag = tag
        let imageName = (checked == false) ? "new-check-box" : "new-checked-box"
        self.btn.setImage(UIImage(named: imageName), for: .normal)
    }
    
    @IBAction func checked(_ sender: UIButton) {
        closure?()
    }
}
