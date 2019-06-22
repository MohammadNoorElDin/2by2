//
//  firstOnboardingViewController.swift
//  trainee
//
//  Created by rocky on 12/25/18.
//  Copyright © 2018 personal. All rights reserved.
//

import UIKit

class firstOnboardingViewController: UIViewController {

    @IBOutlet weak var ImageView: UIImageView!
    
    var pageIndex: Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let current = view.tag
        
        #if trainee
        #else
            self.ImageView.image = UIImage(named: "coach\(current)")
        #endif
        
    }
    
    override func viewDidAppear(_ animated: Bool) {}
    
    @IBAction func skipClicked( _ sender: UIButton) {
        #if trainee
            PersistentStructure.addKey(key: "tutorialStatusForUsers", value: "0") // display again
            present(MoveToStoryBoard.moveTo(sb: MoveToStoryBoard.trainee_auth), animated: true, completion: nil)
        #else
            PersistentStructure.addKey(key: "tutorialStatusForCoaches", value: "0") // display again
            present(MoveToStoryBoard.moveTo(sb: MoveToStoryBoard.LaunchScreen), animated: true, completion: nil)
        #endif
    }
    
}
