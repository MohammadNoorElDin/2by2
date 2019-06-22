//
//  PackageViewController.swift
//  trainee
//
//  Created by Kamal on 12/9/18.
//  Copyright © 2018 personal. All rights reserved.
//

import UIKit

class PackageViewController: UIViewController {

    let nib_identefire_persons = "PersonsTableViewCell"
    let nib_identefire_package = "PackageTableViewCell"

    @IBOutlet weak var selectPersonsTV: UITableView!
    @IBOutlet weak var packageDataTV: UITableView!
    
    @IBOutlet weak var workoutBuddiesTV: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        registerTable(tableView: selectPersonsTV, nib_identifier: nib_identefire_persons)
        registerTable(tableView: packageDataTV, nib_identifier: nib_identefire_package)
    }
}

extension PackageViewController:UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView.tag == 0 {
            return 2
        }else{
            return 3
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView.tag == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: nib_identefire_persons
                , for: indexPath) as! PersonsTableViewCell
            cell.backgroundColor = UIColor.clear
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: nib_identefire_package
                , for: indexPath) as! PackageTableViewCell
            cell.backgroundColor = UIColor.clear
            return cell
        }
    }
}
