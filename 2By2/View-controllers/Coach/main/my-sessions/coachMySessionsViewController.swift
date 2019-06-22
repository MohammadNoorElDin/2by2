//
//  coachMySessionsViewController.swift
//  2By2
//
//  Created by rocky on 11/16/18.
//  Copyright © 2018 personal. All rights reserved.
//

import UIKit
import SideMenuSwift
import SwiftyJSON
import GoogleMaps
// 

class coachMySessionsViewController: UIViewController {
    
    @IBOutlet weak var sessionTV: UITableView!
    @IBOutlet weak var pastBtn: UIButton!
    @IBOutlet weak var onGoingBtn: UIButton!
    var selectedButton : Int = 0 // 0 -> ongoing , 1 -> past
    
    let nib_identifier = "CoachMySessionsTableViewCell"
    let nib_identifier_Past = "coachPastReservationTableViewCell"
    let nib_identifier_separator_cell = "separatorCellTableViewCell"
    var reservationInfo: JSON!
    
    var result: [JSON]? = nil
    var past: [JSON]? = nil
    var rateModel: rateDataModel!
    var observerRate: NSObjectProtocol?
    var observerExp: NSObjectProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerTable(tableView: sessionTV, nib_identifier: nib_identifier)
        registerTable(tableView: sessionTV, nib_identifier: nib_identifier_Past)
        registerTable(tableView: sessionTV, nib_identifier: nib_identifier_separator_cell)
        configTable()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        self.observerRate =  addCustomObserver(name: .rate) { (notification) in
            if let vc = notification.object as? coachPOPUPRateViewController {
                
                self.rateModel.CoachRate = vc.rating
                self.rateModel.CoachComment = vc.textComment
                
                let params = [
                    "Fk_ReservationsInfo": self.rateModel.Fk_ReservationsInfo!,
                    "Fk_User": self.rateModel.Fk_User!,
                    "Fk_Coach": self.rateModel.Fk_Coach!,
                    "CoachRate": self.rateModel.CoachRate!,
                    "CoachComment": self.rateModel.CoachComment!
                ] as [String: Any]
                
                ReservationRateModel.updateRate(object: self, params: params, completion: { (response, error) in
                    if error == false {
                        Alerts.DisplayDefaultAlertWithActions(title: "", message: "rate added successfully", object: self, buttons: ["OK" : .default], actionType: .default, completion: { (name) in
                            if name == "OK" {
                                self.viewDidAppear(true)
                            }
                        })
                    }
                })
            }
        }
        self.observerExp = addCustomObserver(name: .sessionExp, completion: { (notification) in
            if let vc = notification.object as? sessionExperiencesViewController {
                let params = vc.params
                ReservationReservationsInfoModel.EditReservationsInfo.editReservation(object: self, params: params!, completion: { (response, error) in
                    if error == false {
                        self.viewDidAppear(true)
                    }
                })
                
            }
        })
        
        ReservationGetCoachComingReservationModel.GetCoachComingReservation(object: self) { (response, error) in
            if error == false {
                if let result = response?["Data"].array {
                    self.result = result
                    // bring past reservation
                    ReservationGetCoachPastReservationModel.GetCoachPastReservation(object: self, completion: { (res, error) in
                        
                        if error == false {
                            if let res = res?["Data"].array {
                                self.past = res
                                self.sessionTV.reloadData()
                            }
                        }
                        
                    }) // end of the request ...
                    
                }
            }
            
        }
    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        
        if let observerExp = observerExp {
            NotificationCenter.default.removeObserver(observerExp)
        }
        if let observerRate = observerRate {
            NotificationCenter.default.removeObserver(observerRate)
        }
    }
    
    func reloadView() {
        self.sessionTV.reloadData()
    }
    
    func configTable() {
        sessionTV.allowsSelection = false
        sessionTV.separatorInset = .zero
        sessionTV.contentInset = .zero
        sessionTV.tableFooterView = UIView()
        sessionTV.backgroundColor = UIColor.clear
    }
    
    @IBAction func openSideMenu(_ sender: UIBarButtonItem) {
        self.sideMenuController?.revealMenu()
    }
    
    @IBAction func pastClicked(_ sender: UIButton) {
        openPast()
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
            self.reloadView()
        }
        
    }
    
    
    func openPast() {
        
        if selectedButton == 0 /* was ongoing */ {
            let swapBack = pastBtn.backgroundColor
            let swapColor = pastBtn.titleLabel?.textColor
            pastBtn.backgroundColor = onGoingBtn.backgroundColor
            pastBtn.setTitleColor(.white, for: .normal)
            onGoingBtn.backgroundColor = swapBack
            onGoingBtn.setTitleColor(swapColor, for: .normal)
            self.selectedButton = 1
            self.reloadView()
        }
        
    }
}

