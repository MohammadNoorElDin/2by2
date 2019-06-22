//
//  ChoosePackageViewController.swift
//  trainee
//
//  Created by Kamal on 12/10/18.
//  Copyright © 2018 personal. All rights reserved.
//

import UIKit
import SwiftyJSON

class ChoosePackageViewController: UIViewController {
    
    
    @IBOutlet weak var viewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var heightOfTableViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var dataTV: UITableView!
    @IBOutlet weak var SessionLabel: UILabel!
    @IBOutlet weak var dataSV: UIScrollView!
    @IBOutlet weak var confirmBtn: CustomDesignableButton!
    @IBOutlet weak var innerView: UIView!
    
    let nib_identefire_Package = "PackageTableViewCell"
    
    var data: [JSON]? = nil
    var selectedDataElement: JSON? = nil
    var PackagePersonRangePrices: [JSON]? = nil
    var pickUpobserver: NSObjectProtocol?
    var numberOfPersons: Int = 0 // DROP DOWN
    var selectedPersonsNumber: Int = 0 // RADIO BUTTON
    var numsOfPacks : Int = 0
    var friends = [FriendsInfo]()
    var btnNames = [String]()
    var btnNumbers = [Int]()
    
    var bookingModel: BookingDataModel!
    var btnsIds = [Int]()
    
    var btnSelectedTag : Int = 0
    var rowHeight: Int = 35
    
