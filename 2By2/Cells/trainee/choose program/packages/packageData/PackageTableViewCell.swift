//
//  PackageTableViewCell.swift
//  trainee
//
//  Created by Kamal on 12/9/18.
//  Copyright © 2018 personal. All rights reserved.
//

import UIKit

class PackageTableViewCell: UITableViewCell {

    @IBOutlet weak var dataIndex: UILabel!
    @IBOutlet weak var nameTF: CustomDesignableTextField!
    @IBOutlet weak var phoneTF: CustomDesignableTextField!


    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.backgroundColor = UIColor.clear
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    
}
