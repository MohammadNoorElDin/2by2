//
//  traineeAgendaHomeViewController.swift
//  trainee
//
//  Created by rocky on 12/13/18.
//  Copyright © 2018 personal. All rights reserved.
//

import UIKit
import SwiftyJSON

class traineeAgendaHomeViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var profileImage: UIButton!
    @IBOutlet weak var profileName: UILabel!
    @IBOutlet weak var allWeeksButtons: UIButton!
    @IBOutlet weak var weekByWeekButton: UIButton!
    @IBOutlet weak var arrowL: UIImageView!
    @IBOutlet weak var arrow: UIImageView!
    @IBOutlet weak var nextBtn: UIButton!
    
    let contentCellIdentifier: String = "ContentCellIdentifier"
    let ContentCollectionViewCell: String = "ContentCollectionViewCell"
    
    var arrayOfDates = [String]()
    var arrayOfDatesNames = [String]()
    var usedBefore: Bool = false  // INT : ROW [INT (COLUMN) ]
    
    var rows : Int = 1
    var agendaDates = [JSON]()
    var bookingModel: BookingDataModel!
    
    @IBOutlet var selectedWays: [UIButton]!
    
    var Fk_Agendas = [String: String]()
    var selectedWay: Int = 2 // manually else 1 (replicate)
    
    @IBAction func personsClicked(_ sender: UIButton) {
        selectedWays.forEach { (selectedWay) in
            if selectedWay.tag == sender.tag {
                selectedWay.setImage(UIImage(named: "radio-on-button"), for: .normal)
            }else {
                selectedWay.setImage(UIImage(named: "radio-off-button"), for: .normal)
            }
        }
        self.selectedWay = sender.tag
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dayNamesAndDates()
        collectionView.register(UINib(nibName: "ContentCollectionViewCell", bundle: nil),
                                forCellWithReuseIdentifier: contentCellIdentifier)
       
        let color = UIColor(rgb: 0xF7F7F7).withAlphaComponent(0.0)
        collectionView.layer.borderWidth = 10
        collectionView.layer.borderColor = color.cgColor
        
        if self.bookingModel.isFree == true {
            self.updateButtonInCaseIsFreeSession()
        }else if self.bookingModel.isModifyingPrograms == true {
            self.updateToModify()
        }
        
        if self.bookingModel.availableSessions == 1 {
            self.oneTimer()
        }
        
    }
    
    func updateButtonInCaseIsFreeSession() {
        self.nextBtn.setTitle("Enjoy your free session", for: .normal)
        self.nextBtn.titleLabel?.font = Theme.FontBold(size: 16)
        self.nextBtn.bounds.size.width = 320
        self.selectedWays.forEach { (btn) in
            btn.isHidden = true 
        }
    }
    
    func updateToModify() {
        self.nextBtn.setTitle("Confirm", for: .normal)
        self.nextBtn.titleLabel?.font = Theme.FontBold(size: 16)
        self.nextBtn.bounds.size.width = 320
    }
    
    func oneTimer() {
        self.selectedWays.forEach { (btn) in
            btn.isHidden = true
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.Fk_Agendas.removeAll()
        self.bookingModel.FK_Agenda.removeAll()
        displayProfileImage()
        fetchCoachDataHome()
        self.profileName.font = Theme.FontBold(size: 16)
        self.sideMenuController?.cacheViewController(withIdentifier: "traineesessionView", with: "trainee-session")
    }

    func displayProfileImage() {
        if self.bookingModel.coachImage.isEmpty == false {
            self.profileImage.findMe(url: self.bookingModel.coachImage)
            self.profileImage.radiusButtonImage()
        }
        self.profileName.text = self.bookingModel.coachName
    }
    
    @IBAction func openPaymentController(_ sender: UIButton) {
        
        guard self.bookingModel.FK_Agenda.count > 0 else {
            Alerts.DisplayActionSheetAlert(title: "", message: "You should choose at least one appointment", object: self, actionType: .default)
            return
        }
        
        if self.bookingModel.isModifyingPrograms == true {
            updateSchedule()
        } else if self.bookingModel.isFree == true {
            createReservation()
        } else {
            performSegue(withIdentifier: segueIdentifier.toConfrmPaymentController, sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == segueIdentifier.toConfrmPaymentController {
            if let dest = segue.destination as? ConfirmPaymentViewController {
                if self.selectedWay == 1 /* replicated */ {
                    self.bookingModel.isDuplicate = true
                }else if self.selectedWay == 2 {
                    self.bookingModel.isDuplicate = false
                }
                dest.bookingModel = self.bookingModel
            }
        }
    }
    
    func createReservation() {
        
        guard self.bookingModel.FK_Agenda.count > 0 else {
            Alerts.DisplayDefaultAlert(title: "", message: "add at least one Appointment", object: self, actionType: .default)
            return
        } // user add nothing
        
        let params = BookingDataModel.returnJsonRequest(object: self.bookingModel)
        print(params)
        
        ReservationCreateModel.AgendaCreateRequest(object: self, params: params) { (response, error) in
            if error == false {
                self.sideMenuController?.setContentViewController(with: "trainee-session")
            }
            
        }
    }
    
    func updateSchedule() {
        
        let params = [
            "Fk_Reservation": self.bookingModel.isModifyingFk_Reservation,
            "Fk_State": 5
        ] as [String: Any]
        
        if self.bookingModel.availableSessions == 1 {
            // EDIT
            let params = BookingDataModel.returnEditRequest(object: self.bookingModel)
            
            ReservationReservationsInfoModel.EditReservationsInfo.editReservation(object: self, params: params, completion: { (response, error) in
                if error == false {
                    self.navigationController?.popToRootViewController(animated: true)
                }
            })
            
        } else if self.bookingModel.isscheduling == true {
            
            let params = BookingDataModel.returnScheduleRequest(object: self.bookingModel)
            print(params)
            
            ReservationReservationsInfoModel.CreateReservationsInfo.createReservationInfo(object: self, params: params, completion: { (reponse, error) in
                
                if error == false {
                    self.navigationController?.popToRootViewController(animated: true)
                }
            })
            
        } else {
         
            ReservationReservationsInfoModel.DeleteReservationsByState.deleteReservationInfo(object: self, params: params) { (response, error) in
                //if error == false {
                    
                    // CREATE
                    let params = BookingDataModel.returnScheduleRequest(object: self.bookingModel)
                    print(params)
                    ReservationReservationsInfoModel.CreateReservationsInfo.createReservationInfo(object: self, params: params, completion: { (reponse, error) in
                        
                        if error == false {
                            self.navigationController?.popToRootViewController(animated: true)
                        }
                    })
                    
                /*} else {
                    print("NOTHING TO DELETE")
                }*/
                
            }
            
        }
        
        
    } // END OF THE FUNCTUON
    
}


