//
//  LeftChooseProgramTableViewCell.swift
//  trainee
//
//  Created by Kamal on 12/8/18.
//  Copyright © 2018 personal. All rights reserved.
//

import UIKit

class LeftChooseProgramTableViewCell: UITableViewCell {


    @IBOutlet weak var leftImage: customDesignableIMage!
    @IBOutlet weak var first: UILabel!
    @IBOutlet weak var title: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.first.font = Theme.FontLight(size: 16)
        self.title.font = Theme.FontBold(size: 25)
        self.backgroundColor = .clear
        
        let colorView = UIView() 
        colorView.backgroundColor = UIColor.clear
        self.selectedBackgroundView = colorView
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state .
    }
    
}
