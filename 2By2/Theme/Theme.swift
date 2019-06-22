//
//  Theme.swift
//  2By2
//
//  Created by rocky on 11/15/18.
//  Copyright © 2018 personal. All rights reserved.
//

import UIKit

class Theme {
    
    static let color: Int = 0xA91915
    
    // BOLD FONT
    class func FontBold(size: CGFloat) -> UIFont {
        return UIFont(name: "NexaBold", size: size)!
    }
    // LIGHT FONT
    class func FontLight(size: CGFloat) -> UIFont {
        return UIFont(name: "NexaLight", size: size)!
    }
    
    class func setColor() -> UIColor {
        return UIColor(rgb: Theme.color)
    }
    
    class func bmiOver() -> UIColor {
        return UIColor(rgb: 0xcd6000)
    }
    
    class func bmiNormal() -> UIColor {
        return UIColor(rgb: 0x266f07)
    }
    
    class func bmiUnder() -> UIColor {
        return UIColor(rgb: 0xe1a400)
    }
    
    class func bmiObese() -> UIColor {
        return UIColor(rgb: 0xa61000)
    }
    
}
