//
//  measurementsViewController.swift
//  trainee
//
//  Created by rocky on 11/23/18.
//  Copyright © 2018 personal. All rights reserved.
//

import UIKit
import SwiftyJSON
import ImageSlideshow

class measurementsViewController: UIViewController {

    @IBOutlet weak var measurementTV: UITableView!
    var imageSlideShow = ImageSlideshow()
    
    let nib_identifier = "measurementsTableViewCell"
    let nib_identifier_sperator = "separatorCellTableViewCell"
    
    var measurements = [JSON]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerTable(tableView: measurementTV, nib_identifier: nib_identifier)
        registerTable(tableView: measurementTV, nib_identifier: nib_identifier_sperator)
    }
    
    func configCell() {
        measurementTV.separatorInset = .zero
        measurementTV.contentInset = .zero
        measurementTV.allowsSelection = false
        measurementTV.tableFooterView = UIView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        
        UserMeasurementsModel.UserGetMeasurementsRequest(object: self) { (measurements, error) in
            if error == true {
                // ERROR HAPPENS
                Alerts.DisplayActionSheetAlert(title: "", message: "No Gifts", object: self, actionType: .default)
                
                return
            }else {
                
                if let Data = measurements {
                    if let measurements = Data["Data"].array {
                        self.measurements = measurements
                        self.measurementTV.reloadData()
                    }
                }
            }
            
        }
    }

}

extension measurementsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.measurements.count * 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row % 2 == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: nib_identifier, for: indexPath) as! measurementsTableViewCell
            
            let num = indexPath.row / 2
            
            if let measurement = measurements[num].dictionary {
                if let fat = measurement["Fat"]?.int {
                    cell.FatLabel.text = String(fat)
                }
                if let mucles = measurement["Muscles"]?.int {
                    cell.musclesLabel.text = String(mucles)
                }
                if let Weight = measurement["Weight"]?.int {
                    cell.weightLabel.text = String(Weight)
                }
            
                // full report clicked
                cell.closure = { [weak self] in
                    if let self = self {
                        if let image = measurement["ImageUrl"]?.string , image.isEmpty == false {
                            self.imageSlideShow.setImageInputs([
                                SDWebImageSource(urlString: image)!
                            ])
                            self.imageSlideShow.presentFullScreenController(from: self)
                        }
                    } // end of self unwrapping 
                } // end of the closure ...!!!
                
            }
            
            return cell
        }else {
            let cell = tableView.dequeueReusableCell(withIdentifier: nib_identifier_sperator, for: indexPath) as! separatorCellTableViewCell
            return cell
        }
    }
    
    @IBAction func openSideMenu(_ sender: Any) {
        self.sideMenuController?.revealMenu()
    }
}

extension measurementsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row % 2 == 0 {
            return 140
        }
        return 10
    }
}
