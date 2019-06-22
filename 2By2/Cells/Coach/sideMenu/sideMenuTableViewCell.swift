//
//  sideMenuTableViewCell.swift
//  2By2
//
//  Created by rocky on 11/12/18.
//  Copyright © 2018 personal. All rights reserved.
//

import UIKit

class sideMenuTableViewCell: UITableViewCell {

    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var titleIcon: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let colorView = UIView()
        colorView.backgroundColor = UIColor.clear
        self.selectedBackgroundView = colorView
        
    }
    
    func configCell(title: String, image: String) {
        self.title.text = title
        self.titleIcon.image = UIImage(named: image)
        self.title.font = Theme.FontBold(size: 15)
    }
    
}
