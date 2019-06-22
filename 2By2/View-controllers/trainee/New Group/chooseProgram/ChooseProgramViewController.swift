//
//  ChooseProgramViewController.swift
//  trainee
//
//  Created by Kamal on 12/8/18.
//  Copyright © 2018 personal. All rights reserved.
//

import UIKit
import SwiftyJSON

class ChooseProgramViewController: UIViewController {

    @IBOutlet weak var chooseProgramTV: UITableView!
    
    let nib_identefire_left = "LeftChooseProgramTableViewCell"
    let nib_identefire_right = "RightChooseProgramTableViewCell"
    
    var requestResultData: [JSON]? = nil
    
    var bookingModel: BookingDataModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerTable(tableView: chooseProgramTV, nib_identifier:  nib_identefire_right)
        registerTable(tableView: chooseProgramTV, nib_identifier:  nib_identefire_left)
    }
    
    @IBAction func workoutClicked(_ sender: UIButton) {
        let vc = PopusHandle.WorkoutBuddyPopupViewController()
        present(vc, animated: true, completion: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        ReservationGetProgramsModel.UserProgramsRequest(object: self) { (response, error) in
            if error == false {
                print(type(of: response))
                
                if let json = response?.dictionary {
                    if let data = json["Data"]?.array {
                        self.requestResultData = data
                        self.chooseProgramTV.reloadData()
                    }
                }
            }
            
        }
        
    }
    
}

extension ChooseProgramViewController:UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return requestResultData?.count ?? 0
    }
    
   func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        let num = indexPath.row
        if num % 2 == 0 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: nib_identefire_left
                , for: indexPath) as! LeftChooseProgramTableViewCell
            
            if let dic = requestResultData?[num].dictionary {
                if let title = dic["Name"]?.string {
                    cell.title.text = title
                }
                if let image = dic["Image"]?.string {
                    cell.leftImage.findMe(url: image)
                }
                var first: String = ""
                if let ThirdCategoryPrograms = dic["ThirdCategoryPrograms"]?.array {
                    ThirdCategoryPrograms.forEach { (item) in
                        if let item = item.dictionary {
                            if let name = item["Name"]?.string {
                                first.append(contentsOf: "\(name) -")
                            }
                        }
                    }
                    
                    first.removeLast()
                    cell.first.text = first
                }
            }
            return cell
        }else {
            let cell = tableView.dequeueReusableCell(withIdentifier: nib_identefire_right
                , for: indexPath) as! RightChooseProgramTableViewCell
            
        
            if let dic = requestResultData?[num].dictionary {
                if let title = dic["Name"]?.string {
                    cell.title.text = title
                }
                
                if let image = dic["Image"]?.string {
                    cell.rightImage.findMe(url: image)
                    
                }
                
                var first: String = ""
                if let ThirdCategoryPrograms = dic["ThirdCategoryPrograms"]?.array {
                    ThirdCategoryPrograms.forEach { (item) in
                        if let item = item.dictionary {
                            if let name = item["Name"]?.string {
                                first.append(contentsOf: "\(name) -")
                            }
                        }
                    }
                    first.removeLast()
                    cell.first.text = first
                }
            }
            
            return cell
        }
    }
    
}

extension ChooseProgramViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let num = indexPath.row
        if let dic = requestResultData?[num].dictionary {
            if let id = dic["Id"]?.int {
                self.bookingModel.Second_Category_Program = id
                self.bookingModel.Second_Category_Program_Name = dic["Name"]?.string ?? ""
                performSegue(withIdentifier: segueIdentifier.toTraineeMapSegue, sender: self)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == segueIdentifier.toTraineeMapSegue {
            if #available(iOS 11.0, *) {
                if let dest = segue.destination as? gmapWithAutoCompleteSearchViewController {
                    dest.bookingModel = self.bookingModel
                }
            } else {
                // Fallback on earlier versions
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 162
    }
}
