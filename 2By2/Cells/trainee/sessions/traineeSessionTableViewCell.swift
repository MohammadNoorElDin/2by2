//
//  traineeSessionTableViewCell.swift
//  trainee
//
//  Created by rocky on 11/23/18.
//  Copyright © 2018 personal. All rights reserved.
//

import UIKit

class traineeSessionTableViewCell: UITableViewCell {
    
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var packageName: UILabel!
    @IBOutlet weak var material: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var desc: UILabel!
    @IBOutlet weak var profileIMage: UIImageView!
    @IBOutlet weak var modifyBtn: UIButton!
    @IBOutlet weak var trackBtn: UIButton!
    
    
    var call: (()->())?
    var modify: (()->())?
    var track: (()->())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.masksToBounds = true
        layer.cornerRadius = 8
        backgroundColor = UIColor(rgb: 0xF7F7F7).withAlphaComponent(0.7)
        self.desc.isHidden = true 
    }
    
    @IBAction func callClicked(_ sender: UIButton) {
        call?()
    }
    @IBAction func modifyClicked(_ sender: UIButton) {
        modify?()
    }
    @IBAction func trackClicked(_ sender: UIButton) {
        track?()
    }
    
    func configCell(name: String, material: String, package: String, date: String, state: Int, desc: String) {
        
        self.userName.text = name
        self.material.text = material
        self.packageName.text = package
        self.date.text = date
        
        self.desc.text = desc
        
        let today = Date().millisecondsSince1970
        let leng = date.count /*- 3*/
        let sessionDate = Generate.convertStrToDateWithComponents(str: String(date.prefix(leng))).millisecondsSince1970
        
        work(btn: self.modifyBtn)
        disable(btn: self.trackBtn)
        
        if state == 7 {
            work(btn: self.trackBtn)
        }
        // 10800000
        if today > (sessionDate - 108000) {
            disable(btn: self.modifyBtn)
            
        }
        
    }
 
    func disable(btn: UIButton) {
        btn.isUserInteractionEnabled = false
        btn.backgroundColor = UIColor.lightGray
        btn.setTitleColor(.black, for: .normal)
    }
    
    func work(btn: UIButton) {
        btn.isUserInteractionEnabled = true
        btn.backgroundColor = Theme.setColor()
        btn.setTitleColor(.white, for: .normal)
    }
    
}


extension Date {
    var millisecondsSince1970:Int {
        return Int((self.timeIntervalSince1970 * 1000.0).rounded())
    }
    
    init(milliseconds:Int) {
        self = Date(timeIntervalSince1970: TimeInterval(milliseconds) / 1000)
    }
}

