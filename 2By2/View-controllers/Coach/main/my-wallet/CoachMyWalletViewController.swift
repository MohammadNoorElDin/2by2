//
//  CoachMyWalletViewController.swift
//  2By2
//
//  Created by rocky on 11/13/18.
//  Copyright © 2018 personal. All rights reserved.
//

import UIKit
import SwiftyJSON
import SideMenuSwift

class CoachMyWalletViewController: UIViewController {

    @IBOutlet weak var walletTV: UITableView!
    @IBOutlet weak var SessionsCount: UILabel!
    @IBOutlet weak var TotalCredit: UILabel!
    @IBOutlet weak var TotalPending: UILabel!
    @IBOutlet weak var DueDate: UILabel!
    
    let nib_identifier = "coachWalletTableViewCell"
    let nib_identifier_sperator = "separatorCellTableViewCell"
    
    var coachWalletResponse: [JSON]? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerTable(tableView: walletTV, nib_identifier: nib_identifier)
        registerTable(tableView: walletTV, nib_identifier: nib_identifier_sperator)
        configCell(table: walletTV)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.fetchWallet()
    }
    
    // MARK :- configCell
    func configCell(table: UITableView) {
        table.allowsSelection = false
    }
    
    @IBAction func openSideMenu(_ sender: UIBarButtonItem) {
        self.sideMenuController?.revealMenu()
    }

}

extension CoachMyWalletViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ( self.coachWalletResponse?.count ?? 0 ) * 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row % 2 == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: nib_identifier, for: indexPath) as! coachWalletTableViewCell
            
            let num = indexPath.row / 2
            let current = self.coachWalletResponse?[num]
            let name = current?["User"]["Name"].string ?? ""
            let date = current?["Date"].string ?? ""
            let amount = "\(current?["TotalAmount"].int ?? 0) L.E"
            let status = current?["Status"].string ?? ""
            
            cell.configCell(name: name, date: date, amount: String(amount), status: status)
            
            
            return cell
        }else {
            let cell = tableView.dequeueReusableCell(withIdentifier: nib_identifier_sperator, for: indexPath) as! separatorCellTableViewCell
            return cell
        }
    }
}

extension CoachMyWalletViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.row % 2 == 0 {
            return 70
        }
        return 10
        
    }
}
