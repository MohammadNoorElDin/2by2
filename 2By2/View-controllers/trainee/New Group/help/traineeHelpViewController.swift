//
//  traineeHelpViewController.swift
//  trainee
//
//  Created by rocky on 11/29/18.
//  Copyright © 2018 personal. All rights reserved.
//

import UIKit

class traineeHelpViewController: UIViewController {
   
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
    
    @IBAction func openSideMenu(_ sender: Any) {
        self.sideMenuController?.revealMenu()
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

}
