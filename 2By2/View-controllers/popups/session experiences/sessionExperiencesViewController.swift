//
//  sessionExperiencesViewController.swift
//  2By2
//
//  Created by rocky on 1/13/19.
//  Copyright © 2019 personal. All rights reserved.

import UIKit

class sessionExperiencesViewController: UIViewController {
    
    @IBOutlet weak var LocationsTV: UITableView!
    @IBOutlet weak var defLabel: UILabel!
    @IBOutlet weak var rateView: customDesignableView!
    
    var Locations = [LocationsModel]()
    
    let locations_nib_identifier = "sessionExperiencesTableViewCell"
    
    var Fk_ReservationInfo: Int!
    var arr = [String]()
    var params: [String:Any]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerTable(tableView: LocationsTV, nib_identifier: locations_nib_identifier)
        self.getLocations()
        
        let tapGestureRecognizer1 = UITapGestureRecognizer(target: self, action: #selector(viewTapped(tapGestureRecognizer:)))
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(tapGestureRecognizer1)
        
        let tapGestureRecognizer2 = UITapGestureRecognizer(target: self, action: #selector(rateViewTapped(tapGestureRecognizer:)))
        rateView.isUserInteractionEnabled = true
        rateView.addGestureRecognizer(tapGestureRecognizer2)
        
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
    
    func getLocations() {
        
        let params = [
            "Fk_ReservationInfo" : self.Fk_ReservationInfo
        ] as [String: Any]
        
        ReservationCreateAdditionalCategoriesModel.getRequest(object: self, params: params) { (response, error) in
            if error == false {
                if let locations = response?["Data"].array {
                    self.Locations.removeAll()
                    locations.forEach({ (location) in
                        if let name = location["Name"].string, let id = location["Id"].int {
                            let locationModel = LocationsModel(id: id, name: name)
                            self.Locations.append(locationModel)
                        }
                    })
                    self.LocationsTV.reloadData()
                    
                }
            }
        }
        
    }
    
    @IBAction func confirmClicked(_ sender: UIButton) {
        
        var str: String = ""
        Locations.forEach { (location) in
            if location.selected == true {
                str += "- \(location.name)\n"
            }
        }
        
        guard str != "" else {
            Alerts.DisplayDefaultAlert(title: "", message: "At least choose one exercise", object: self, actionType: .default)
            return
        }
        
        let params = [
            "Fk_ReservationInfo" : Int(self.Fk_ReservationInfo),
            "AdditionalCategoryNames": str
        ] as [String: Any]
        print(params)
        
        ReservationCreateAdditionalCategoriesModel.postRequest(object: self, params: params) { (response, error ) in
            if error == false {
                self.dismiss(animated: true, completion: {
                    NotificationCenter.default.post(name: .sessionExp, object: self)
                })
            }
        }
        
    }
    
}

extension sessionExperiencesViewController: UITableViewDataSource , UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Locations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: locations_nib_identifier, for: indexPath) as! sessionExperiencesTableViewCell
        
        let num = ( indexPath.row )
        
        let lh = Locations[num]
        cell.configCell(name: lh.name, checked: lh.selected, tag: lh.id)
        
        cell.closure = { [weak self] in
            self?.Locations[num].selected =  (self?.Locations[num].selected == true) ? false : true
            cell.configCell(name: lh.name, checked: lh.selected, tag: lh.id)
            self?.writeTheDef()
        }
        
        return cell
    }
    
    func writeTheDef() {
        var str: String = ""
        Locations.forEach { (location) in
            if location.selected == true {
                str += "- \(location.name), "
            }
        }
        self.defLabel.text = "Selected Exercises " + str
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 30
    }
    
}

