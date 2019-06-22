//
//  agendPopupViewController.swift
//  2By2
//
//  Created by rocky on 11/17/18.
//  Copyright © 2018 personal. All rights reserved.
//

import UIKit

class agendaPopupViewController: UIViewController {

    @IBOutlet weak var rateView: customDesignableView!
    @IBOutlet weak var fromPV: UIDatePicker!
    @IBOutlet weak var toPV: UIDatePicker!
    
    var timeFrom : String = ""
    var timeto : String = ""
    var choosenDate: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.fromPV.tintColor = UIColor(rgb: 0xA32F1C)
        
        let tapGestureRecognizer1 = UITapGestureRecognizer(target: self, action: #selector(viewTapped(tapGestureRecognizer:)))
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(tapGestureRecognizer1)
        
        let tapGestureRecognizer2 = UITapGestureRecognizer(target: self, action: #selector(rateViewTapped(tapGestureRecognizer:)))
        rateView.isUserInteractionEnabled = true
        rateView.addGestureRecognizer(tapGestureRecognizer2)
        
        
        fromPV.addTarget(self, action: #selector(timeChangedFrom(_:)), for: .allEvents)
        toPV.addTarget(self, action: #selector(timeChangedTo(_:)), for: .allEvents)
        updateToDate()
        updateToPV()
    }
    
    @objc func timeChangedFrom(_ sender: UIDatePicker) {
        let components = Calendar.current.dateComponents([.hour, .minute], from: sender.date)
        if let hour = components.hour, let minute = components.minute {
            let currentHour = Calendar.current.component(.hour, from: Date())
            let today = Generate.formattingDate(date: Date(), format: "MM/dd/yyyy")
            if today == self.choosenDate {
                
                if currentHour > hour {
                    let calendar = Calendar.current
                    var newcomponents = DateComponents()
                    newcomponents.hour = currentHour
                    newcomponents.minute = 0
                    fromPV.setDate(calendar.date(from: newcomponents)!, animated: false)
                    return
                }
            }
            if today != self.choosenDate {
                let hour = hour < 10 ? "0\(hour)" : "\(hour)"
                let minute = minute < 10 ? "0\(minute)" : "\(minute)"
                self.timeFrom = "\(hour):\(minute)"
            }else {}
            updateToPV()
        }
    }
    
    @objc func timeChangedTo(_ sender: UIDatePicker) {
        if sender.date <= fromPV.date {
            updateToPV()
        }
    }
    
    @objc func viewTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        if tapGestureRecognizer.view == rateView {
            return
        }
        dismiss(animated: true, completion: nil)
    }
    
    @objc func rateViewTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        return
    }
 
    @IBAction func setButtonClicked(_ sender: UIButton) {
        self.timeto = returnTime(sender: toPV)!
        self.timeFrom = returnTime(sender: fromPV)!
        self.dismiss(animated: true) {
            NotificationCenter.default.post(name: .coachSetagenda, object: self)
        }
    }
    
    func returnTime(sender: UIDatePicker) -> String? {
        let components = Calendar.current.dateComponents([.hour, .minute], from: sender.date)
        if let hour = components.hour, let minute = components.minute {
            let hour = hour < 10 ? "0\(hour)" : "\(hour)"
            let minute = minute < 10 ? "0\(minute)" : "\(minute)"
            return "\(hour):\(minute)"
        }
        return nil
    }
    
    func updateToDate() {
        let components = Calendar.current.dateComponents([.hour, .minute], from: fromPV.date)
        if let hour = components.hour, let minute = components.minute {
            customUpdateFunc(hour: hour, minute: minute, sender: fromPV)
        }
    }
    
    func updateToPV() {
        let components = Calendar.current.dateComponents([.hour, .minute], from: fromPV.date)
        if let hour = components.hour, let minute = components.minute {
            customUpdateFunc(hour: hour, minute: minute, sender: toPV)
        }
    }
    
    func customUpdateFunc(hour: Int, minute: Int, sender: UIDatePicker) {
        let calendar = Calendar.current
        var components = DateComponents()
        
        components.hour = hour + 1
        components.minute = 0
        if sender == fromPV {
            fromPV.setDate(calendar.date(from: components)!, animated: false)
        }else {
            toPV.setDate(calendar.date(from: components)!, animated: false)
        }
    }
    
    func returnHour(sender: UIDatePicker) -> Int {
        let components = Calendar.current.dateComponents([.hour], from: sender.date)
        if let hour = components.hour {
            return hour
        }
        return 0
    }
    
    func returnMinute(sender: UIDatePicker) -> Int {
        let components = Calendar.current.dateComponents([.minute], from: sender.date)
        if let minute = components.minute {
            return minute
        }
        return 0
    }
    
}
