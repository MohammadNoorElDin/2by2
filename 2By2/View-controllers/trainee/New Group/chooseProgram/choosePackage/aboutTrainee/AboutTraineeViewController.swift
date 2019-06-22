//
//  AboutTraineeViewController.swift
//  trainee
//
//  Created by Kamal on 12/11/18.
//  Copyright © 2018 personal. All rights reserved.
//

import UIKit

class AboutTraineeViewController: UIViewController {
    
    let nib_identefire_level = "LevelTableViewCell"
    
    @IBOutlet weak var ageGroupTV: UITableView!
    @IBOutlet weak var levelTV: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
}

extension AboutTraineeViewController:UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: nib_identefire_level, for: indexPath) as! LevelTableViewCell
        return cell
    }
}
