//
//  AboutTraineeViewController.swift
//  trainee
//
//  Created by Kamal on 12/11/18.
//  Copyright © 2018 personal. All rights reserved.
//

import UIKit

fileprivate let identifier = "toPickYourCoachSegue"

class AboutTraineeViewController: UIViewController {
    
    var bookingModel: BookingDataModel!
    
    @IBOutlet var ageGroupLabels: [UILabel]!
    @IBOutlet var levels: [UIButton]!
    @IBOutlet var ageGroups: [UIButton]!
   
    @IBOutlet var heightBtn: UIButton!
    @IBOutlet var weightBtn: UIButton!
    
    var observer: NSObjectProtocol?
    var weightOrheight: String = "weight"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        ReservationGetGroupsInfoModel.GetGroupsInfo(object: self) { (result, error) in
            if error == false {
                if let ag = result["AgeGroupRanges"]?.array {
                    for (index, item) in ag.enumerated() {
                        self.ageGroups[index].tag = item["Id"].int ?? index
                        self.ageGroups[index].setTitle( " \(item["Name"].string ?? "")", for: .normal)
                        let to = item["AgeTo"].int ?? 0
                        let from = item["AgeFrom"].int ?? 0
                        self.ageGroupLabels[index].text = "\(from) to \(to)"
                        
                        if from <= UserDataUsedThroughTheApp.userAge && to >= UserDataUsedThroughTheApp.userAge {
                            // then set this choosen by default ....
                            self.ageGroups[index].setImage(UIImage(named: "radio-on-button"), for: .normal)
                            self.bookingModel.ageGroup = item["Id"].int ?? index
                        }else {
                            self.ageGroups[index].setImage(UIImage(named: "radio-off-button"), for: .normal)
                        }
                        
                    }
                }
                
                if let le = result["Levels"]?.array {
                    for (index, item) in le.enumerated() {
                        
                        if index == 0 {
                            self.bookingModel.level = item["Id"].int ?? index
                        }else {
                            
                        }
                        
                        self.levels[index].tag = item["Id"].int ?? index
                        self.levels[index].setTitle( " \(item["Name"].string ?? "")", for: .normal)

                        // level .....
                    }
                }
                
            }
        } // end of the request
        
        if UserDataUsedThroughTheApp.height != 0 {
            self.heightBtn.setTitle("\(UserDataUsedThroughTheApp.height) ↓", for: .normal)
            self.weightBtn.setTitle("\(UserDataUsedThroughTheApp.weight) ↓", for: .normal)
        }else {
            
        }
        
        self.observer = addCustomObserver(name: .bmi, completion: { (notification) in
            if let vc = notification.object as? BMIPopUpViewController {
                if self.weightOrheight == "weight" {
                    self.weightBtn.setTitle("\(vc.selectedBMI) ↓", for: .normal)
                    self.bookingModel.weight = vc.selectedBMI
                }else {
                    self.heightBtn.setTitle("\(vc.selectedBMI) ↓", for: .normal)
                    self.bookingModel.height = vc.selectedBMI
                }
            }
        })
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if let observer = observer {
            NotificationCenter.default.removeObserver(observer)
        }
    }
    
    @IBAction func weightClicked(_ sender: CustomDesignableButton) {
        self.weightOrheight = "weight"
        let tab = PopusHandle.openBMIPopup()
        let from = 35
        for index in stride(from: from, to: 225, by: 1) {
            tab.bmis.append(index)
        }
        if UserDataUsedThroughTheApp.weight != 0 {
            tab.openOnNumber = UserDataUsedThroughTheApp.weight - from
        }else {
            tab.openOnNumber = 75
        }
        
        present(tab, animated: true, completion: nil)
    }
    
    @IBAction func heightClicked(_ sender: UIButton) {
        
        let tab = PopusHandle.openBMIPopup()
        let from = 35
        for index in stride(from: from, to: 225, by: 1) {
            tab.bmis.append(index)
        }
        if UserDataUsedThroughTheApp.height != 0 {
            tab.openOnNumber = UserDataUsedThroughTheApp.height - from
        }else {
            tab.openOnNumber = 75
        }
        self.weightOrheight = "height"
        present(tab, animated: true, completion: nil)
        
    }
    
    @IBAction func ChoosenLevel(_ sender: UIButton) {
        self.levels.forEach { (btn) in
            if btn.tag == sender.tag {
                btn.setImage(UIImage(named: "radio-on-button"), for: .normal)
                self.bookingModel.level =
                    sender.tag
            }else{
                btn.setImage(UIImage(named: "radio-off-button"), for: .normal)
            }
        }
    }
    
    @IBAction func ChoosenAgeGroup(_ sender: UIButton) {
        self.ageGroups.forEach { (btn) in
            if btn.tag == sender.tag {
                btn.setImage(UIImage(named: "radio-on-button"), for: .normal)
                self.bookingModel.ageGroup = btn.tag
            }else{
                btn.setImage(UIImage(named: "radio-off-button"), for: .normal)
            }
        }
    }
    
    @IBAction func readyClicked(_ sender: UIButton) {
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == identifier {
            if let dest = segue.destination as? PickYourCoachViewController {
                if self.bookingModel.height != 0 {
                    // already setted
                }else {
                    self.bookingModel.height = UserDataUsedThroughTheApp.height
                }
                
                if self.bookingModel.weight != 0 {
                    // already setted
                }else {
                    self.bookingModel.weight = UserDataUsedThroughTheApp.weight
                }
                
                // SET LEVEL IN BOOKINGMOEL FIRST
                dest.bookingModel = self.bookingModel
            }
        }
    }
    
}
