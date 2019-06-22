//
//  traineeGiftsViewController.swift
//  trainee
//
//  Created by rocky on 11/29/18.
//  Copyright © 2018 personal. All rights reserved.
//

import UIKit
import SwiftyJSON

class traineeGiftsViewController: UIViewController {

    @IBOutlet weak var giftsTV: UITableView!
    
    let nib_identifier = "traineeGiftsTableViewCell"
    let nib_identifier_sperator = "separatorCellTableViewCell"
    
    var gifts = [JSON]()
    var bookingModel: BookingDataModel!
    var observer: NSObjectProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerTable(tableView: giftsTV, nib_identifier: nib_identifier)
        registerTable(tableView: giftsTV, nib_identifier: nib_identifier_sperator)
        configCell()
        self.bookingModel = BookingDataModel()
    }
    
    func configCell() {
        giftsTV.separatorInset = .zero
        giftsTV.contentInset = .zero
        giftsTV.allowsSelection = false
        giftsTV.tableFooterView = UIView()
    }
    
    @IBAction func openSideMenu(_ sender: Any) {
        self.sideMenuController?.revealMenu()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        UserGiftsModel.GetGiftsModel.UserGetGiftsRequest(object: self) { (gifts, error) in
            if error == true {
                // ERROR HAPPENS
                Alerts.DisplayActionSheetAlert(title: "", message: "No Gifts", object: self, actionType: .default)
                
                return
            }else {
                if let Data = gifts {
                    if let gifts = Data["Data"].array {
                        self.gifts.removeAll()
                        self.gifts = gifts
                        self.giftsTV.reloadData()
                    }
                }
            }
            
        }
        
        self.observer = addCustomObserver(name: .inbody, completion: { (notification) in
            if let vc = notification.object as? inbodyPOPUPViewController {
                self.viewDidAppear(true)
            }
        })
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        if let observer = observer {
            NotificationCenter.default.removeObserver(observer)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == segueIdentifier.toTraineeMapSegue {
            if #available(iOS 11.0, *) {
                if let dest = segue.destination as? gmapWithAutoCompleteSearchViewController {
                    dest.bookingModel = self.bookingModel
                }
            } else {
                // Fallback on earlier versions
            }
        }
    }
    
}

extension traineeGiftsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.gifts.count * 2 
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row % 2 == 0 {
            
             let num = indexPath.row / 2
            
            let cell = tableView.dequeueReusableCell(withIdentifier: nib_identifier, for: indexPath) as! traineeGiftsTableViewCell
            
            if let gift = gifts[num].dictionary {
                if let title = gift["Title"]?.string {
                    cell.titleLabel.text = title
                }
                if let Description = gift["Description"]?.string {
                    cell.desc.text = Description
                }
                if let count = gift["CountAvailable"]?.int {
                    cell.count.text = "\(count)"
                }
                
            }
 
            cell.closure = { [weak self] in
                
                
                let giftId =  self?.gifts[num]["GiftType"]["Id"].int
                
                if giftId == 1 {
                    if let id = self?.gifts[num]["Fk_SecondCategoryProgram"].int {
                        if let name = self?.gifts[num]["SecondCategoryProgram"]["Name"].string {
                            if let FK_GiftId = self?.gifts[num]["Id"].int {
                                self?.bookingModel.DisCount = self?.gifts[num]["Discount"].int ?? 0
                                self?.bookingModel.Second_Category_Program_Name = name
                                self?.bookingModel.Second_Category_Program = id
                                self?.bookingModel.FK_Gift = FK_GiftId
                                self?.performSegue(withIdentifier: segueIdentifier.toTraineeMapSegue, sender: self)
                            }
                        }
                    }
                } else if giftId == 2 {
                    // Inbody
                    if let id = self?.gifts[num]["Id"].int {
                        let tab = PopusHandle.inbodyPOPUPViewController()
                        tab.Fk_Gift = id
                        self?.present(tab, animated: true)
                    }
                } else if giftId == 3 {
                    // ElBalto
                    ClickTo.openApp(url: nil)
                }
                
            }
            
            return cell
        }else {
            let cell = tableView.dequeueReusableCell(withIdentifier: nib_identifier_sperator, for: indexPath) as! separatorCellTableViewCell
            return cell
        }
    }
}

extension traineeGiftsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row % 2 == 0 {
            return 50
        }
        return 10
    }
}


/*

 
 */
