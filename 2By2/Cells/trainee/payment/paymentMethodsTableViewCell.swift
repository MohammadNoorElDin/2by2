//
//  paymentMethodsTableViewCell.swift
//  trainee
//
//  Created by rocky on 12/23/18.
//  Copyright © 2018 personal. All rights reserved.
//

import UIKit

class paymentMethodsTableViewCell: UITableViewCell {

    @IBOutlet weak var radioButton: UIButton!
    @IBOutlet weak var visaImage: UIImageView!
    @IBOutlet weak var cardNumber: UILabel!
    
    var closure: (()->())?
    var delete: (()->())?
    
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
    
    @IBAction func creditRadioBtnClicked(_ sender: UIButton){
        closure?()
    }
    
    @IBAction func deleteRadioBtnClicked(_ sender: UIButton){
        delete?()
    }
    
}
