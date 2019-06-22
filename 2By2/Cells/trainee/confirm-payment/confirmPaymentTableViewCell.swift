//
//  confirmPaymentTableViewCell.swift
//  trainee
//
//  Created by rocky on 1/17/19.
//  Copyright © 2019 personal. All rights reserved.
//

import UIKit

class confirmPaymentTableViewCell: UITableViewCell {

    @IBOutlet weak var radioButton: UIButton!
    @IBOutlet weak var visaImage: UIImageView!
    @IBOutlet weak var cardNumber: UILabel!
    
    var closure: (()->())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let colorView = UIView()
        colorView.backgroundColor = UIColor.clear
        self.selectedBackgroundView = colorView
        
    }
    
    func configCell(radio: String, visa: String, card: String) {
        self.radioButton.setImage(UIImage(named: radio), for: .normal) // radio-off-button
        self.visaImage.image = UIImage(named: visa) // master_card
        self.cardNumber.text = card
    }
    
    @IBAction func closureRadioBtnClicked(_ sender: UIButton){
        closure?()
    }
    
}

