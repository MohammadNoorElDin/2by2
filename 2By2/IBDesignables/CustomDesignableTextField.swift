//
//  CustomDesignableTextField.swift
//  2By2
//
//  Created by mac on 10/28/18.
//  Copyright © 2018 personal. All rights reserved.
//

import UIKit

@IBDesignable class CustomDesignableTextField: UITextField {
    
    @IBInspectable var borderBottom: CGFloat = 0.0 {
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
    
    @IBInspectable var placeHolderColor: UIColor = .white {
        didSet {
            self.attributedPlaceholder = NSAttributedString(string:self.placeholder != nil ? self.placeholder! : "", attributes:[NSAttributedString.Key.foregroundColor: placeHolderColor])
        }
    }
    
    
    @IBInspectable var shadowSize: CGFloat = 0.0 {
        didSet {
            self.layer.shadowOffset = CGSize(width: shadowSize, height: shadowSize)
            self.layer.shadowOpacity = 0.5
            self.layer.shadowRadius = 2.0
            self.layer.masksToBounds = false
        }
    }
 
    @IBInspectable var maxLength: Int = 0 {
        didSet{
            addTarget(self, action: #selector(fix), for: .editingChanged)
        }
    }
    
    @objc func fix(textField: UITextField) {
        let t = textField.text
        textField.text = t?.safelyLimitedTo(length: maxLength)
    }
    
}

extension String
{
    func safelyLimitedTo(length n: Int)->String {
        if (self.count <= n) {
            return self
        }
        return String( Array(self).prefix(upTo: n) )
    }
}
