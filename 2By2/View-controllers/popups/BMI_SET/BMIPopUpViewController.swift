//
//  BMIPopUpViewController.swift
//  trainee
//
//  Created by rocky on 12/10/18.
//  Copyright © 2018 personal. All rights reserved.
//

import UIKit

class BMIPopUpViewController: UIViewController {

    @IBOutlet weak var bmiPickerView: UIPickerView!
    var bmis = [Int]()
    var selectedBMI: Int = 0
    var openOnNumber: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.bmiPickerView.selectRow(self.openOnNumber, inComponent: 0, animated: true)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.bmis.removeAll()
        self.openOnNumber = 0
    }
    
    @IBAction func confirmBtnClicked(_ sender: UIButton) {
        self.selectedBMI =  self.bmis[bmiPickerView.selectedRow(inComponent: 0)]
        NotificationCenter.default.post(name: .bmi, object: self)
        dismiss(animated: true)
    }

    @IBAction func cancelBtnClicked(_ sender: UIButton) {
        dismiss(animated: true)
    }
}


extension BMIPopUpViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return bmis.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        let title = String(bmis[row])
        return title
    }
    
    
}
