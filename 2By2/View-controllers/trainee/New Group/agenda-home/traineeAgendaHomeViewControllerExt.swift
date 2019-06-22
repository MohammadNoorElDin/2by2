//
//  traineeAgendaHomeViewControllerExt.swift
//  trainee
//
//  Created by rocky on 12/13/18.
//  Copyright © 2018 personal. All rights reserved.
//

import UIKit
import SwiftyJSON

fileprivate var current: Int = 0
extension traineeAgendaHomeViewController {
    
    //MARK:- THR FIFTH ONE (dayNamesAndDates)
    func dayNamesAndDates() {
        arrayOfDates = Generate.return30DaysInDates()
        arrayOfDatesNames = Generate.return30DaysInNames()
    }
    
    
    func fetchCoachDataHome(){
        
        let params = [
            ReservationGetCoachAgendaModel.params.Fk_Coach: self.bookingModel.coachId,
            ReservationGetCoachAgendaModel.params.Fk_User: UserDataUsedThroughTheApp.userId,
        ]
        
        ReservationGetCoachAgendaModel.GetCoachAgenda(object: self, params: params) { (response, error) in
            if error == true {
                
                return
            } else {
                // DATA RETURNED
                if let rows = response["RowMax"]?.int { self.rows = rows + 1 }
                if let agenda = response["AgendaDates"]?.array { self.agendaDates = agenda }
                self.collectionView.reloadData()
            }
            
        }
    }
    
}


