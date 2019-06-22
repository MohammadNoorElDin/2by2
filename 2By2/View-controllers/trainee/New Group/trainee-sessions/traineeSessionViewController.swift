//
//  traineeSessionViewController.swift
//  trainee
//
//  Created by rocky on 11/23/18.
//  Copyright © 2018 personal. All rights reserved.
//

import UIKit
import SwiftyJSON
import GoogleMaps

class traineeSessionViewController: UIViewController {
    
    @IBOutlet weak var sessionTV: UITableView!
    var globalBookingModel: BookingDataModel!
    var Fk_ReservationInfo :Int!
    
    let nib_identifier = "traineeSessionTableViewCell"
    let nib_identifier_sperator = "separatorCellTableViewCell"
    let nib_identifier_schedule = "scheduleTableViewCell"
    let nib_identifier_past = "coachPastReservationTableViewCell"
    
    
    @IBOutlet var swapBtns: [CustomDesignableButton]! {
        didSet {
            for (index, element) in swapBtns.enumerated() {
                element.tag = index
            }
        }
    }
    
    var data: [JSON]? = nil
    var schedules: [JSON]? = nil
    var past: [JSON]? = nil
    var rateModel: rateDataModel!
    var observerRate: NSObjectProtocol?
    
    var currentSchedule: Int = 0
    var position: CLLocationCoordinate2D!
    var allCases: [String : UIAlertAction.Style] = ["Date": .default, "Trainer": .default, "Program": .default,"Location": .default, "Cancel": .cancel]
    
