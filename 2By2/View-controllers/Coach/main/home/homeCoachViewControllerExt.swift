//
//  homeCoachViewControllerExt.swift
//  2By2
//
//  Created by rocky on 11/13/18.
//  Copyright © 2018 personal. All rights reserved.
//

import UIKit
import SwiftyJSON

fileprivate var current: Int = 0

extension homeCoachViewController {
    
    /*
     || ==============================================================
     || FOUR FUCTION ARE HERE
     || ==============================================================
     || 1- fetchCoachDateHome [ FETCH AGENDA DATA ]
     || 1- fetchCoachProfileData [ FETCH PROFILE DATA ]
     || 3- configNavigation [ NAVIGATIONCONTROLLER CUSTOMIZATION ]
     || 4- formattingDate [ CUSTOMIZE DATE ]
     || 5- sideMenuWorsks [ NOTIFICATIONCENTER >> SIDE MENU WORKING ]
     || 6- message in the top of the header
     */
    
    //MARK:- THR FIRST ONE (fetchCoachDataHome)
    func fetchCoachDataHome(){
        
        let params = [ CoachHomeModel.Params.Fk_Coach: CoachDataUsedThroughTheApp.coachId ]
        
        CoachHomeModel.CoachHomeRequest(object: self, params: params) { (response, error) in
            if error == true {
                
                return
            } else {
                // DATA RETURNED
                
                if let rows = response["RowMax"]?.int {
                    self.rows = rows + 1
                    self.collectionView.reloadData()
                }
                
                if let agenda = response["AgendaDates"]?.array {
                    self.agendaDates = agenda
                }
                
                if let notification = response["Notification"]?.dictionary {
                    if let Priority = notification["Priority"]?.int, Priority == 100 {
                        if let desc = notification["Description"]?.string {
                            self.notification2By2.isHidden = true
                            self.notificationDesc.text = desc
                        }
                    }
                }
                
            } // END OF ELSE
        }
    }
    
    //MARK:- THR FIFTH ONE (dayNamesAndDates)
    func dayNamesAndDates() {
        arrayOfDates = Generate.return30DaysInDates()
        arrayOfDatesNames = Generate.return30DaysInNames()
    }
    
    //MARK:- THR SIXTH ONE ( MESSAGE )
    func displayMessage() {
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 6..<12 :
            self.notificationShift.text = "Good Morning,"
            break
        case 12 :
            self.notificationShift.text = "Good Noon,"
            break
        case 13..<17 :
            self.notificationShift.text = "Good Afternoon,"
            break
        case 17..<24 :
            self.notificationShift.text = "Good Evening,"
            break
        default:
            self.notificationShift.text = "Good Morning,"
            break
        }
        self.notificationCoachName.text = CoachDataUsedThroughTheApp.coachFullName
    }
    
}


// MARK: - UICollectionViewDataSource
extension homeCoachViewController: UICollectionViewDataSource {
    
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
            cell.backgroundColor = UIColor(rgb: 0xE7E7E7).withAlphaComponent(1)
            cell.isUserInteractionEnabled = false
            
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
                                    
                                    if agenda["IsReserved"]?.bool == false {
                                        cell.setColorToDefault()
                                    }else if agenda["IsReserved"]?.bool == true {
                                        self.rowCloumn["\(row)\(column)"] = column
                                        cell.setColorToWhite()
                                    }
                                    
                                    cell.configShadowContentLabel()
                                    
                                }
                            }
                        }
                    }
                    
                }// end of the true if
                
                cell.closure = { // closure
                    if let keyExists = self.rowCloumn["\(row)\(column)"], keyExists == column {
                        self.sideMenuController?.hideMenu(animated: true, completion: { (status) in
                            if status == true {
                                self.sideMenuController?.setContentViewController(with: "coach-session")
                            }
                        })
                    } else {
                        self.sideMenuController?.hideMenu(animated: true, completion: { (status) in
                            if status == true {
                                self.sideMenuController?.setContentViewController(with: "coach-agenda")
                            }
                        })
                    }
                } // end of the closure
                
            } // end of the for loop
            
        } // end of the else statement ..
        
        return cell
    }
    
}

extension homeCoachViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if self.agendaDates.count <= 0 {
            self.sideMenuController?.setContentViewController(with: "coach-agenda")
        }
    }
}

//MARK:- UICollectionViewDelegateFlowLayout
extension homeCoachViewController : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.size.width
        return CGSize(width: width, height: 800)
    }
    
}
