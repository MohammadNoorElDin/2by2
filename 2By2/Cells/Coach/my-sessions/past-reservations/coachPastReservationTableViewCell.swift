//
//  coachPastReservationTableViewCell.swift
//  2By2
//
//  Created by rocky on 1/6/19.
//  Copyright © 2019 personal. All rights reserved.
//

import UIKit

class coachPastReservationTableViewCell: UITableViewCell {

    @IBOutlet weak var coachName: UILabel!
    @IBOutlet weak var coachDate: UILabel!
    @IBOutlet weak var coachTime: UILabel!
    @IBOutlet weak var coachDesc: UILabel!
    @IBOutlet weak var coachPackage: UILabel!
    @IBOutlet weak var coachImage: UIImageView!
    @IBOutlet weak var rateBtn: UIButton!
    @IBOutlet weak var detailsBtn: UIButton!
    var details: (()->())?
    var rate: (()->())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 6
        self.backgroundColor = UIColor(rgb: 0xF7F7F7).withAlphaComponent(0.5)
    }

    func configCell(coach: String, date: String, time: String, package: String, image: String, state: Int, desc: String) {
        self.coachName.text = coach
        self.coachPackage.text = package
        self.coachTime.text = time
        self.coachDate.text = date
        self.coachDesc.text = desc
        
        if image != "" {
            self.coachImage.findMe(url: image)
            self.coachImage.imageRadius()
        }else {
            self.coachImage.image = UIImage(named: "profile-pic-size")
        }
        if state == 8 {
            self.hideORshow(state: false)
        }else {
            self.hideORshow(state: true)
        }
    }
    
    @IBAction func rate(_ sender: UIButton) {
        rate?()
    }
    
    @IBAction func details(_ sender: UIButton) {
        details?()
    }
 
    func hideORshow(state: Bool) {
        self.rateBtn.isHidden = state
        self.detailsBtn.isHidden = state
    }

}
