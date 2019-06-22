//
//  PickYourCoachViewController.swift
//  trainee
//
//  Created by Kamal on 12/12/18.
//  Copyright © 2018 personal. All rights reserved.
//
//
import UIKit
import SwiftyJSON

class PickYourCoachViewController: UIViewController {
    
    let nib_identefire_coaches = "PickYourCoachCollectionViewCell"
    @IBOutlet weak var pickCoachCV: UICollectionView!
    @IBOutlet weak var filterBtn: UIButton!
    @IBOutlet weak var sortBtn: UIButton!
    
    var coaches = [JSON]()
    var sortOptions: [String: UIAlertAction.Style] = ["ASCE": .default, "DESC": .default, "RATE": .default, "CANCEL": .cancel]
    
    var bookingModel: BookingDataModel!
    var observerPicked: NSObjectProtocol!
    var observerFilter: NSObjectProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        filterBtn.setImageColor(color: Theme.setColor())
        sortBtn.setImageColor(color: Theme.setColor())
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == segueIdentifier.toChoosenCoachViewController {
            if let dest = segue.destination as? traineeAgendaHomeViewController {
                dest.bookingModel = self.bookingModel
            }
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.observerPicked = addCustomObserver(name: .picked) { (notification) in
            if let vc = notification.object as? coachesSliderPOPUPViewController {
                if let id = vc.pickedCoach?["Id"]?.int {
                    self.bookingModel.coachId = id
                    self.bookingModel.coachName = vc.pickedCoach?["Name"]?.string ?? ""
                    self.bookingModel.coachImage = vc.pickedCoach?["Image"]?.string ?? ""
                    self.performSegue(withIdentifier: segueIdentifier.toChoosenCoachViewController, sender: self)
                }
            }
        }
        
        self.observerFilter = addCustomObserver(name: .filter, completion: { (notification) in
            if let vc = notification.object as? FilterPOPUPViewController {
                self.coaches = vc.coaches
                print(vc.coaches)
                self.pickCoachCV.reloadData()
            }
        })
        
        var params = [
            ReservationCoachsModel.GetCoachs.params.Latitude: self.bookingModel.latitude,
            ReservationCoachsModel.GetCoachs.params.Longitude: self.bookingModel.lngitude,
            ReservationCoachsModel.GetCoachs.params.Fk_BodyShapeGenderType: UserDataUsedThroughTheApp.Fk_BodyShapeGenderType
            ] as [String: Any]
        
        if self.bookingModel.isModifyingFk_SecondCategoryProgram != 0 {
            params[ReservationCoachsModel.GetCoachs.params.Fk_SecondCategoryProgram] = self.bookingModel.isModifyingFk_SecondCategoryProgram
        }else {
            params[ReservationCoachsModel.GetCoachs.params.Fk_SecondCategoryProgram] = self.bookingModel.Second_Category_Program
        }
        
        ReservationCoachsModel.GetCoachs.getCoachesToChooseFrom(object: self, params: params) { (response, error) in
            if error == false {
                if let coaches = response?["Data"].array {
                    self.coaches = coaches
                    self.pickCoachCV.reloadData()
                }
            }
        }
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        
        if let observerFilter = observerFilter {
            NotificationCenter.default.removeObserver(observerFilter)
        }
        
        if let observerPicked = observerPicked {
            NotificationCenter.default.removeObserver(observerPicked)
        }
    }
    
}

extension PickYourCoachViewController:UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return coaches.count ?? 0
    }/**/
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: nib_identefire_coaches, for: indexPath) as! PickYourCoachCollectionViewCell
        
        let num = indexPath.row
        
        if let coach = coaches[num].dictionary {
            if let name = coach["Name"]?.string {
                cell.coachNameButton.setTitle(name, for: .normal)
            }
            if let rate = coach["Rate"]?.double {
                if rate.isIntVal == true {
                    cell.starLabel.text = String(Int(rate))
                }else {
                    cell.starLabel.text = String(rate)
                }
            }else {
                cell.starLabel.text = "5"
            }
            
            if let image = coach["Image"]?.string {
                cell.coachbutton.findMe(url: image)
                cell.coachbutton.radiusButtonImage()
            }else {
                cell.coachbutton.setImage(UIImage(named: "default_avatar"), for: .normal)
                cell.coachbutton.radiusButtonImage()
            }
            
        }
        
        cell.closure = {
            let slider = PopusHandle.CoachSliderPopupViewController()
            slider.coaches = self.coaches
            slider.openOnIndex = indexPath.row
            self.present(slider, animated: true, completion: nil)
        }
        
        return cell
    }
    
    
    @IBAction func sortClicked(_ sender: UIButton) {
        Alerts.DisplayActionSheetAlertWithActions(title: "SORT COACHES", message: "asc, desc", object: self, buttons: sortOptions, actionType: .default) { (action) in
            var response = [JSON]()
            if action == "ASCE" {
                response = self.coaches.sorted { $0["Id"].intValue < $1["Id"].intValue }
            } else if action == "DESC" {
                response = self.coaches.sorted { $0["Id"].intValue > $1["Id"].intValue }
            }else if action == "RATE" {
                response = self.coaches.sorted { $0["Age"].intValue > $1["Age"].intValue }
            }
            if action != "CANCEL" {
                self.coaches = response
            }
            self.pickCoachCV.reloadData()
        }
    }
    
    @IBAction func filterClicked(_ sender: UIButton) {
        let filter = PopusHandle.FilterPOPUPViewController()
        filter.bookingModel = self.bookingModel
        present(filter, animated: true, completion: nil)
    }
    
    func printCoachesNames() {
        coaches.forEach({ (coach) in
            if let coach = coach.dictionary {
                if let name = coach["Name"]?.string {
                    print("coach name is : \(name)")
                }
            }
        })
    }
    
    
    
}

extension PickYourCoachViewController: UICollectionViewDelegate , UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let slider = PopusHandle.CoachSliderPopupViewController()
        self.present(slider, animated: true, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 100, height: 120)
    }
    
}

extension FloatingPoint {
    var isInt: Bool {
        return floor(self) == self
    }
}