    @IBOutlet var btns: [CustomDesignableButton]! {
        didSet {
            for (index, element) in btns.enumerated()  {
                element.tag = index
            }
        }
    }
    @IBOutlet var costs: [UILabel]! {
        didSet {
            for (index, element) in costs.enumerated()  {
                element.tag = index
            }
        }
    }
    @IBOutlet var persons: [UIButton]! {
        didSet {
            for (index, element) in persons.enumerated() {
                element.tag = index
            }
        }
    }
    @IBOutlet var dropDown: [UIButton]! {
        didSet {
            for (index, element) in dropDown.enumerated() {
                element.tag = index
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerTable(tableView: dataTV, nib_identifier: nib_identefire_Package)
        dataTV.allowsSelection = false
        dataTV.isScrollEnabled = false
        self.updateTVHeight()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        let params = ["Latitude":bookingModel.latitude,
                      "Longitude":bookingModel.lngitude,
                      "Fk_SecondCategoryProgram":bookingModel.Second_Category_Program] as [String : Any]
        print(params)
        ReservationGetPackagesModel.UserGetPackagesRequest(object: self, params: params) { (response, error) in
            if error == false {
                
                if let data = response?["Data"].array {
                   // print
                    if data.count != 0 {
                    self.data = data
                    self.numsOfPacks = self.data?.count ?? 0
                    self.selectedDataElement = self.data?[self.btnSelectedTag]
                    
                    data.forEach({ (element) in
                        if let id = element["Id"].int {
                            self.btnsIds.append(id)
                        }
                        if let name = element["Name"].string {
                            self.btnNames.append(name)
                        }
                        if let count = element["SeesionCount"].int {
                            self.btnNumbers.append(count)
                        }
                    })
                    // update package button data
                    self.updatePackageView()
                    self.updateTVHeight()
                    self.viewSetHeight()
                    
                    if let arrayList = self.selectedDataElement?["PackagePersonRangePrices"].array {
                        self.PackagePersonRangePrices = arrayList
                        self.updateCosts(arrayList: arrayList)
                    }
                    self.SessionLabel.text = (self.data?[self.btnSelectedTag]["Include"].string ?? "")
                    
                    self.bookingModel.availableSessions = self.btnNumbers[self.btnSelectedTag]
                    } else {
                        let massage = response?["Status"]["Message"].string ?? ""
                        Alerts.DisplayDefaultAlertWithActions(title: "error", message: massage, object: self, buttons: ["Okey":.cancel], actionType: .cancel, completion: { (btn) in
                            if btn == "Okey" {
                                 self.navigationController?.popViewController(animated: true)
                            }
                        })
                       
                    }
            }
            }
        }
        
        self.pickUpobserver = self.addCustomObserver(name: .pickPOPUP) { (notification) in
            if let vc = notification.object as? PickYourCoachPOPUPViewController {
                self.numberOfPersons = vc.selectedNumber - 1
                self.dropDown[self.selectedPersonsNumber].setTitle("\(vc.selectedNumber) ↓", for: .normal)
                self.dataTV.reloadData()
                self.updateTVHeight()
            }
        }
        
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        if let pickUpobserver = pickUpobserver {
            NotificationCenter.default.removeObserver(pickUpobserver)
        }
    }
    
    func updateTVHeight () {
        self.dataTV.layoutIfNeeded()
        self.heightOfTableViewConstraint.constant = CGFloat( (self.numberOfPersons * self.rowHeight) + 35 )
        self.viewSetHeight()
    }
    
    func updateCosts(arrayList: [JSON]) {
        for (index, element) in arrayList.enumerated() {
            if let element = element.dictionary {
                self.costs[index].text = "CPP \(element["Price"]?.int ?? 0 ) L.E"
            }
        }
    }
    func updateNumberofPersons(sender: UIButton) {
        if let PackagePersonRangePrice = self.PackagePersonRangePrices?[sender.tag].dictionary {
            if let PackagePersonRange = PackagePersonRangePrice["PackagePersonRange"]?.dictionary {
                if let CountFrom = PackagePersonRange["CountFrom"]?.int {
                    self.numberOfPersons = CountFrom - 1
                }
            }
        }
    }
    func updatePackageView() {
        for (index, element) in self.btns.enumerated() {
            if index < numsOfPacks {
                element.twoLines(first: btnNames[index], second: String(btnNumbers[index]))}
            else {
                element.isHidden = true
            }
            // element.setTitle(btnNames[index], for: .normal)
        }
    }
    
    @IBAction func btnsClicked(_ sender: UIButton) {
        
        self.btnSelectedTag =  sender.tag
        
        btns.forEach { (btn) in
            
            if btn.tag == self.btnSelectedTag {
                
                btn.backgroundColor = Theme.setColor()
                btn.setTitleColor(.white, for: .normal)
                
                self.selectedDataElement = data?[sender.tag]
                
                if let arrayList = self.selectedDataElement?["PackagePersonRangePrices"].array {
                    self.PackagePersonRangePrices = arrayList
                    self.updateCosts(arrayList: arrayList)
                }
                
                self.SessionLabel.text = (self.selectedDataElement?["Include"].string ?? "")
                
                self.bookingModel.availableSessions = self.btnNumbers[sender.tag]
                
            }else {
                btn.backgroundColor = .white
                btn.setTitleColor(Theme.setColor(), for: .normal)
            }
        }
        
        self.updateTVHeight()
    }
    
    @IBAction func personsClicked(_ sender: UIButton) {
        persons.forEach { (person) in
            if person.tag == sender.tag {
                person.setImage(UIImage(named: "radio-on-button"), for: .normal)
            }else {
                person.setImage(UIImage(named: "radio-off-button"), for: .normal)
            }
        }
        self.selectedPersonsNumber = sender.tag
        updateNumberofPersons(sender: sender)
        self.updateTVHeight()
        self.dataTV.reloadData()
    }
    
    @IBAction func dropDownClicked(_ sender: UIButton) {
        if self.selectedPersonsNumber == sender.tag {
            let vc = PopusHandle.pickYourCoachPopupViewController()
            if sender.tag == 1 { // 2 or more
                vc.pickPOPUP += 2...4
            }else if sender.tag == 2 { // 5 or more
                vc.pickPOPUP += 5...10
            }
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    @IBAction func confirmClicked(_ sender: UIButton) {
        
        self.friends.removeAll()
        
        self.dataTV.visibleCells.forEach { (cell) in
            if let cell = cell as? PackageTableViewCell {
                guard let name = cell.nameTF.text, !name.isEmpty else {
                    Alerts.DisplayActionSheetAlertWithButtonName(title: "Please add your workout buddies", message: "", object: self, actionType: .default, name: "OK")
                    return
                }
                guard let mobile = cell.phoneTF.text, !mobile.isEmpty else {
                    
                    Alerts.DisplayActionSheetAlertWithButtonName(title: "Please add your workout Buddies phone number", message: "", object: self, actionType: .default, name: "OK")
                    return
                }
                guard Validation.isValidPhoneNumber(mobile) else {
                    Alerts.DisplayActionSheetAlertWithButtonName(title: "Please add a valid phone number", message: "", object: self, actionType: .default, name: "OK")
                    return
                }
                let friend = FriendsInfo(name: name, mobile: mobile)
                self.friends.append(friend)
            }
        }
        
        if friends.count == self.numberOfPersons {
            if let package = PackagePersonRangePrices?[self.selectedPersonsNumber].dictionary {
                self.bookingModel.Package_Name = self.btnNames[self.btnSelectedTag]
                self.bookingModel.packagePrice = package["Price"]?.int ?? 0
                self.bookingModel.Fk_PackagePersonRangePrice = package["Id"]?.int ?? 0 // package id
            }
            
            self.bookingModel.friends = self.friends
            performSegue(withIdentifier: segueIdentifier.toAboutTraineeSegue, sender: self)
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == segueIdentifier.toAboutTraineeSegue {
            if let dest = segue.destination as? AboutTraineeViewController {
                dest.bookingModel = self.bookingModel
            }
        }
    }
    
    
    
}

extension ChoosePackageViewController : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberOfPersons
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: nib_identefire_Package, for: indexPath) as! PackageTableViewCell
        
        cell.dataIndex.text = "\(indexPath.row + 1)"
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(self.rowHeight)
    }
    
    func viewSetHeight() {
        
        var height = self.SessionLabel.intrinsicContentSize.height
        
        if numberOfPersons == 0 {
        }else if numberOfPersons == 9 {
            height += 40 + dataTV.contentSize.height
        } else {
            height += 20 + dataTV.contentSize.height
        }
        if height > CGFloat(900) {
            height = CGFloat(900)
        }
        self.viewHeight.constant = height
        self.view.layoutIfNeeded()
        
    }
    
}

