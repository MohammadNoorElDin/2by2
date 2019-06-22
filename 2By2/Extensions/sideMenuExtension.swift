//
//  sideMenuExtension.swift
//  2By2
//
//  Created by rocky on 1/15/19.
//  Copyright © 2019 personal. All rights reserved.
//

import UIKit
import SideMenuSwift

extension SideMenuController {
    
    func cacheViewController(withIdentifier: String, with: String) {
        self.cache(viewControllerGenerator: { self.storyboard?.instantiateViewController(withIdentifier: withIdentifier) }, with: with)
    }
    
    func customHideMenu(with name: String) {
        self.hideMenu(animated: true, completion: { (_) in
            self.setContentViewController(with: name)
        })
    }
    
}
