//
//  CoachMySessionsTableViewCell.swift
//  2By2
//
//  Created by rocky on 11/16/18.
//  Copyright © 2018 personal. All rights reserved.
//

import UIKit

class CoachMySessionsTableViewCell: UITableViewCell {

    @IBOutlet weak var coachName: UILabel!
    @IBOutlet weak var packageName: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var callImage: UIImageView!
    @IBOutlet weak var onTheWayBtn: CustomDesignableButton!
    @IBOutlet weak var startBtn: CustomDesignableButton!
    @IBOutlet weak var completedBtn: CustomDesignableButton!
    
    var call     : (() -> ())?
    var start    : (() -> ())?
    var completed: (() -> ())?
    var onTheWay : (() -> ())?
    var location : (() -> ())?
    
    @IBAction func callClicked(_ sender: UIButton) {
        call?()
    }
    
    @IBAction func starrClicked(_ sender: UIButton) {
        start?()
    }
    
    @IBAction func completedClicked(_ sender: UIButton) {
        completed?()
    }
    
    @IBAction func onTheWayClicked(_ sender: UIButton) {
        onTheWay?()
    }
    
    @IBAction func locationClicked(_ sender: UIButton) {
        location?()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // self.callImage.setImageColor(color: Theme.setColor())
        layer.cornerRadius = 8
        layer.masksToBounds = true
        self.backgroundColor = UIColor(rgb: 0xF7F7F7).withAlphaComponent(0.5)
    }
    
    func configCell(name: String, packageName: String, date: String, time: String, hour: Int, state: Int) {
        
        self.date.text = date
        self.coachName.text = name
        self.packageName.text = packageName
        self.time.text = time
        
        let today = Generate.formattingDate(date: Date(), format: "dd/MM/yyyy")
        let currentHour = Calendar.current.component(.hour, from: Date())
        
        self.onTheWayBtn.isUserInteractionEnabled = false
        self.startBtn.isUserInteractionEnabled = false
        self.completedBtn.isUserInteractionEnabled = false
        self.onTheWayBtn.backgroundColor = .lightGray
        self.startBtn.backgroundColor = .lightGray
        self.completedBtn.backgroundColor = .lightGray
        self.onTheWayBtn.setTitleColor(.black, for: .normal)
        self.startBtn.setTitleColor(.black, for: .normal)
        self.completedBtn.setTitleColor(.black, for: .normal)
        
        if state == 7 {
            self.startBtn.isUserInteractionEnabled = true
            self.onTheWayBtn.backgroundColor = Theme.setColor()
            self.onTheWayBtn.setTitleColor(.white, for: .normal)
            self.startBtn.backgroundColor = .white
            self.startBtn.setTitleColor(Theme.setColor(), for: .normal)
        } else if state == 6 {
            self.completedBtn.isUserInteractionEnabled = true
            self.completedBtn.backgroundColor = .white
            self.completedBtn.setTitleColor(Theme.setColor(), for: .normal)
            self.startBtn.backgroundColor = Theme.setColor()
            self.startBtn.setTitleColor(.white, for: .normal)
        } else if date == today {
            if ( hour - 1 ) == currentHour || hour == currentHour {
                self.onTheWayBtn.backgroundColor = .white
                self.onTheWayBtn.setTitleColor(Theme.setColor(), for: .normal)
                self.onTheWayBtn.isUserInteractionEnabled = true
            }
        }
        
    }

    
}
