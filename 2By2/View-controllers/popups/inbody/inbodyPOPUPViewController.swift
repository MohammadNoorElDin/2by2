//
//  inbodyPOPUPViewController.swift
//  2By2
//
//  Created by rocky on 2/1/19.
//  Copyright © 2019 personal. All rights reserved.
//

import SwiftyJSON
import UIKit

fileprivate var current: Int = 0

class inbodyPOPUPViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var localView: customDesignableView!
    
    let contentCellIdentifier: String = "ContentCellIdentifier"
    let ContentCollectionViewCell: String = "ContentCollectionViewCell"
    
    var arrayOfDates = [String]()
    var arrayOfDatesNames = [String]()
    var usedBefore: Bool = false  // INT : ROW [INT (COLUMN) ]
    
    var rows : Int = 1
    var agendaDates = [JSON]()
    var rowCloumn = [String:Int]()
    var Fk_Agendas = [String: String]()
    var Fk_Inbody : Int = 0
    var Fk_Gift: Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        dayNamesAndDates()
        
        collectionView.register(UINib(nibName: "ContentCollectionViewCell", bundle: nil),
                                forCellWithReuseIdentifier: contentCellIdentifier)
        
        // collectionView.allowsSelection = false
        let color = UIColor(rgb: 0xF7F7F7).withAlphaComponent(0.0)
        
        collectionView.layer.borderWidth = 10
        collectionView.layer.borderColor = color.cgColor
        
        
        let tapGestureRecognizer1 = UITapGestureRecognizer(target: self, action: #selector(viewTapped(tapGestureRecognizer:)))
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(tapGestureRecognizer1)
        
        let tapGestureRecognizer2 = UITapGestureRecognizer(target: self, action: #selector(filterViewTapped(tapGestureRecognizer:)))
        localView.isUserInteractionEnabled = true
        localView.addGestureRecognizer(tapGestureRecognizer2)
        
    }
    
    @objc func viewTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        if tapGestureRecognizer.view == localView {
            return
        }
        dismiss(animated: true, completion: nil)
    }
    
    @objc func filterViewTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        return
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.fetchCoachDataHome()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        self.rowCloumn.removeAll()
    }
}



extension inbodyPOPUPViewController {
    
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
        
        InbodyModel.GetInbodySessions(object: self) { (response, error) in
            if error == false {
                if let rows = response["RowMax"]?.int {
                    self.rows = rows + 1
                }
                if let agenda = response["InbodyDates"]?.array {
                    self.agendaDates = agenda
                    self.collectionView.reloadData()
                }
            } // END OF ELSE
        }
    }
    
    //MARK:- THR FIFTH ONE (dayNamesAndDates)
    func dayNamesAndDates() {
        arrayOfDates = Generate.return30DaysInDates2()
        arrayOfDatesNames = Generate.return30DaysInNames()
    }
    
}


// MARK: - UICollectionViewDataSource
extension inbodyPOPUPViewController: UICollectionViewDataSource {
    
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
                    
                    if let agendas = agendaDate["DaySessions"].array {
                        if ( row - 1 ) < agendas.count {
                            if let agenda = agendas[ row - 1 ].dictionary {
                                
                                if let time = agenda["Time"]?.dictionary {
                                    var hour = (time["Hours"]?.int)!
                                    let minute = (time["Minutes"]?.int)!
                                    /*let meridiem = (hour >= 12 && minute > 0) ? "PM" : "AM"
                                    hour = (hour > 12) ? ( hour - 12 ) : hour*/
                                    
                                    let CellContentLabel = "\(Generate._24hours(int: hour)):\(Generate.twoDigit(int: minute))"
                                    
                                    cell.configCell(content: CellContentLabel, date: nil)
                                    
                                    if agenda["IsReserved"]?.bool == false {
                                        cell.setColorToDefault()
                                        self.Fk_Agendas["\(row)\(column)"] = "0"
                                    }else if agenda["IsReserved"]?.bool == true {
                                        if agenda["IsOwner"]?.bool == true {
                                            cell.setColorToBlack()
                                        }else {
                                            cell.setColorToWhite()
                                        }
                                        self.rowCloumn["\(row)\(column)"] = column
                                        self.Fk_Agendas["\(row)\(column)"] = "1"
                                    }
                                    
                                    cell.configShadowContentLabel()
                                    
                                }
                                
                                cell.closure = { // closure
                                    
                                    if let exist = self.Fk_Agendas["\(row)\(column)"], exist == "0"  {
                                        if let agendaId = agenda["Id"]?.int {
                                            if self.Fk_Inbody == agendaId {
                                                self.Fk_Inbody = 0
                                                cell.setColorToDefault()
                                            }else if self.Fk_Inbody != 0 {
                                                Alerts.DisplayDefaultAlert(title: "", message: "You can not choose more than one", object: self, actionType: .default)
                                            } else {
                                                self.Fk_Inbody = agendaId
                                                cell.setColorToBlack()
                                            }
                                        }
                                    }
                                    
                                } // end of the closure
                                
                            }
                        }
                    }
                    
                }// end of the true if
                
                
            } // end of the for loop
            
        } // end of the else statement ..
        
        return cell
    }
    
    
    @IBAction func confirm(_ sender: UIButton) {
        
        guard self.Fk_Inbody != 0 && self.Fk_Gift != 0 else {
            Alerts.DisplayDefaultAlert(title: "", message: "Choose at least one appoitment", object: self, actionType: .default)
            return
        }
        
        let params = [
            "FK_User": UserDataUsedThroughTheApp.userId,
            "FK_Gift": self.Fk_Gift,
            "Fk_Inbody": self.Fk_Inbody
        ] as [String: Any]
        
        InbodyModel.AddUserInbody.AddUserInbody(object: self, params: params) { (response, error) in
            if error == false {
                
                self.dismiss(animated: true, completion: {
                    NotificationCenter.default.post(name: .inbody, object: self)
                })
            }
        }
    }
    
}


//MARK:- UICollectionViewDelegateFlowLayout
extension inbodyPOPUPViewController : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.size.width
        return CGSize(width: ( width + 100 ), height: 800)
    }
    
}