// MARK: - UICollectionViewDataSource
extension traineeAgendaHomeViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if rows < 15 {
            return 15
        }else {
            return rows
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrayOfDatesNames.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // swiftlint:disable force_cast
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: contentCellIdentifier,
                                                      for: indexPath) as! ContentCollectionViewCell
        
        let column = indexPath.row
        let row = indexPath.section
        
        if row != current && agendaDates.count > 0 {
            current = row
        }
        
        cell.backgroundColor = UIColor(rgb: 0xE7E7E7).withAlphaComponent(0.0)
        
        if row == 0 {
            
            cell.contentLabel.setTitle(arrayOfDatesNames[column], for: .normal)
            cell.dateLabel.isHidden = false
            cell.dateLabel.text = String(arrayOfDates[column].prefix(5))
            
            cell.contentLabel.backgroundColor = UIColor.clear
            cell.contentLabel.titleLabel?.textColor = UIColor.black
            cell.contentLabel.titleLabel?.font = Theme.FontBold(size: 16)
            cell.contentLabel.setTitleColor(.black, for: .normal)
            cell.dateLabel.font = Theme.FontLight(size: 13)
            cell.backImage.image = UIImage(named: "border-bottom-right")
            //cell.isUserInteractionEnabled = false
            cell.backgroundColor = UIColor(rgb: 0xE7E7E7).withAlphaComponent(1)
        
            
        } else  /* NOT THE HEADER */ {
            
            // AHMED ELSNOSEY'S CODE
            cell.contentLabel.setTitle(nil, for: .normal)
            cell.contentLabel.backgroundColor = nil
            cell.backImage.image = UIImage()
            cell.dateLabel.sizeToFit()
            cell.dateLabel.isHidden = true
            cell.backImage.image = UIImage()
            cell.backImage.image = UIImage(named: "border-right")
            cell.isUserInteractionEnabled = true
            for (_, agendaDate) in agendaDates.enumerated() {
                
                if Generate.convertStrToDate(str: agendaDate["Date"].string!) == Generate.convertStrToDate(str: arrayOfDates[column]) {
                
                    if let agendas = agendaDate["Agendas"].array {
                        if ( row - 1 ) < agendas.count {
                            if let agenda = agendas[ row - 1 ].dictionary {
                                if let time = agenda["TimeFrom"]?.dictionary {

                                    
                                    let hour = (time["Hours"]?.int)!
                                    let minute = (time["Minutes"]?.int)!
                                    /*let meridiem = (hour >= 12 && minute > 0) ? "PM" : "AM"
                                    hour = (hour > 12) ? ( hour - 12 ) : hour*/
                                    
                                    let CellContentLabel = "\(Generate._24hours(int: hour)):\(Generate.twoDigit(int: minute))"
                                    cell.configCell(content: CellContentLabel, date: nil)
                                    
                                    /*else*/
                                        
                                    if agenda["IsReserved"]?.bool == false {
                                        let agendaId = agenda["Id"]?.int ?? -1
                                        if self.bookingModel.FK_Agenda.contains(agendaId) {
                                            cell.contentLabel.backgroundColor = .black
                                            cell.contentLabel.setTitleColor(.white, for: .normal)
                                            self.Fk_Agendas["\(row)\(column)"] = "0"
                                        } else {
                                            cell.contentLabel.backgroundColor = .white
                                            cell.contentLabel.setTitleColor(Theme.setColor(), for: .normal)
                                            self.Fk_Agendas["\(row)\(column)"] = "0" // I can book
                                        }
                                        
                                    } else if agenda["IsReserved"]?.bool == true {
                                        /*started if condition */
                                        self.Fk_Agendas["\(row)\(column)"] = "1" // can not book
                                        
                                        if self.bookingModel.timeWhichNeedsToBeUpdated == CellContentLabel  && self.bookingModel.dateWhichNeedsToBeUpdated == (agendaDate["Date"].string ?? "") && self.bookingModel.isModifyingPrograms == true {
                                            cell.contentLabel.backgroundColor = .black
                                            cell.contentLabel.setTitleColor(.white, for: .normal)
                                            self.Fk_Agendas["\(row)\(column)"] = "1"
                                        } else if agenda["IsOwner"]?.bool == true {
                                            cell.contentLabel.backgroundColor = .black
                                            cell.contentLabel.setTitleColor(.white, for: .normal)
                                        }else {
                                            cell.contentLabel.backgroundColor = Theme.setColor()
                                            cell.contentLabel.setTitleColor(.white, for: .normal)
                                        }
                                        
                                    }
                                    
                                    cell.configShadowContentLabel()
                                    
                                    cell.closure = {
                                        
                                        // if row != 0 {
                                        
                                            if let exist = self.Fk_Agendas["\(row)\(column)"], exist == "0"  {
                                                let agendaId = agenda["Id"]?.int ?? -1
                                                if self.bookingModel.FK_Agenda.contains(agendaId) {
                                                    self.bookingModel.FK_Agenda.remove(at: self.bookingModel.FK_Agenda.firstIndex(of: agendaId)!)
                                                    cell.contentLabel.backgroundColor = .white
                                                    cell.contentLabel.setTitleColor(Theme.setColor(), for: .normal)
                                                    
                                                }else {
                                                    if self.bookingModel.availableSessions > self.bookingModel.FK_Agenda.count {
                                                        self.bookingModel.FK_Agenda.append(agendaId)
                                                        cell.contentLabel.backgroundColor = .black
                                                        cell.contentLabel.setTitleColor(.white, for: .normal)
                                                    }else {
                                                        Alerts.DisplayActionSheetAlertWithButtonName(title: "You can't add more than  \(self.bookingModel.availableSessions) \(self.bookingModel.availableSessions == 1 ? "session" : "sessions")", message: "", object: self, actionType: .cancel, name: "OK")
                                                    }
                                                }
                                                
                                            }
                                        // } // end of row conditon
                                        
                                    } // END OF THE CLOSURE
                                    
                                }
                            }
                        }
                    }
                    
                }// end of the true if
            }
        }
        
        
        return cell
    }
    
}

// MARK: - UICollectionViewDelegate
extension traineeAgendaHomeViewController : UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == arrayOfDatesNames.count - 1 {
            self.arrowL.isHidden = false
            self.arrow.isHidden = true
        }else {
            self.arrowL.isHidden = true
            self.arrow.isHidden = false
        }
    }
    
    /* func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
       let column = indexPath.row
        let row = indexPath.section
        
        if row != current && agendaDates.count > 0 {
            current = row
        }
     
        
    }*/
   
}

//MARK:- UICollectionViewDelegateFlowLayout
extension traineeAgendaHomeViewController : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.size.width
        return CGSize(width: width, height: 800)
    }
    
}

