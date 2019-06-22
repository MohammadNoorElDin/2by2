//
//  LabelExt.swift
//  2By2
//
//  Created by rocky on 11/13/18.
//  Copyright © 2018 personal. All rights reserved.
//

import UIKit

extension UILabel {
    override open func awakeFromNib() {
        super.awakeFromNib()
        changeFontName()
    }
    
    func changeFontName()
    {
        if self.font != UIFont(name: "nexaLight", size: self.font.pointSize) {
            self.font = UIFont(name: "nexaBold", size: self.font.pointSize)
            self.sizeToFit()
        }
    }
}


extension UINavigationItem {
    override open func awakeFromNib() {
        changeAppearance()
    }
    
    func changeAppearance() {
        let backItem = UIBarButtonItem()
        backItem.image = UIImage(named: "")
        self.backBarButtonItem = backItem
    }
}
