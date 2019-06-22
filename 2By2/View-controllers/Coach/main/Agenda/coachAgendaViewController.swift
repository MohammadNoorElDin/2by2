//
//  coachAgendaViewController.swift
//  2By2
//
//  Created by rocky on 11/17/18.
//  Copyright © 2018 personal. All rights reserved.
//

import UIKit
import SwiftyJSON
import SideMenuSwift

class coachAgendaViewController: UIViewController {

    @IBOutlet weak var agendaTV: UITableView!
    @IBOutlet weak var agendaCV: UICollectionView!
    @IBOutlet weak var replicateButton: UIButton!
    @IBOutlet weak var manuallyButton: UIButton!
    
    let nib_identifier_for_table = "coachAgendaTableViewCell"
    let nib_identifier_for_collection = "coachAgendaCollectionViewCell"
    let nib_identifier_for_sperator = "separatorCellTableViewCell"
    
    var daysDates = Generate.return30DaysInDates()
    var daysNames = Generate.return30DaysInNames()
    
    var agendas = [JSON]()
    var selectedCell: Int = 0
    var timeFrames = [JSON]()
    
    var isModifying: Bool = false 
    var timeFrameModified: Int = 0
    
    var selectedWay : Int = 0  /* 1- (0) replicate 2- (1) manually */
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerTable(tableView: agendaTV, nib_identifier: nib_identifier_for_table)
        registerTable(tableView: agendaTV, nib_identifier: nib_identifier_for_sperator)
        registerCollection(collectionView: agendaCV, nib_identifier: nib_identifier_for_collection)
        configTable()
        
        NotificationCenter.default.addObserver(forName: .coachSetagenda, object: nil, queue: OperationQueue.main) { (notification) in
            
            print("I was here 2 second ago ")
            
            if let agenda = notification.object as? agendaPopupViewController {
                
                if self.isModifying == true {
                    
                    let params = [
                        AgendaEditModel.params.Fk_AgnedaTimeFrame : self.timeFrameModified,
                        AgendaEditModel.params.TimeFrom : agenda.timeFrom,
                        AgendaEditModel.params.TimeTo : agenda.timeto,
                        AgendaEditModel.params.Date : self.daysDates[self.selectedCell],
                    ] as [String: Any]
                    
                    AgendaEditModel.AgendaModifyRequest(object: self, params: params, completion: { (response, status) in
                        if status == true {
                            
                            return
                        }else {
                            self.restartView()
                        }
                        
                    })
                    self.isModifying = false
                    return
                    
                } // END OF MODIFING
                
                var agendas = [Any]()
                var conflict: Bool = false
                
                self.timeFrames.forEach({ (timeFrame) in
                    if let timeFrame = timeFrame.dictionary {
                        var from : Int = 0
                        var to : Int = 0
                        if let timeFrom = timeFrame["TimeFrom"]?.dictionary {
                            if let hour = timeFrom["Hours"]?.int {
                                from = hour
                            }
                        }
                        
                        if let timeTo = timeFrame["TimeTo"]?.dictionary {
                            if let hour = timeTo["Hours"]?.int {
                               to = hour
                            }
                        }
                        
                        if Validation.isBetween(from: from, to: to, number: agenda.returnHour(sender: agenda.fromPV)) || Validation.isBetween(from: from, to: to, number: agenda.returnHour(sender: agenda.toPV)) {
                            
                            Alerts.DisplayActionSheetAlert(title: "", message: "wrong Appointment", object: self, actionType: .default)
                            conflict = true
                            return
                        }
                        
                    }
                })
                
                if conflict == true {
                    // OUT OF THE FUNCTION BECAUSE TIMES ALREADY SAVED
                    return
                } else if self.selectedWay == 0 {
                    
                    let dates = Generate.return4SimilarDaysIntheMonth(startFrom: Generate.convertStrToDate(str: self.daysDates[self.selectedCell]))
                    
                    var count = ( dates.count - ( self.selectedCell + 1 ) ) % 7
                    count = dates.count - ( count + self.selectedCell )
                    count = count / 7
                    
                    for index in 0...count {
                        agendas.append(
                            [
                                AgendaCreateModel.params.AgnedaTimeFrames.TimeFrom: agenda.timeFrom,
                                AgendaCreateModel.params.AgnedaTimeFrames.TimeTo: agenda.timeto,
                                AgendaCreateModel.params.AgnedaTimeFrames.Date: dates[self.selectedCell + ( index * 7 )]
                            ]
                        )
                    }
                    
                }else {
                    agendas.append(
                        [
                            AgendaCreateModel.params.AgnedaTimeFrames.TimeFrom: agenda.timeFrom,
                            AgendaCreateModel.params.AgnedaTimeFrames.TimeTo: agenda.timeto,
                            AgendaCreateModel.params.AgnedaTimeFrames.Date: self.daysDates[self.selectedCell]
                        ]
                    )
                    
                }
                
                let params = [
                    AgendaCreateModel.params.Fk_Coach : CoachDataUsedThroughTheApp.coachId,
                    AgendaCreateModel.params.AgnedaTimeFrames.structName : agendas
                ] as [String : Any]
                
                self.sendRequest(params: params)
                
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        fetchAgendaData()
    }
    
    @IBAction func replicateButtonClicked(_ sender: UIButton) {
        
        if sender.currentImage == UIImage(named: "radio-on-button") {
            toggleImage(btn: sender, name: "radio-off-button")
            self.selectedWay = 1
        }else {
            toggleImage(btn: sender, name: "radio-on-button")
            self.selectedWay = 0
        }
        
    }
    
    @IBAction func manuallyButtonClicked(_ sender: UIButton) {
        
        if sender.currentImage == UIImage(named: "radio-on-button") {
            toggleImage(btn: sender, name: "radio-off-button")
            self.selectedWay = 0
        }else {
            toggleImage(btn: sender, name: "radio-on-button")
            self.selectedWay = 1
        }
    }
    
    @IBAction func buildYourSchedule(_ sender: UIButton) {
        let vc = PopusHandle.openAgendaPopup()
        vc.choosenDate = self.daysDates[self.selectedCell]
        print(vc.choosenDate)
        present(vc, animated: true, completion: nil)
    }
    @IBAction func openSideMenu(_ sender: UIBarButtonItem) {
        self.sideMenuController?.revealMenu()
    }
    
}
