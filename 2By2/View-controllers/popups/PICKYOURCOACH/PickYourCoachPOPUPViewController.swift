//
//  PickYourCoachViewController.swift
//  2By2
//
//  Created by rocky on 12/11/18.
//  Copyright © 2018 personal. All rights reserved.
//

import UIKit

class PickYourCoachPOPUPViewController: UIViewController {

    
    @IBOutlet weak var pickerViewPV: UIPickerView!
    var pickPOPUP = [Int]()
    var selectedNumber: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func confirmBtnClicked(_ sender: UIButton) {
        self.selectedNumber =  self.pickPOPUP[pickerViewPV.selectedRow(inComponent: 0)]
        NotificationCenter.default.post(name: .pickPOPUP, object: self)
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func cancelmBtnClicked(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}


extension PickYourCoachPOPUPViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickPOPUP.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        let title = String(pickPOPUP[row])
        return title
    }
    
    
}
