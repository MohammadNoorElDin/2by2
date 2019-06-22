//
//  locationsTableViewCell.swift
//  2By2
//
//  Created by mac on 11/1/18.
//  Copyright © 2018 personal. All rights reserved.
//

import UIKit

class locationsTableViewCell: UITableViewCell {

    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var rightButton: UIButton!
    
    static var locations = [Int:Int]()
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.backgroundColor = UIColor.clear
    }
    
    // left button text
    func configCell(lbLocation: LocationsModel?, rbLocation: LocationsModel?) {
        
        if lbLocation != nil {
            leftButton.isHidden = false
            leftButton.setTitle("  \(lbLocation?.name ?? "")", for: .normal)
            leftButton.tag = (lbLocation?.id)!
            if lbLocation?.selected == true {
                toggleImage(btn: leftButton, name: "check-box")
                locationsTableViewCell.locations[leftButton.tag] = leftButton.tag
            }else {
                toggleImage(btn: leftButton, name: "un-check-box")
                locationsTableViewCell.locations[leftButton.tag] = leftButton.tag
            }
        }
        
        if rbLocation != nil {
            rightButton.isHidden = false
            rightButton.setTitle("  \(rbLocation?.name ?? "")", for: .normal)
            rightButton.tag = (rbLocation?.id)!
            if rbLocation?.selected == true {
                toggleImage(btn: rightButton, name: "check-box")
                locationsTableViewCell.locations[rightButton.tag] = rightButton.tag
            }else {
                toggleImage(btn: rightButton, name: "un-check-box")
                locationsTableViewCell.locations[rightButton.tag] = rightButton.tag
            }
        }
    }
    
    @IBAction func checked(_ sender: UIButton){
        
        if sender.currentImage == UIImage(named: "check-box") {
            toggleImage(btn: sender, name: "un-check-box")
            locationsTableViewCell.locations.removeValue(forKey: sender.tag)
        }else {
            toggleImage(btn: sender, name: "check-box")
            locationsTableViewCell.locations[sender.tag] = sender.tag
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
