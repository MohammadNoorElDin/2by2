//
//  customDesignableCollectionView.swift
//  2By2
//
//  Created by rocky on 11/13/18.
//  Copyright © 2018 personal. All rights reserved.
//

import UIKit

@IBDesignable class customDesignableCollectionView: UICollectionView {

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
