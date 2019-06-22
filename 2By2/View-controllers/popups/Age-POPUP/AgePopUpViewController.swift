//
//  AgePopUpViewController.swift
//  2By2
//
//  Created by mac on 11/1/18.
//  Copyright © 2018 personal. All rights reserved.
//

import UIKit

class AgePopUpViewController: UIViewController {

    @IBOutlet weak var genderPickerView: UIPickerView!
    
    var ages = [Int]()
    var selectedAge: Int = 0
    var startingFrom: Int = 0
    var heightChoosen: Int = 0 
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let to : Int = ( startingFrom == 0 ) ? 61 : 71
        let from : Int = ( startingFrom == 0 ) ? 20 : 7
    
        for index in stride(from: from , to: to, by: 1) {
            ages.append(index)
        }
    
    }
    
    
    @IBAction func confirmGender(_ sender: UIButton) {
        self.selectedAge =  self.ages[genderPickerView.selectedRow(inComponent: 0)]
        NotificationCenter.default.post(name: .age, object: self)
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func dismissView(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension AgePopUpViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return ages.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        let title = String(ages[row])
        return title
    }
    
    
}
