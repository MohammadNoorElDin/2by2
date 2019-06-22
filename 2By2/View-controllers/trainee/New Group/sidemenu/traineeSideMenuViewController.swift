//
//  teaineeSideMenuViewController.swift
//  trainee
//
//  Created by rocky on 11/23/18.
//  Copyright © 2018 personal. All rights reserved.
//

import UIKit

class traineeSideMenuViewController: UIViewController {

    @IBOutlet weak var profileImage: UIButton!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var versionNumber: UILabel!
    @IBOutlet weak var sideMenuTableView: UITableView!
    
    
    let nib_identifier = "sideMenuTableViewCell"
    
    let titles = ["Home", "My Sessions", "Gifts", "Measurements", "Challanges", "Payment", "Help", "Logout"]
    let icons = ["home", "sessions", "gifts", "measurements", "challengs", "payment", "help", "logout"]
    let paths: [String] = ["trainee-home", "trainee-session", "trainee-gifts", "trainee-measurements", "trainee-challanges", "trainee-payments", "trainee-help"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerTable(tableView: sideMenuTableView, nib_identifier: nib_identifier)
        sideMenuTableView.isScrollEnabled = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.displayUserProfileInfo()
        self.sideMenuController?.cacheViewController(withIdentifier: "traineehomeView", with: "trainee-home")
        self.sideMenuController?.cacheViewController(withIdentifier: "traineegiftsView", with: "trainee-gifts")
        self.sideMenuController?.cacheViewController(withIdentifier: "traineesessionView", with: "trainee-session")
        self.sideMenuController?.cacheViewController(withIdentifier: "traineechallangesView", with: "trainee-challanges")
        self.sideMenuController?.cacheViewController(withIdentifier: "traineemeasurementsView", with: "trainee-measurements")
        self.sideMenuController?.cacheViewController(withIdentifier: "traineepaymentsView", with: "trainee-payments")
        self.sideMenuController?.cacheViewController(withIdentifier: "traineehelpView", with: "trainee-help")
        self.sideMenuController?.cacheViewController(withIdentifier: "traineeprofileView", with: "trainee-profile")
        
        if let appVersion = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as? String {
            self.versionNumber.text = "version \(appVersion)"
        }
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        self.sideMenuController?.clearCache(with: "trainee-home")
        self.sideMenuController?.clearCache(with: "trainee-gifts")
        self.sideMenuController?.clearCache(with: "trainee-session")
        self.sideMenuController?.clearCache(with: "trainee-challanges")
        self.sideMenuController?.clearCache(with: "trainee-help")
        self.sideMenuController?.clearCache(with: "trainee-measurements")
        self.sideMenuController?.clearCache(with: "trainee-profile")
        self.sideMenuController?.clearCache(with: "trainee-payments")
    }
    
    func displayUserProfileInfo() {
        if UserDataUsedThroughTheApp.userImage.isEmpty == false {
            let imagePath = UserDataUsedThroughTheApp.userImage
            self.profileImage.findMe(url: imagePath)
            self.profileImage.radiusButtonImage()
        }
        self.userName.text = UserDataUsedThroughTheApp.userFullName
    }
    
    @IBAction func profileIMageClicked(_ sender: UIButton) {
        self.sideMenuController?.customHideMenu(with: "trainee-profile")
    }
    
    
}

extension traineeSideMenuViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: nib_identifier, for: indexPath) as! sideMenuTableViewCell
        cell.configCell(title: titles[indexPath.row], image: icons[indexPath.row])
        
        return cell
    }
    
}

extension traineeSideMenuViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let num = indexPath.row
        
        // LOGOUT
        if num == ( titles.count - 1 ) {
            
            Alerts.DisplayDefaultAlertWithActions(title: "Logout", message: "Are You Sure?", object: self, buttons: ["Cancel": .cancel, "OK": .default], actionType: .default) { (name) in
                if name == "OK" {
                    PersistentStructure.removeAll {
                        UserDataUsedThroughTheApp.removeAll()
                        self.present( MoveToStoryBoard.moveTo(sb: MoveToStoryBoard.trainee_auth), animated: true, completion: nil)
                    }
                }
            }
            
        } else {
            self.sideMenuController?.customHideMenu(with: self.paths[num])
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 43.5
    }
    
}
