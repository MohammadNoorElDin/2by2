//
//  coachLangTableViewCell.swift
//  2By2
//
//  Created by mac on 10/30/18.
//  Copyright © 2018 personal. All rights reserved.
//

import UIKit

class coachLangTableViewCell: UITableViewCell {
    
    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var rightButton: UIButton!
    
    static var langs = [Int:Int]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.backgroundColor = UIColor.clear
    }
    
    // left button text
    func configCell(lbLang: langsModel?, rbLang: langsModel?) {
        
        if lbLang != nil {
            leftButton.isHidden = false
            leftButton.setTitle(" \(lbLang?.name ?? "")", for: .normal)
            leftButton.tag = (lbLang?.id)!
            if lbLang?.selected == true {
                toggleImage(btn: leftButton, name: "check-box")
                coachLangTableViewCell.langs[leftButton.tag] = leftButton.tag
            }else {
                toggleImage(btn: leftButton, name: "un-check-box")
                coachLangTableViewCell.langs[leftButton.tag] = leftButton.tag
            }
        }
        if rbLang != nil {
            rightButton.isHidden = false
            rightButton.setTitle(" \(rbLang?.name ?? "")", for: .normal)
            rightButton.tag = (rbLang?.id)!
            if rbLang?.selected == true {
                toggleImage(btn: rightButton, name: "check-box")
                coachLangTableViewCell.langs[rightButton.tag] = rightButton.tag
            }else {
                toggleImage(btn: rightButton, name: "un-check-box")
                coachLangTableViewCell.langs[rightButton.tag] = rightButton.tag
            }
        }
    }
    
    @IBAction func checked(_ sender: UIButton){
        
        if sender.currentImage == UIImage(named: "check-box") {
            toggleImage(btn: sender, name: "un-check-box")
            coachLangTableViewCell.langs.removeValue(forKey: sender.tag)
        }else {
            toggleImage(btn: sender, name: "check-box")  
            coachLangTableViewCell.langs[sender.tag] = sender.tag
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
