//
//  customDesignableView.swift
//  2By2
//
//  Created by rocky on 11/13/18.
//  Copyright © 2018 personal. All rights reserved.
//

import UIKit

@IBDesignable class customDesignableView: UIView {

    @IBInspectable var borderWidth: CGFloat = 0.0 {
        didSet {
            self.layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat = 0.0 {
        didSet {
            self.layer.cornerRadius = cornerRadius
        }
    }
    
    @IBInspectable var borderColor: UIColor = .clear {
        didSet {
            self.layer.borderColor = borderColor.cgColor
        }
    }
    

    /*
    @IBInspectable var removeborderBottom: CGFloat = 0.0 {
        didSet {
            let border = CALayer()
            let width = CGFloat(borderBottom)
            border.borderColor = UIColor.darkGray.cgColor
            border.frame = CGRect(x: 0, y: self.frame.size.height - width, width: self.frame.size.width, height: borderBottom)
            border.borderWidth = width
            self.layer.addSublayer(border)
            self.layer.masksToBounds = true
        }
    }
 */
    
    @IBInspectable var shadowSize: CGFloat = 0.0 {
        didSet {
            
            self.layer.shadowOffset = CGSize(width: shadowSize, height: shadowSize)
            self.layer.shadowOpacity = 0.5
            self.layer.shadowRadius = 2.0
            self.layer.masksToBounds = false
        }
    }
    
}
