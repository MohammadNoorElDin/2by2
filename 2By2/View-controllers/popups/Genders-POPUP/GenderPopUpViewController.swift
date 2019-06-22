//
//  GenderPopUpViewController.swift
//  2By2
//
//  Created by mac on 11/1/18.
//  Copyright © 2018 personal. All rights reserved.
//

import UIKit

class GenderPopUpViewController: UIViewController {

    var genders: [GenderModel]? = nil
    var selectedGender : String = "Male"
    var selectedGenderId : Int = 0
    
    @IBOutlet weak var genderPickerView: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func confirmGender(_ sender: UIButton) {
        self.selectedGenderId = genderPickerView.selectedRow(inComponent: 0) + 1
        self.selectedGender =  self.genders![genderPickerView.selectedRow(inComponent: 0)].name
        NotificationCenter.default.post(name: .gender, object: self)
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func dismissView(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }

}

extension GenderPopUpViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return genders?.count ?? 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        let title = genders?[row].name
        return title
    }
    
    
}
