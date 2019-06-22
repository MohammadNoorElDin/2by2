//
//  FilterPOPUPViewController.swift
//  2By2
//
//  Created by rocky on 12/18/18.
//  Copyright © 2018 personal. All rights reserved.
//

import UIKit
import SwiftyJSON

class FilterPOPUPViewController: UIViewController {

    @IBOutlet weak var filterView: customDesignableView!
    @IBOutlet weak var dateSelected: UILabel!
    var bookingModel: BookingDataModel!
    
    @IBOutlet var genderTypes: [UIButton]!
    
    @IBOutlet var languageTypes: [UIButton]!
    
    @IBOutlet weak var nameTF:UITextField!
    
    var langauges = [1:1, 2:2]
    var genders = [1:1, 2:2]
    var date = Date()
    var coaches = [JSON]()
    var observer: NSObjectProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
  
        let tapGestureRecognizer1 = UITapGestureRecognizer(target: self, action: #selector(viewTapped(tapGestureRecognizer:)))
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(tapGestureRecognizer1)
        
        let tapGestureRecognizer2 = UITapGestureRecognizer(target: self, action: #selector(filterViewTapped(tapGestureRecognizer:)))
        filterView.isUserInteractionEnabled = true
        filterView.addGestureRecognizer(tapGestureRecognizer2)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
        self.observer = addCustomObserver(name: .agenda, completion: { (notification) in
            if let agenda = notification.object as? calenderViewController {
                self.dateSelected.text = Generate.formattingDate(date: (agenda.selectedDate ?? Date()), format: "YYYY-MM-DD")
                self.date = agenda.selectedDate ?? Date()
            }
        })
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        if let observer = observer {
            NotificationCenter.default.removeObserver(observer)
        }
    }
    
    @objc func viewTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        if tapGestureRecognizer.view == filterView {
            return
        }
        dismiss(animated: true, completion: nil)
    }
    
    @objc func filterViewTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        return
    }
    
    
    @IBAction func searchBtnClicked(_ sender: UIButton) {
        
        print(self.genders)
        print(self.langauges)
        print(self.dateSelected.text as Any)
        print(self.nameTF.text as Any)
        
        var params = [
            "Fk_BodyShapeGenderType": UserDataUsedThroughTheApp.Fk_BodyShapeGenderType,
            "Longitude": bookingModel.lngitude,
            "Latitude": bookingModel.latitude,
            "Fk_SecondCategoryProgram": bookingModel.Second_Category_Program
        ] as [String: Any]
        
        if self.genders.count == 1 {
            params["FK_Gender"] = Generate.generateIntKeysFromIntDictionary(dic: self.genders)[0]
        }else if self.genders.count > 1 {
            params["FK_Gender"] = Generate.generateIntKeysFromIntDictionary(dic: self.genders)
        }else if self.genders.count < 1 {
            
        }
        
        if self.langauges.count == 1 {
            params["FK_Languages"] = Generate.generateIntKeysFromIntDictionary(dic: self.langauges)[0]
        }else if self.langauges.count > 1 {
            params["FK_Languages"] = Generate.generateIntKeysFromIntDictionary(dic: self.langauges)
        }else if self.langauges.count < 1 {
            
        }
        
        if let name = self.nameTF.text, name.isEmpty == false {
            params["Name"] = name
        }
        
        if let date = dateSelected.text, date.isEmpty == false {
            params["Date"] =  Generate.formattingDate(date: self.date, format: "YYYY-MM-DD")
        }
        
        print(params)
        
        
        ReservationCoachsModel.GetCoachs.getCoachesToChooseFrom(object: self, params: params) { (response, error) in
            if error == false {
                if let coaches = response?["Data"].array {
                    self.coaches = coaches
                    NotificationCenter.default.post(name: .filter, object: self)
                    self.dismiss(animated: true)
                }
            }
        }
        
    }
    
    @IBAction func celenderBtnClicked(_ sender: UIButton) {
        let vc = PopusHandle.calenderViewController()
        present(vc, animated: true, completion: nil)
    }
    
    @IBAction func genderBtnsClicked(_ sender: UIButton) {
        
        let num = sender.tag - 1
        if genderTypes[num].currentImage == UIImage(named: "check-box") {
            genderTypes[num].setImage(UIImage(named: "un-check-box-gray"), for: .normal)
            self.genders[sender.tag] = nil
        } else {
            genderTypes[num].setImage(UIImage(named: "check-box"), for: .normal)
            self.genders[sender.tag] = sender.tag
        }
    }
    
    @IBAction func languageBtnsClicked(_ sender: UIButton) {
        let num = sender.tag - 1
        if languageTypes[num].currentImage == UIImage(named: "check-box") {
            languageTypes[num].setImage(UIImage(named: "un-check-box-gray"), for: .normal)
            self.langauges[sender.tag] = nil
        } else {
            languageTypes[num].setImage(UIImage(named: "check-box"), for: .normal)
            self.langauges[sender.tag] = sender.tag
        }
    }
    
}
