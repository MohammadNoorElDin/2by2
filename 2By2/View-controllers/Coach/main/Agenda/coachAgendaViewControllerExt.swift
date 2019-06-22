//
//  coachAgendaViewControllerExt.swift
//  2By2
//
//  Created by rocky on 11/18/18.
//  Copyright © 2018 personal. All rights reserved.
//

import UIKit

extension coachAgendaViewController {
    
    func toggleImage(btn: UIButton, name: String) {
        if btn == replicateButton {
            replicateButton.setImage(UIImage(named: name), for: .normal)
            if name == "radio-off-button" {
                manuallyButton.setImage(UIImage(named: "radio-on-button"), for: .normal)
            }else {
                manuallyButton.setImage(UIImage(named: "radio-off-button"), for: .normal)
            }
        }else if btn == manuallyButton {
            manuallyButton.setImage(UIImage(named: name), for: .normal)
            if name == "radio-off-button" {
                replicateButton.setImage(UIImage(named: "radio-on-button"), for: .normal)
            }else {
                replicateButton.setImage(UIImage(named: "radio-off-button"), for: .normal)
            }
        }
    }
    
    func configTable() {
        agendaTV.separatorInset = .zero
        agendaTV.contentInset = .zero
        agendaTV.allowsSelection = false
        agendaTV.tableFooterView = UIView()
        agendaTV.backgroundColor = .clear
        agendaCV.layer.cornerRadius = 10
        agendaCV.layer.masksToBounds = true
        agendaCV.allowsSelection = true
    }
    
    func fetchAgendaData() {
        
        
        AgendaGetAgendaModel.AgendaGetAgendaRequest(object: self) { (agendas, status) in
            if status == true {
                
                Alerts.DisplayDefaultAlert(title: "", message: "No data Found", object: self, actionType: .default)
                return
            }else {
                if agendas != nil {
                    if let agendas = agendas?.dictionary {
                        if let array = agendas["Data"]?.array {
                            self.agendas.removeAll()
                            self.agendas = array
                            
                            // see if selected cell has data with agendas comes from server
                            // see if selected cell has data with agendas comes from server
                            for (_, agenda) in self.agendas.enumerated() {
                                if let agenda = agenda.dictionary {
                                    if Generate.convertStrToDate(str: self.daysDates[self.selectedCell]) == Generate.convertStrToDate(str: agenda["Date"]!.string!) {
                                        self.timeFrames = (agenda["TimeFrames"]?.array)!
                                        self.agendaTV.reloadData()
                                    }
                                }
                            }
                            
                        }
                    }
                }
            }
            
        }
        
    }
    
    func sendRequest(params: [String: Any]){
        
        
        AgendaCreateModel.AgendaCreateRequest(object: self, params: params) { (response, status) in
            if status == true {
                
                Alerts.DisplayActionSheetAlert(title: "", message: "Error", object: self, actionType: .default)
                return
            }else {
              // DISPLAY SUCCESS MESSAGE .....
                
                self.fetchAgendaData()
            }
        }
        
    }
    
    func restartView() {
        self.agendas.removeAll()
        self.timeFrames.removeAll()
        self.viewDidAppear(true)
    }
    
