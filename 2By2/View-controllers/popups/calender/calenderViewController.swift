//
//  calenderViewController.swift
//  2By2
//
//  Created by rocky on 12/18/18.
//  Copyright © 2018 personal. All rights reserved.
//

import UIKit

class calenderViewController: UIViewController {

    @IBOutlet weak var datePickerView: UIDatePicker!
    var selectedDate: Date? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        datePickerView.minimumDate = Date()
        datePickerView.timeZone = TimeZone.current
        datePickerView.maximumDate = Calendar.current.date(byAdding: .day, value: +30, to: Date())

    }
    
    @IBAction func confirmGender(_ sender: UIButton) {
        self.selectedDate = datePickerView.date
        NotificationCenter.default.post(name: .agenda, object: self)
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func dismissView(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}
