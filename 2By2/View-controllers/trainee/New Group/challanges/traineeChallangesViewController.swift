//
//  traineeChallangesViewController.swift
//  trainee
//
//  Created by rocky on 11/29/18.
//  Copyright © 2018 personal. All rights reserved.
//

import UIKit
import SwiftyJSON

class traineeChallangesViewController: UIViewController {

    @IBOutlet weak var challangesTV: UITableView!
    @IBOutlet weak var onGoingBtn: UIButton!
    @IBOutlet weak var pastBtn: UIButton!
    
    let nib_identifier: String = "traineeChallangesTableViewCell"
    let nib_identifier_sperator = "separatorCellTableViewCell"
    
    var pastChallanges = [JSON]()
    var onGoingChallanges = [JSON]()
    
    var selectedButton : Int = 0 // 0 -> ongoing , 1 -> past
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerTable(tableView: challangesTV, nib_identifier: nib_identifier)
        registerTable(tableView: challangesTV, nib_identifier: nib_identifier_sperator)
        configCell()

    }
    @IBAction func openSideMenu(_ sender: Any) {
        self.sideMenuController?.revealMenu()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        
        
        UserChallangesModel.UserGetChallangesRequest(object: self) { (challanges, error) in
            if error == true {
                // ERROR HAPPENS
                Alerts.DisplayActionSheetAlert(title: "", message: "No Gifts", object: self, actionType: .default)
                
                return
            }else {
                if let Data = challanges {
                    if let challanges = Data["Data"].array {
                        self.pastChallanges.removeAll()
                        self.onGoingChallanges.removeAll()
                        challanges.forEach({ (challange) in
                            if let dic = challange.dictionary {
                                if let state = dic["Fk_ChallengeState"]?.int , state == 1 { // on going
                                    self.onGoingChallanges.append(challange)
                                } else {
                                    self.pastChallanges.append(challange)
                                }
                            }
                        })
                        self.challangesTV.reloadData()
                    }
                }
            }
            
        }
        
    }
    
    func configCell() {
        challangesTV.separatorInset = .zero
        challangesTV.contentInset = .zero
        challangesTV.allowsSelection = false
        challangesTV.tableFooterView = UIView()
    }
    
    @IBAction func pastClicked(_ sender: UIButton) {
        if selectedButton == 0 /* was ongoing */ {
            let swapBack = pastBtn.backgroundColor
            let swapColor = pastBtn.titleLabel?.textColor
            pastBtn.backgroundColor = onGoingBtn.backgroundColor
            pastBtn.setTitleColor(.white, for: .normal)
            onGoingBtn.backgroundColor = swapBack
            onGoingBtn.setTitleColor(swapColor, for: .normal)
            self.selectedButton = 1
            self.viewDidAppear(true)
        }
    }
    
    @IBAction func onGoingClicked(_ sender: UIButton) {
        
        if selectedButton == 1 /* was ongoing */ {
            let swapBack = onGoingBtn.backgroundColor
            let swapColor = onGoingBtn.titleLabel?.textColor
            onGoingBtn.backgroundColor = pastBtn.backgroundColor
            onGoingBtn.setTitleColor(pastBtn.titleLabel?.textColor, for: .normal)
            pastBtn.backgroundColor = swapBack
            pastBtn.setTitleColor(swapColor, for: .normal)
            self.selectedButton = 0
            self.viewDidAppear(true)
        }
        
    }
}

extension traineeChallangesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if selectedButton == 0 {
            return onGoingChallanges.count * 2
        }
        return pastChallanges.count * 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row % 2 == 0 {
            
             let num = indexPath.row / 2
            
            let cell = tableView.dequeueReusableCell(withIdentifier: nib_identifier, for: indexPath) as! traineeChallangesTableViewCell
            
            if selectedButton == 0 { // on going
                if let challange = onGoingChallanges[num].dictionary {
                    if let ranking = challange["Ranking"]?.int {
                        cell.rankingLabel.text = String(ranking)
                    }
                    cell.statusLabel.text = "Ongoing"
                }
            }else { // past
                if let challange = pastChallanges[num].dictionary {
                    if let ranking = challange["Ranking"]?.int {
                        cell.rankingLabel.text = String(ranking)
                    }
                    cell.statusLabel.text = "Past"
                }
            }
            
            cell.layer.masksToBounds = true
            cell.layer.cornerRadius = 8
            
            return cell
        }else {
            let cell = tableView.dequeueReusableCell(withIdentifier: nib_identifier_sperator, for: indexPath) as! separatorCellTableViewCell
            return cell
        }
    }
    
}

extension traineeChallangesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row % 2 == 0 {
            return 80
        }
        return 10
    }
}
