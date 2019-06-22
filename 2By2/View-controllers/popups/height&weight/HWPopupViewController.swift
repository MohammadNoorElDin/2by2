//
//  HWPopupViewController.swift
//  trainee
//
//  Created by rocky on 12/26/18.
//  Copyright © 2018 personal. All rights reserved.
//

import UIKit

class HWPopupViewController: UIViewController {

    @IBOutlet weak var pickerViewer: UIPickerView!
    
    var heights = [Int]()
    var weights = [Int]()
    var selectedWeight: Int = 0
    var selectedHeight: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        heights += 75...200
        weights += 35...200
        
        if self.selectedWeight != 0 {
            self.pickerViewer.selectRow(self.selectedWeight - 35, inComponent: 1, animated: true) // weight
            self.pickerViewer.selectRow(self.selectedHeight - 75 , inComponent: 0, animated: true) // height
        }
    }

    @IBAction func cancelClicked(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func confirmClicked(_ sender: UIButton) {
        let height = heights[pickerViewer.selectedRow(inComponent: 0)]
        let weight = weights[pickerViewer.selectedRow(inComponent: 1)]
        self.selectedHeight = height
        self.selectedWeight = weight
        dismiss(animated: true) {
            NotificationCenter.default.post(name: .hw, object: self)
        }
        
    }
    
}

extension HWPopupViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 { // heights
            return heights.count
        }else if component == 1 {
            return weights.count
        }
        return heights.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if component == 0 { // height
            return String(heights[row])
        } else {
            return String(weights[row])
        }
        
    }

}
