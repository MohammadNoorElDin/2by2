//
//  aboutCoachViewController.swift
//  2By2
//
//  Created by rocky on 3/2/1440 AH.
//  Copyright © 1440 AH personal. All rights reserved.
//

import UIKit
import SideMenuSwift

class aboutCoachViewController: UIViewController {

    @IBOutlet weak var helpIcon: UIImageView!
    @IBOutlet weak var whatsappIcon: UIImageView!
    @IBOutlet weak var browseIcon: UIImageView!
    @IBOutlet weak var emailIcon: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGestureRecognizer1 = UITapGestureRecognizer(target: self, action: #selector(imageTappedHelp(tapGestureRecognizer:)))
        helpIcon.isUserInteractionEnabled = true
        helpIcon.addGestureRecognizer(tapGestureRecognizer1)
        
        let tapGestureRecognizer2 = UITapGestureRecognizer(target: self, action: #selector(imageTappedBrowse(tapGestureRecognizer:)))
        browseIcon.isUserInteractionEnabled = true
        browseIcon.addGestureRecognizer(tapGestureRecognizer2)
        
        let tapGestureRecognizer3 = UITapGestureRecognizer(target: self, action: #selector(imageTappedEmail(tapGestureRecognizer:)))
        emailIcon.isUserInteractionEnabled = true
        emailIcon.addGestureRecognizer(tapGestureRecognizer3)
        
        let tapGestureRecognizer4 = UITapGestureRecognizer(target: self, action: #selector(whatsappIconTapped(tapGestureRecognizer:)))
        whatsappIcon.isUserInteractionEnabled = true
        whatsappIcon.addGestureRecognizer(tapGestureRecognizer4)
        
        
        whatsappIcon.setImageColor(color: UIColor(rgb: Theme.color))
        helpIcon.setImageColor(color: UIColor(rgb: Theme.color))
        browseIcon.setImageColor(color: UIColor(rgb: Theme.color))
        emailIcon.setImageColor(color: UIColor(rgb: Theme.color))
        
        browseIcon.isHidden = true
        
    }
    
    @objc func whatsappIconTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
     
        ClickTo.openwhatsapp(phone: "01201146214")
        
    }
    
    @objc func imageTappedHelp(tapGestureRecognizer: UITapGestureRecognizer)
    {
        ClickTo.Call(number: "01201146214")
    }
    
    @objc func imageTappedBrowse(tapGestureRecognizer: UITapGestureRecognizer)
    {
        ClickTo.OpenBrowser(link: "https://www.2by2club.com/")
    }
    
    @objc func imageTappedEmail(tapGestureRecognizer: UITapGestureRecognizer)
    {
        ClickTo.sendEmail(to: "Info@2by2club.com")
    }
    
    @IBAction func openSideMenu(_ sender: UIBarButtonItem) {
        self.sideMenuController?.revealMenu()
    }
    

}
