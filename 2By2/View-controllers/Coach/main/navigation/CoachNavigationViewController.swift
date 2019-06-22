//
//  CoachNavigationViewController.swift
//  2By2
//
//  Created by rocky on 3/2/1440 AH.
//  Copyright © 1440 AH personal. All rights reserved.
//

import UIKit

class CoachNavigationViewController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.barTintColor = UIColor(rgb: 0xA32F1C)
    }
    
}
