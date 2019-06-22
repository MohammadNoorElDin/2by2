//
//  CustomDesignableImage.swift
//  2By2
//
//  Created by rocky on 12/1/18.
//  Copyright © 2018 personal. All rights reserved.
//

import UIKit

@IBDesignable class customDesignableIMage: UIImageView {
    
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
    
}

@IBDesignable class customDesignableUICollectionView: UICollectionView {
    
    @IBInspectable var cornerRaduis : CGFloat = 0.0 {
        didSet {
            self.layer.cornerRadius = cornerRaduis
        }
    }
    
}