    func deleteAgenda(id: Int, at: Int){
        let params = [
            AgendaDeleteModel.params.Fk_AgnedaTimeFrame: id
        ]
        
        AgendaDeleteModel.AgendaDeleteRequest(object: self, params: params) { (response, status) in
            if status == true {
                
                Alerts.DisplayActionSheetAlert(title: "", message: (response![Constants.Message].string)!, object: self, actionType: .default)
                return
            }else {
                self.timeFrames.remove(at: at)
                self.agendaTV.reloadData()
                self.fetchAgendaData()
            }
            
        }
    }
    
}
//MARK:- UITableViewDataSource
extension coachAgendaViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return timeFrames.count * 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row % 2 == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: nib_identifier_for_table, for: indexPath) as! coachAgendaTableViewCell
            
            let num = indexPath.row / 2
            
            
            if let timeFrame = timeFrames[num].dictionary {
                if let timeFrom = timeFrame["TimeFrom"]?.dictionary {
                    let hour = (timeFrom["Hours"]?.int)!
                    let minute = (timeFrom["Minutes"]?.int)!
                    /*let meridiem = (hour >= 12 && minute > 0) ? "PM" : "AM"*/
                    cell.fromLabel.text = "\(Generate._24hours(int: hour)):\(Generate.twoDigit(int: minute)) "
                }
                if let timeTo = timeFrame["TimeTo"]?.dictionary {
                    let hour = (timeTo["Hours"]?.int)!
                    let minute = (timeTo["Minutes"]?.int)!
                    /*let meridiem = (hour >= 12 && minute > 0) ? "PM" : "AM"*/
                    cell.toLabel.text = "\(Generate._24hours(int: hour)):\(Generate.twoDigit(int: minute))"
                }
                
            }
            
            cell.cancel = { [weak self] in
                // DELETE ITEM
                if let self = self {
                    Alerts.DisplayDefaultAlertWithActions(title: "", message: "Are You Sure? ", object: self, buttons: ["CANCEL" : .cancel, "OK": .default], actionType: .default, completion: { (name) in
                        if name == "OK" {
                            if let dic = self.timeFrames[num].dictionary {
                                if let Fk_AgnedaTimeFrame = dic["Id"]?.int {
                                    self.deleteAgenda(id: Fk_AgnedaTimeFrame, at: num)
                                }
                            }
                        }
                    })
                }
            }
            
            cell.modify = { [weak self] in
                // MODIFY ITEM
                self?.isModifying = true
                if let dic = self?.timeFrames[num].dictionary {
                    if let Fk_AgnedaTimeFrame = dic["Id"]?.int {
                       self?.timeFrameModified = Fk_AgnedaTimeFrame
                        let vc = PopusHandle.openAgendaPopup()
                        self?.present(vc, animated: true, completion: nil)
                    }
                }
            }
            
            cell.layer.cornerRadius = 10
            cell.layer.masksToBounds = true
            
            return cell
        }else {
            let cell = tableView.dequeueReusableCell(withIdentifier: nib_identifier_for_sperator, for: indexPath)
            cell.contentView.backgroundColor = UIColor.clear
            cell.layer.backgroundColor = UIColor.clear.cgColor
            
            return cell
        }
    }
    
}

//MARK:- UITableViewDelegate
extension coachAgendaViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row % 2 == 0 {
            return 90
        }
        return 20
    }
}

//MARK:- UICollectionViewDataSource
extension coachAgendaViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return daysNames.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: nib_identifier_for_collection, for: indexPath) as! coachAgendaCollectionViewCell
        
        if indexPath.row == selectedCell {
            cell.backgroundColor = Theme.setColor()
            cell.dateLabel.textColor = .white
            cell.nameLabel.textColor = .white
        }else {
            cell.backgroundColor = .white
            cell.dateLabel.textColor = Theme.setColor()
            cell.nameLabel.textColor = Theme.setColor()
        }
        
        cell.dateLabel.text = String(daysDates[indexPath.row].prefix(5))
        cell.dateLabel.font = Theme.FontLight(size: 12)
        cell.nameLabel.text = daysNames[indexPath.row]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        return CGSize(width: 88.0, height: 50.0)
    }
    
}

//MARK:- UICollectionViewDelegate
extension coachAgendaViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.visibleCells.forEach { (cell) in
            if let cell = cell as? coachAgendaCollectionViewCell {
                cell.backgroundColor = .white
                cell.dateLabel.textColor = Theme.setColor()
                cell.nameLabel.textColor = Theme.setColor()
            }
        }
        
        self.selectedCell = indexPath.row
        if let cell = collectionView.cellForItem(at: indexPath) as? coachAgendaCollectionViewCell {
            
            cell.backgroundColor = Theme.setColor()
            cell.dateLabel.textColor = .white
            cell.nameLabel.textColor = .white
            
            self.timeFrames.removeAll()
            // DISPLAY DATA IN TABLEVIEW
            agendas.forEach { (agenda) in
                
                if Generate.convertStrToDate(str: agenda["Date"].string!) == Generate.convertStrToDate(str: daysDates[indexPath.row]) {
                    
                    if let timeFrames = agenda["TimeFrames"].array {
                        self.timeFrames = timeFrames
                    }
                }
            }
            
            self.agendaTV.reloadData()
            
        } // end of the condition
    }
}


