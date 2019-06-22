//
//  UIApplicationEXt.swift
//  2By2
//
//  Created by rocky on 11/22/18.
//  Copyright © 2018 personal. All rights reserved.
//

import UIKit

extension UIApplication {
    var statusBarView: UIView? {
        if responds(to: Selector(("statusBar"))) {
            return value(forKey: "statusBar") as? UIView
        }
        return nil
    }
}
