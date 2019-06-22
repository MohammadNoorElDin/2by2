//
//  customDesignableLabel.swift
//  2By2
//
//  Created by rocky on 11/13/18.
//  Copyright © 2018 personal. All rights reserved.
//

import UIKit

@IBDesignable class customDesignableLabel: UILabel {

    @IBInspectable var borderWidth: CGFloat = 0.0 {
        didSet {
            self.layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var borderColor: UIColor = UIColor.clear {
        didSet {
            self.layer.borderColor = borderColor.cgColor
        }
    }
    
    @IBInspectable var cornerRaduis : CGFloat = 0.0 {
        didSet {
            self.layer.cornerRadius = cornerRaduis
        }
    }
    
    @IBInspectable var fontBoldActive : CGFloat = 0.0 {
        didSet {
            self.font = UIFont(name: "NexaBold", size: fontBoldActive)
        }
    }
    
    @IBInspectable var fontLightActive : CGFloat = 0.0 {
        didSet {
            self.font = UIFont(name: "NexaLight", size: fontLightActive)
        }
    }

    
    @IBInspectable var rotate: CGFloat = 0.0 {
        didSet {
            transform = CGAffineTransform(rotationAngle: rotate)
        }
    }
    
}
