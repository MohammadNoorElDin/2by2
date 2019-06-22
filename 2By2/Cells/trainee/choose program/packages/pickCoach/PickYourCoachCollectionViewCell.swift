//
//  PickYourCoachCollectionViewCell.swift
//  trainee
//
//  Created by Kamal on 12/12/18.
//  Copyright © 2018 personal. All rights reserved.
//

import UIKit

class PickYourCoachCollectionViewCell: UICollectionViewCell {
    
    var closure: (()->())?
    
    @IBOutlet weak var coachbutton: CustomDesignableButton!
    @IBOutlet weak var starLabel: UILabel!
    @IBOutlet weak var starImage: UIImageView!
    @IBOutlet weak var coachNameButton: CustomDesignableButton!
    
    @IBAction func imageTapped(_ sender: UIButton) {
        closure?()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.starImage.setImageColor(color: UIColor(rgb: Theme.color))
    }
    
}

class CoachSliderCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var coachImageSlider: customDesignableIMage!
    @IBOutlet weak var coachName: UILabel!
    @IBOutlet weak var aboutCoach: UILabel!
    @IBOutlet weak var starImage: UIImageView!
    @IBOutlet weak var starNumber: UILabel!
    var closure: (()->())?
    override func awakeFromNib() {
        super.awakeFromNib()
        self.starImage.setImageColor(color: UIColor(rgb: Theme.color))
    }
    @IBAction func pickTapped(_ sender: UIButton) {
        closure?()
    }
}