//MARK:- UITableViewDataSource
extension coachMySessionsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.selectedButton == 0 {
            return ( result?.count ?? 0 ) * 2
        }else {
            return ( past?.count ?? 0 ) * 2
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if selectedButton == 1 { // past
            
            if indexPath.row % 2 == 0 {
                
                let cell = tableView.dequeueReusableCell(withIdentifier: nib_identifier_Past, for: indexPath) as! coachPastReservationTableViewCell
                
                let num = indexPath.row / 2
                
                if let current = past?[num].dictionary {
                    let id = current["ReservationsInfo"]?["Id"].int ?? 0
                    let state = current["State"]?["Id"].int ?? 0
                    let stateDesc = current["State"]?["Name"].string ?? ""
                    let name = current["User"]?["Name"].string ?? ""
                    let userId = current["User"]?["Id"].int ?? 0
                    let package = current["SecondCategoryProgram"]?["Name"].string ?? ""
                    let date = current["Agenda"]?["Date"].string ?? ""
                    let timehour = current["Agenda"]?["TimeFrom"]["Hours"].int ?? 0
                    let timemin = current["Agenda"]?["TimeFrom"]["Minutes"].int ?? 0
                    let image = current["User"]?["Image"].string ?? ""
                    /*let meridiem = (timehour >= 12) ? "PM" : "AM"*/
                    let time = "\(Generate._24hours(int: timehour)) : \(Generate.twoDigit(int: timemin))"
                    cell.configCell(coach: name, date: date, time: time, package: package, image: image, state: state, desc: stateDesc)
                    
                    cell.details = {
                        let params = ["Fk_ReservationInfo": id]
                        ReservationCreateAdditionalCategoriesModel.GetReservationAdditionalCategories(object: self, params: params, completion: { (response, error) in
                            if error == false {
                                let tab = PopusHandle.detailsPopupViewController()
                                tab.message = response?.string ?? ""
                                self.present(tab, animated: true, completion: nil)
                            }
                        })
                        
                    }
                    
                    cell.rate = { [weak self] in
                        if let rate = current["ReservationsRate"]?.dictionary {
                            let tab = PopusHandle.ratePopupViewController()
                            self?.rateModel = rateDataModel()
                            self?.rateModel.Fk_ReservationsInfo = id
                            self?.rateModel.Fk_Coach = CoachDataUsedThroughTheApp.coachId
                            self?.rateModel.Fk_User = userId
                            if let CoachComment = rate["CoachComment"]?.string {
                                self?.rateModel.CoachComment = CoachComment
                            }
                            if let CoachRate = rate["CoachRate"]?.int {
                                self?.rateModel.CoachRate = Double(CoachRate)
                            }
                            tab.rateModel = self?.rateModel
                            // send rate id
                            self?.present(tab, animated: true, completion: nil)
                        }
                    }
                    
                }
                
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: nib_identifier_separator_cell, for: indexPath) as! separatorCellTableViewCell
                return cell
            }
            
        }else { // coming reservation
            
            if indexPath.row % 2 == 0 {
                
                let cell = tableView.dequeueReusableCell(withIdentifier: nib_identifier, for: indexPath) as! CoachMySessionsTableViewCell
                
                let num = indexPath.row / 2
                
                let coachName: String = result?[num]["User"]["Name"].string ?? ""
                let packageName: String = result?[num]["ReservationsInfo"]["SecondCategoryProgram"]["Name"].string ?? ""
                let date: String = result?[num]["Agenda"]["Date"].string ?? ""
                
                let timeFrom: Int = result?[num]["Agenda"]["TimeFrom"]["Hours"].int ?? 0
                let timeTo: Int = result?[num]["Agenda"]["TimeTo"]["Minutes"].int ?? 0
                /*let meridiem = (timeFrom >= 12) ? "PM" : "AM"*/
                let state = result?[num]["State"]["Id"].int ?? 0
                
                let res = result?[num]
                self.reservationInfo = res
                
                let lat = self.result?[num]["ReservationsInfo"]["Latitude"].double
                let lng = self.result?[num]["ReservationsInfo"]["Longitude"].double
                
                cell.configCell(name: coachName, packageName: packageName, date: date, time: "\(Generate._24hours(int: timeFrom)):\(Generate.twoDigit(int: timeTo))", hour: timeFrom, state: state)
                
                var params = [
                    "Fk_Agenda": res?["Agenda"]["Id"].int ?? 0,
                    "Id": res?["ReservationsInfo"]["Id"].int ?? 0,
                    "Fk_SecondCategoryProgram": res?["SecondCategoryProgram"]["Id"].int ?? 0,
                    "Fk_State"   : 7,
                    "Latitude"   : lat!,
                    "Longitude"  : lng!
                ] as [String: Any]
                
                
                cell.onTheWay = { [weak self] in
                    self?.sendRequest(params: params, completion: {
                        self?.viewDidAppear(true)
                        ClickTo.openMapInBrowser(lat: lat!, lng: lng! )
                    })
                }
                
                cell.start = { [weak self] in  // start
                    params["Fk_State"] = 6
                    let tab = PopusHandle.sessionExperiencesViewController()
                    tab.Fk_ReservationInfo = res?["ReservationsInfo"]["Id"].int ?? 0
                    tab.params = params 
                    self?.present(tab, animated: true, completion: nil)
                }
                
                
                cell.completed = { [weak self] in
                    params["Fk_State"] = 8
                    self?.sendRequest(params: params, completion: {
                        self?.viewDidAppear(true)
                        self?.openPast()
                    })
                }
                
                
                // call
                cell.call = { [weak self] in
                    let phone = self?.result?[num]["User"]["Phone"].string ?? ""
                    ClickTo.Call(number: phone)
                }
                
                // location
                cell.location = {
                    ClickTo.openMapInBrowser(lat: lat!, lng: lng! )
                }
                
                return cell
                
            } else {
                
                let cell = tableView.dequeueReusableCell(withIdentifier: nib_identifier_separator_cell, for: indexPath)
                cell.contentView.backgroundColor = UIColor.clear
                cell.layer.backgroundColor = UIColor.clear.cgColor
                
                return cell
            } // sperator cell
        }
    }
    
    func sendRequest(params: [String: Any], completion: @escaping () -> () ) {
        ReservationReservationsInfoModel.EditReservationsInfo.editReservation(object: self, params: params, completion: { (response, error) in
            if error == false {
                completion()
            }
        })
    }
    
}

//MARK:- UITableViewDelegate
extension coachMySessionsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if selectedButton == 1 && indexPath.row % 2 == 0 {
            return 120
        } else if indexPath.row % 2 == 0 && selectedButton == 0 {
            return 120
        }
        
        return 20
    }
}
