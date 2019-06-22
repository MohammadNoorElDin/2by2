//
//  sideMenuViewController.swift
//  2By2
//
//  Created by rocky on 11/12/18.
//  Copyright © 2018 personal. All rights reserved.
//

import UIKit
import SideMenuSwift
import SDWebImage

class sideMenuViewController: UIViewController {
    
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var coachName: UILabel!
    @IBOutlet weak var version: UILabel!
    @IBOutlet weak var sideMenuTableView: UITableView!
    
    let titles = ["Home", "Agenda", "My Sessions", "My Wallet", "Help", "Log out"]
    let icons = ["home", "agenda", "sessions", "wallet", "help", "logout"]
    let paths: [Notification.Name?] = [nil, .coachAgenda, .coachSession, .coachWallet, .coachHelp, nil]
    
    let nib_identifier = "sideMenuTableViewCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerTable(tableView: sideMenuTableView, nib_identifier: nib_identifier)
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        profileImage.isUserInteractionEnabled = true
        profileImage.addGestureRecognizer(tapGestureRecognizer)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        self.displayUserProfileInfo()
        self.sideMenuController?.cacheViewController(withIdentifier: "coachhomeView", with: "coach-home")
        self.sideMenuController?.cacheViewController(withIdentifier: "coachagendaView", with: "coach-agenda")
        self.sideMenuController?.cacheViewController(withIdentifier: "coachsessionView", with: "coach-session")
        self.sideMenuController?.cacheViewController(withIdentifier: "coachwalletView", with: "coach-wallet")
        self.sideMenuController?.cacheViewController(withIdentifier: "coachhelpView", with: "coach-help")
        self.sideMenuController?.cacheViewController(withIdentifier: "coachprofileView", with: "coach-profile")
     
        if let appVersion = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as? String
        {
           self.version.text = "version \(appVersion)"
        }
    }
    
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        self.sideMenuController?.hideMenu(animated: true, completion: { (status) in
            if status == true {
                self.sideMenuController?.setContentViewController(with: "coach-profile")
            }
        })
        
    }
    
    @IBAction func openProfile(_ sender: UIBarButtonItem) {
        self.sideMenuController?.setContentViewController(with: "coach-profile")
    }
    
    func displayUserProfileInfo() {    
        let imagePath = CoachDataUsedThroughTheApp.coachImage
        self.profileImage.findMe(url: imagePath)
        self.profileImage.imageRadius()
    
        if CoachDataUsedThroughTheApp.coachFullName.isEmpty == false {
           self.coachName.text = CoachDataUsedThroughTheApp.coachFullName
        }
    }
    
}

extension sideMenuViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: nib_identifier, for: indexPath) as! sideMenuTableViewCell
        
        cell.configCell(title: titles[indexPath.row], image: icons[indexPath.row])
        
        return cell
    }
    
}

extension sideMenuViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let num = indexPath.row
        
        // HOME
        if num == 0 {
            self.sideMenuController?.hideMenu(animated: true, completion: { (status) in
                if status == true {
                    self.sideMenuController?.setContentViewController(with: "coach-home")
                }
            })
        }
        // LOGOUT
        else if num == ( paths.count - 1 ) {
            Alerts.DisplayDefaultAlertWithActions(title: "Logout", message: "Are You Sure?", object: self, buttons: ["CANCEL" : .cancel, "OK": .default], actionType: .default) { (name) in
                if name == "OK" {
                    PersistentStructure.removeAll {
                        CoachDataUsedThroughTheApp.removeAll()
                        self.present( MoveToStoryBoard.moveTo(sb: MoveToStoryBoard.auth), animated: true, completion: nil)
                    }
                }
            }
        }
        // WALLET
        else if self.paths[num] == .coachWallet {
            self.sideMenuController?.hideMenu(animated: true, completion: { (status) in
                if status == true {
                    self.sideMenuController?.setContentViewController(with: "coach-wallet")
                }
            })
        }
            
        // HELP
        else if self.paths[num] == .coachHelp {
            self.sideMenuController?.hideMenu(animated: true, completion: { (status) in
                if status == true {
                    self.sideMenuController?.setContentViewController(with: "coach-help")
                }
            })
        }
        
         // SESSIONS
        else if self.paths[num] == .coachSession {
            self.sideMenuController?.hideMenu(animated: true, completion: { (status) in
                if status == true {
                    self.sideMenuController?.setContentViewController(with: "coach-session")
                }
            })
        }
        
        // AGENDA
        else if self.paths[num] == .coachAgenda {
            self.sideMenuController?.hideMenu(animated: true, completion: { (status) in
                if status == true {
                    self.sideMenuController?.setContentViewController(with: "coach-agenda")
                }
            })
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}