    var selectedBtn: Int = 0
    var trackCoach: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerTable(tableView: sessionTV, nib_identifier: nib_identifier)
        registerTable(tableView: sessionTV, nib_identifier: nib_identifier_sperator)
        registerTable(tableView: sessionTV, nib_identifier: nib_identifier_schedule)
        registerTable(tableView: sessionTV, nib_identifier: nib_identifier_past)
        configCell()
    }
    
    func configCell() {
        sessionTV.separatorInset = .zero
        sessionTV.contentInset = .zero
        sessionTV.allowsSelection = false
        sessionTV.tableFooterView = UIView()
        sessionTV.allowsSelection = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        ReservationGetReservationsModel.GetComingReservation.getUserComingReservations(object: self) { (response, error) in
            if error == false {
                if let data = response?["Data"].array {
                    self.data = data
                    // already succeeeeed
                    ReservationGetReservationsModel.GetComingReservation.GetUnReservation(object: self, completion: { (shcedules, error) in
                        
                        if error == false {
                            if let schedules = shcedules?["Data"].array {
                                self.schedules = schedules
                                self.sessionTV.reloadData()
                            }
                            
                            ReservationGetReservationsModel.GetPastReservations.GetUserPastReservation(object: self, completion: { (response, error) in
                                if error == false {
                                    if let past = response?["Data"].array {
                                        self.past = past
                                        // self.sessionTV.reloadData()
                                    }
                                }
                            })
                            
                        }
                        
                    }) // send second request ...............
                    
                }
            }
        }
        
        self.observerRate =  addCustomObserver(name: .rate) { (notification) in
            if let vc = notification.object as? coachPOPUPRateViewController {
                
                self.rateModel.UserRate = vc.rating
                self.rateModel.UserComment = vc.textComment
                
                let params = [
                    "Fk_ReservationsInfo": self.rateModel.Fk_ReservationsInfo!,
                    "Fk_User": self.rateModel.Fk_User!,
                    "Fk_Coach": self.rateModel.Fk_Coach!,
                    "UserRate": self.rateModel.UserRate!,
                    "UserComment": self.rateModel.UserComment!
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
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        self.currentSchedule = 0
        
        if let observerRate = observerRate {
            NotificationCenter.default.removeObserver(observerRate)
        }
    }
    
    @IBAction func swapBtns(_ sender: UIButton) {
        
        swapBtns.forEach { (btn) in
            if sender.tag == btn.tag {
                btn.backgroundColor = Theme.setColor()
                btn.setTitleColor(.white, for: .normal)
            }else {
                btn.backgroundColor = .white
                btn.setTitleColor(Theme.setColor(), for: .normal)
            }
        }
        self.selectedBtn = sender.tag
        self.sessionTV.reloadData()
    }
    
}

extension traineeSessionViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if self.selectedBtn == 0 {
            let dataCount = ( data?.count ?? 0 ) * 2
            let scheduleCount = ( schedules?.count ?? 0 ) * 2
            let leng = dataCount + scheduleCount
            return ( leng - 1 )
        }else if selectedBtn == 1 {
            let leng = self.past?.count ?? 0
            return ( leng ) * 2
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if self.selectedBtn == 1 { // past
            
            if indexPath.row % 2 == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: nib_identifier_past, for: indexPath) as! coachPastReservationTableViewCell
                
                let num = indexPath.row / 2
                
                if let current = past?[num].dictionary {
                    let user = current["Agenda"]?["AgnedaTimeFrame"]["Coach"].dictionary!
                    let id = current["ReservationsInfo"]?["Id"].int ?? 0
                    let state = current["ReservationsInfo"]?["ReservationState"]["Id"].int ?? 0
                    let stateDesc = current["ReservationsInfo"]?["ReservationState"]["Name"].string ?? ""
                    let name = user?["Name"]?.string ?? ""
                    // let userId = user?["Id"]?.int ?? 0
                    let image = user?["Image"]?.string ?? ""
                    
                    let package = current["ReservationsInfo"]?["SecondCategoryProgram"]["Name"].string ?? ""
                    let date = current["Agenda"]?["Date"].string ?? ""
                    let timehour = current["Agenda"]?["TimeFrom"]["Hours"].int ?? 0
                    let timemin = current["Agenda"]?["TimeFrom"]["Minutes"].int ?? 0
                    
                    /*let meridiem = (timehour >= 12) ? "PM" : "AM"*/
                    let time = "\(Generate._24hours(int: timehour)) : \(Generate.twoDigit(int: timemin))"
                    cell.configCell(coach: name, date: date, time: time, package: package, image: image, state: state, desc: stateDesc)
                    
                    cell.details = { [weak self] in
                        let params = ["Fk_ReservationInfo": id]
                        if let self = self {
                            ReservationCreateAdditionalCategoriesModel.GetReservationAdditionalCategories(object: self, params: params, completion: { (response, error) in
                                if error == false {
                                    let tab = PopusHandle.detailsPopupViewController()
                                    tab.message = response?.string ?? ""
                                    self.present(tab, animated: true, completion: nil)
                                }
                            })
                        }
                    } // END OF DETAILS
                    
                    cell.rate = { [weak self] in
                        if let rate = current["ReservationsRate"]?.dictionary {
                            let tab = PopusHandle.ratePopupViewController()
                            self?.rateModel = rateDataModel()
                            self?.rateModel.Fk_ReservationsInfo = id
                            self?.rateModel.Fk_Coach = rate["Fk_Coach"]?.int ?? 0
                            self?.rateModel.Fk_User = UserDataUsedThroughTheApp.userId
                            if let UserComment = rate["UserComment"]?.string {
                                self?.rateModel.UserComment = UserComment
                            }
                            if let UserRate = rate["UserRate"]?.int {
                                self?.rateModel.UserRate = Double(UserRate)
                            }
                            tab.rateModel = self?.rateModel
                            // send rate id
                            self?.present(tab, animated: true, completion: nil)
                        }
                    }
                    
                }
                
                
                return cell
            }else {
                let cell = tableView.dequeueReusableCell(withIdentifier: nib_identifier_sperator, for: indexPath) as! separatorCellTableViewCell
                
                return cell
            }
            
        } else { // upcoming
            
            if indexPath.row % 2 == 0 {
                let dataCount = data?.count ?? 0
                
                if dataCount > ( indexPath.row / 2 ) {
                    
                    // DATA
                    let cell = tableView.dequeueReusableCell(withIdentifier: nib_identifier, for: indexPath) as! traineeSessionTableViewCell
                    
                    let num = indexPath.row / 2
                    
                    if let currentPackage = data?[num].dictionary {
                        
                        var date = currentPackage["Agenda"]?["Date"].string ?? ""
                        let TimeFromHour = currentPackage["Agenda"]?["TimeFrom"]["Hours"].int ?? 0
                        let TimeFromMinute = currentPackage["Agenda"]?["TimeFrom"]["Minutes"].int ?? 0
                        /*let meridiem = (TimeFromHour >= 12 && TimeFromMinute > 0) ? "PM" : "AM"
                         TimeFromHour = (TimeFromHour >= 12 && TimeFromMinute > 0) ? TimeFromHour - 12 : TimeFromHour*/
                        let stateDesc = currentPackage["ReservationsInfo"]?["ReservationState"]["Name"].string ?? ""
                        let materialName = currentPackage["ReservationsInfo"]?["SecondCategoryProgram"]["Name"].string ?? ""
                        let coachName = currentPackage["Agenda"]?["AgnedaTimeFrame"]["Coach"]["Name"].string ?? ""
                        let package = currentPackage["Package"]?["Name"].string ?? ""
                        
                        if let image = currentPackage["Agenda"]?["AgnedaTimeFrame"]["Coach"]["Image"].string {
                            cell.profileIMage.findMe(url: image)
                            cell.profileIMage.imageRadius()
                        }else {
                            cell.profileIMage.image = UIImage(named: "profile-pic-size")
                        }
                        date = "\(date) - \(Generate._24hours(int: TimeFromHour)):\(Generate.twoDigit(int: TimeFromMinute))"
                        
                        
                        let state = currentPackage["ReservationsInfo"]?["Fk_State"].int ?? 0
                        
                        cell.configCell(name: coachName, material: materialName, package: package, date: date, state: state, desc: stateDesc)
                        
                        cell.call = {
                            let number = currentPackage["Agenda"]?["AgnedaTimeFrame"]["Coach"]["Phone"].string ?? ""
                            ClickTo.Call(number: number)
                        }
                        
                        cell.modify = {
                            
                            var canModify: String = ""
                            
                            // modify date
                            if (currentPackage["Package"]?["Modify_Date"].bool) != false  {
                                /// I'M HERE
                                canModify += "date"
                            }
                            // modify programs
                            if (currentPackage["Package"]?["Modify_Coach"].bool) !=  false {
                                /// I'M HERE
                                canModify += " & caoch"
                            }
                            // modify coach
                            if (currentPackage["Package"]?["Modify_Program"].bool) != false {
                                /// I'M HERE
                                canModify += " & program"
                            }
                            
                            Alerts.DisplayActionSheetAlertWithActions(title: "Modify Your own Session", message: "You can only modify \(canModify)", object: self, buttons: self.allCases, actionType: .default, completion: { (state) in
                                
                                let bookingModel = BookingDataModel()
                                
                                bookingModel.availableSessions = (currentPackage["AvailableSeesion"]?.int ?? 0)
                                bookingModel.isModifyingFk_ReservationInfoId = currentPackage["ReservationsInfo"]?["Id"].int ?? 0
                                bookingModel.timeWhichNeedsToBeUpdated = "\(Generate._24hours(int: TimeFromHour)):\(Generate.twoDigit(int: TimeFromMinute))"
                                bookingModel.dateWhichNeedsToBeUpdated = date
                                
                                bookingModel.isModifyingPrograms = true
                                bookingModel.latitude = currentPackage["ReservationsInfo"]?["Latitude"].double ?? 0.0
                                bookingModel.lngitude = currentPackage["ReservationsInfo"]?["Longitude"].double ?? 0.0
                                bookingModel.isModifyingFk_SecondCategoryProgram = currentPackage["ReservationsInfo"]?["Fk_SecondCategoryProgram"].int ?? 0
                                bookingModel.isModifyingFk_State = currentPackage["ReservationsInfo"]?["Fk_State"].int ?? 0
                                bookingModel.isModifyingFk_Reservation = currentPackage["ReservationsInfo"]?["Fk_Reservation"].int ?? 0
                                
                                self.globalBookingModel = bookingModel
                                
                                if state == "Date" {
                                    
                                    bookingModel.coachId = currentPackage["Agenda"]?["AgnedaTimeFrame"]["Coach"]["Id"].int ?? 0
                                    bookingModel.coachName = currentPackage["Agenda"]?["AgnedaTimeFrame"]["Coach"]["Name"].string ?? ""
                                    bookingModel.coachImage = currentPackage["Agenda"]?["AgnedaTimeFrame"]["Coach"]["Image"].string ?? ""
                                    bookingModel.availableSessions = 1
                                    
                                    self.performSegue(withIdentifier: segueIdentifier.toCoachModifySessionViewControllerSegue, sender: self)
                                    
                                }else if state == "Trainer" {
                                    if (currentPackage["Package"]?["Modify_Coach"].bool) != false  {
                                        Alerts.DisplayDefaultAlertWithActions(title: "Are You Sure ?", message: "All previous sessions will be removed", object: self, buttons: ["OK": .default, "CANCEl": .cancel], actionType: .default, completion: { (name) in
                                            if name == "OK" {
                                                // perform segue to coaches with lat and lng user should choose another coach ...
                                                self.performSegue(withIdentifier: segueIdentifier.toPickCoachModifySegue, sender: self)
                                            }
                                        })
                                    }else {
                                        Alerts.DisplayDefaultAlert(title: "", message: "This option is only available for MeFit, GoPro & Champion packages", object: self, actionType: .default)
                                    }
                                }else if state == "Program" { // start program condition .....
                                    if (currentPackage["Package"]?["Modify_Program"].bool) != false  { //skipped
                                        Alerts.DisplayDefaultAlertWithActions(title: "Are You Sure ?", message: "All previous sessions will be removed", object: self, buttons: ["OK": .default, "CANCEl": .cancel], actionType: .default, completion: { (name) in
                                            if name == "OK" {
                                                self.performSegue(withIdentifier: segueIdentifier.toChooseProgramModifySegue, sender: self)
                                            }
                                        })
                                    }else {
                                        Alerts.DisplayDefaultAlert(title: "", message: "This option is only available for GoPro & Champion packages" , object: self, actionType: .default)
                                    }
                                } // end of program
                                else if state == "Location" {
                                    self.Fk_ReservationInfo = bookingModel.isModifyingFk_ReservationInfoId
                                    self.globalBookingModel = bookingModel
                                    self.performSegue(withIdentifier: "toEditLocation", sender: self)
                                    
                                }
                                
                            })
                            
                        }
                        
                        cell.track = { [weak self] in
                            let lat = currentPackage["ReservationsInfo"]?["Latitude"].double ?? 0.0
                            let lng = currentPackage["ReservationsInfo"]?["Longitude"].double ?? 0.0
                            let position = CLLocationCoordinate2D(latitude: lat, longitude: lng)
                            self?.position = position
                            self?.trackCoach = coachName
                            self?.performSegue(withIdentifier: segueIdentifier.trackCoachIntheMap, sender: self)
                        }
                        
                        if currentPackage["Agenda"]?["IsOwner"].bool == false {
                            cell.modifyBtn.isHidden = true
                        }else {
                            cell.modifyBtn.isHidden = false
                        }
                    }
                    
                    return cell
                    
                } else {
                    
                    let cell = tableView.dequeueReusableCell(withIdentifier: nib_identifier_schedule, for: indexPath) as! scheduleTableViewCell
                    
                    let num = self.currentSchedule
                    
                    
                    if ( schedules?.count ?? 0 ) > num {
                        if let schedule = schedules?[num].dictionary {
                            
                            let package = "\(schedule["ReservationsInfo"]?["SecondCategoryProgram"]["Name"].string ?? "") - \(schedule["Package"]?["Name"].string ?? "")"
                            let ExpiryDate = schedule["ExpiryDate"]?.string ?? ""
                            let AvailableSeesion = schedule["AvailableSeesion"]?.int ?? 0
                            let coach = schedule["Coach"]?["Name"].string ?? ""
                            cell.configtable(package: package, avaliable: AvailableSeesion, expiry: ExpiryDate, coach: coach)
                            
                            cell.closure = { // schedule modify
                                
                                let bookingModel = BookingDataModel()
                                bookingModel.isscheduling = true 
                                bookingModel.isModifyingPrograms = true
                                bookingModel.latitude = schedule["ReservationsInfo"]?["Latitude"].double ?? 0.0
                                bookingModel.lngitude = schedule["ReservationsInfo"]?["Longitude"].double ?? 0.0
                                bookingModel.isModifyingFk_SecondCategoryProgram = schedule["ReservationsInfo"]?["Fk_SecondCategoryProgram"].int ?? 0
                                bookingModel.isModifyingFk_State = 5 /*schedule["ReservationsInfo"]?["Fk_State"].int ?? 0*/
                                bookingModel.isModifyingFk_Reservation = schedule["ReservationsInfo"]?["Fk_Reservation"].int ?? 0
                                bookingModel.coachId = schedule["Coach"]?["Id"].int ?? 0
                                bookingModel.coachName = schedule["Coach"]?["Name"].string ?? ""
                                bookingModel.coachImage = schedule["Coach"]?["Image"].string ?? ""
                                bookingModel.availableSessions = AvailableSeesion
                                
                                if (schedule["Package"]?["Modify_Date"].bool) == true  {
                                    self.globalBookingModel = bookingModel
                                    self.performSegue(withIdentifier: segueIdentifier.toCoachModifySessionViewControllerSegue, sender: self)
                                }
                                
                            }
                        }
                    }
                    
                    self.currentSchedule += 1
                    return cell
                    
                }
                
            } else  {
                
                let cell = tableView.dequeueReusableCell(withIdentifier: nib_identifier_sperator, for: indexPath) as! separatorCellTableViewCell
                
                return cell
            }
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == segueIdentifier.toCoachModifySessionViewControllerSegue {
            if let dest = segue.destination as? traineeAgendaHomeViewController {
                dest.bookingModel = self.globalBookingModel
            }
        }
        
        if segue.identifier == segueIdentifier.toChooseProgramModifySegue {
            if let dest = segue.destination as? ChooseProgramViewController {
                dest.bookingModel = self.globalBookingModel
            }
        }
        
        
        if segue.identifier == segueIdentifier.toPickCoachModifySegue {
            if let dest = segue.destination as? PickYourCoachViewController {
                dest.bookingModel = self.globalBookingModel
            }
        }
        
        if segue.identifier == segueIdentifier.trackCoachIntheMap {
            if let dest = segue.destination as? traineeMapViewController {
                dest.pos = self.position
                dest.trackCoach = self.trackCoach
            }
        }
        if segue.identifier == "toEditLocation" {
            let dest = segue.destination as? UINavigationController
            if let destVC = dest?.topViewController as? editLocation {
                destVC.Fk_ReservationInfo = self.Fk_ReservationInfo
                destVC.booking = self.globalBookingModel
                
            }
        }
        
    }
}

extension traineeSessionViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row % 2 == 0 {
            let num = indexPath.row / 2
            if num < ( data?.count ?? 0 ) {
                return 120
            }else {
                return 100
            }
        }
        return 10
    }
    
    @IBAction func openSideMenu(_ sender: Any) {
        self.sideMenuController?.revealMenu()
    }
}

