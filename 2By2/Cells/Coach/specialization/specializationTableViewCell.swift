//
//  specializationTableViewCell.swift
//  2By2
//
//  Created by mac on 10/30/18.
//  Copyright © 2018 personal. All rights reserved.
//

import UIKit

class specializationTableViewCell: UITableViewCell {
    
    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var rightButton: UIButton!
    
    static var specializations = [Int:Int]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.backgroundColor = UIColor.clear
    }
    
    // left button text
    func configCell(lbSpecialization: SpecializationModel?, rbSpecialization: SpecializationModel?) {
        if lbSpecialization != nil {
            leftButton.isHidden = false
            leftButton.setTitle(" \(lbSpecialization?.name ?? "")", for: .normal)
            leftButton.tag = (lbSpecialization?.id)!
            if lbSpecialization?.selected == true {
                toggleImage(btn: leftButton, name: "check-box")
                specializationTableViewCell.specializations[leftButton.tag] = leftButton.tag
            }else {
                toggleImage(btn: leftButton, name: "un-check-box")
                specializationTableViewCell.specializations[leftButton.tag] = leftButton.tag
            }
        }
        if rbSpecialization != nil {
            rightButton.isHidden = false
            rightButton.setTitle(" \(rbSpecialization?.name ?? "")", for: .normal)
            rightButton.tag = (rbSpecialization?.id)!
            if rbSpecialization?.selected == true {
                toggleImage(btn: rightButton, name: "check-box")
                specializationTableViewCell.specializations[rightButton.tag] = rightButton.tag
            }else {
                toggleImage(btn: rightButton, name: "un-check-box")
                specializationTableViewCell.specializations[rightButton.tag] = rightButton.tag
            }
        }
    }
    
    @IBAction func checked(_ sender: UIButton){
        
        if sender.currentImage == UIImage(named: "check-box") {
            toggleImage(btn: sender, name: "un-check-box")
            specializationTableViewCell.specializations.removeValue(forKey: sender.tag)
        }else {
            toggleImage(btn: sender, name: "check-box")
            specializationTableViewCell.specializations[sender.tag] = sender.tag
        }
        
    }
    
    func toggleImage(btn: UIButton, name: String) {
        if btn == leftButton {
            leftButton.setImage(UIImage(named: name), for: .normal)
        }else if btn == rightButton {
            rightButton.setImage(UIImage(named: name), for: .normal)
        }
    }
    
}
