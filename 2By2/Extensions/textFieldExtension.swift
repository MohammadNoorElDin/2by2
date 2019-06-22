//
//  textFieldExtension.swift
//  2By2
//
//  Created by rocky on 1/15/19.
//  Copyright © 2019 personal. All rights reserved.
//

import UIKit

extension UITextField {
    
    func displayPassword() {
        if self.isSecureTextEntry == false {
            self.isSecureTextEntry = true
        }else {
            self.isSecureTextEntry = false
        }
    }
    
}
