//
//  fourthOnboardingViewController.swift
//  trainee
//
//  Created by rocky on 12/25/18.
//  Copyright © 2018 personal. All rights reserved.
//

import UIKit

class fourthOnboardingViewController: UIViewController {

    @IBOutlet weak var ImageView: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        #if trainee
        #else
            self.ImageView.image = UIImage(named: "coach4")
        #endif

    }
    
    @IBAction func getStarted( _ sender: UIButton) {
        
        #if trainee
            PersistentStructure.addKey(key: "tutorialStatusForUsers", value: "0") // display again
            present(MoveToStoryBoard.moveTo(sb: MoveToStoryBoard.LaunchScreen), animated: true, completion: nil)
        #else
            PersistentStructure.addKey(key: "tutorialStatusForCoaches", value: "0") // display again
            present(MoveToStoryBoard.moveTo(sb: MoveToStoryBoard.LaunchScreen), animated: true, completion: nil) 
        #endif
    }
    
}

