//
//  ContentCollectionViewCell.swift
//  2By2
//
//  Created by rocky on 11/10/18.
//  Copyright © 2018 personal. All rights reserved.
//
import UIKit

class ContentCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var contentLabel: UIButton!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var backImage: UIImageView!
    var closure: (() -> ())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configShadowContentLabel() {
        self.contentLabel.layer.shadowOffset = CGSize(width: 1, height: 1)
        self.contentLabel.layer.shadowOpacity = 0.3
        self.contentLabel.layer.shadowRadius = 1.0
        self.contentLabel.layer.masksToBounds = false
        self.contentLabel.layer.cornerRadius = 8
        self.contentLabel.titleLabel?.font = Theme.FontLight(size: 12.5)
    }
    func setColorToDefault() {
        self.contentLabel.backgroundColor = UIColor.white
        self.contentLabel.setTitleColor(Theme.setColor(), for: .normal)
    }
    func setColorToWhite() {
        self.contentLabel.backgroundColor = Theme.setColor()
        self.contentLabel.setTitleColor(.white, for: .normal)
    }
    func setColorToBlack() {
        self.contentLabel.backgroundColor = .black
        self.contentLabel.setTitleColor(.white, for: .normal)
    }
    func configCell(content: String?, date: String?) {
        self.contentLabel.setTitle(content, for: .normal)
        self.dateLabel.text = date 
    }
    func dateLabelFunc() {
        self.contentLabel.setTitle(nil, for: .normal)
        self.dateLabel.sizeToFit()
        self.dateLabel.isHidden = true
        self.backImage.image = UIImage(named: "border-right")
    }
    func contentLabelFunc() {
        self.contentLabel.backgroundColor = UIColor.clear
        self.contentLabel.titleLabel?.textColor = UIColor.black
        self.contentLabel.titleLabel?.font = Theme.FontBold(size: 16)
        self.contentLabel.setTitleColor(.black, for: .normal)
        self.dateLabel.font = Theme.FontLight(size: 13)
        self.backImage.image = UIImage(named: "border-bottom-right")
    }
    
    @IBAction func btnClicked(_ sender: UIButton) {
        closure?()
    }
    
}

