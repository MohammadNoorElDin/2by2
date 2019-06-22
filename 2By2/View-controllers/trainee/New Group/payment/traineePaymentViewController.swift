//
//  traineePaymentViewController.swift
//  trainee
//
//  Created by rocky on 11/30/18.
//  Copyright © 2018 personal. All rights reserved.
//

import UIKit
import SwiftyJSON

class traineePaymentViewController: UIViewController {
    
    @IBOutlet weak var paymentTV: UITableView!
    @IBOutlet weak var paymentMethods: UITableView!
    
    let nib_identifier: String = "paymentHistoryTableViewCell"
    let nib_identifier_methods: String = "paymentMethodsTableViewCell"
    let nib_identifier_separator: String = "separatorCellTableViewCell"
    
    var payments = [JSON]()
    var externalURL: String = ""
    var addCreditCardFirst: Bool = false 
    var paymentHistories: [JSON]? = nil
    var paymentMethodsArray: [JSON]? = nil
    var observer: NSObjectProtocol?
    
    var Fk_Reservation:Int!
    var selectedCreditCardId: Int!
    var selectedPinMask: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerTable(tableView: paymentTV, nib_identifier: nib_identifier)
        registerTable(tableView: paymentTV, nib_identifier: nib_identifier_separator)
        registerTable(tableView: paymentMethods, nib_identifier: nib_identifier_methods)
        registerTable(tableView: paymentMethods, nib_identifier: nib_identifier_separator)
        configTable()
    }
    
    func configTable() {
        self.paymentTV.allowsSelection = false
        self.paymentTV.tableFooterView = UIView()
        self.paymentTV.separatorInset = .zero
        self.paymentTV.contentInset = .zero
        self.paymentMethods.allowsSelection = false
        self.paymentMethods.tableFooterView = UIView()
        self.paymentMethods.separatorInset = .zero
        self.paymentMethods.contentInset = .zero
    }
    
    @IBAction func openSideMenu(_ sender: Any) {
        self.sideMenuController?.revealMenu()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        PaymentGetUserPaymentHistoryModel.GetUserPaymentHistoryRequest(object: self) { (payments, error) in
            if error == false {
                if let payments =  payments?["Data"].array {
                    self.paymentHistories = payments
                    self.paymentTV.reloadData()
                }else {
                    self.paymentHistories?.removeAll()
                    self.paymentTV.reloadData()
                }
            }
            
        }
        PaymentGetUserPaymentHistoryModel.GetUserPaymentMethodsRequest(object: self) { (response, error ) in
            if error == false {
                if let methods = response?["Data"].array, methods.isEmpty == false {
                    if let firstCredit = methods[0].dictionary {
                        self.selectedCreditCardId = firstCredit["Id"]?.int ?? 0
                        self.selectedPinMask = firstCredit["PinMask"]?.string ?? ""
                        
                        self.paymentMethodsArray = methods
                        self.paymentMethods.reloadData()
                    }
                }else {
                    self.paymentMethodsArray?.removeAll()
                    self.paymentMethods.reloadData()
                }
            }
        }
        
        observer = addCustomObserver(name: .paymMYinstallment, completion: { (notification) in
            if let _ = notification.object as? payMyInstallmentPOPUPViewController {
                let params = [
                    "Fk_UserCredit": self.selectedCreditCardId,
                    "Fk_Reservation": self.Fk_Reservation,
                ] as [String: Any]
                ReservationInstallmentModel.paymyinstallmentRequest(object: self, params: params, completion: { (response, error) in
                    if error == false {
                      self.viewDidAppear(true)
                    }
                })
            }
        })
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        if let observer = observer {
            NotificationCenter.default.removeObserver(observer)
        }
    }
    
    @IBAction func addPayment(_ sender: UIButton) {
        
        CreditCreatModel.CreatePostRequest.tokenCommingBack(object: self) { (token, error) in
            
            if error == false {
                if token != nil {
                    let url = "https://accept.paymobsolutions.com/api/acceptance/iframes/5898?payment_token=" + ( token ?? "" )
                    self.externalURL = url
                    
                    self.performSegue(withIdentifier: segueIdentifier.openInWebView, sender: self)
                }else {
                    print("No token comes back")
                }
            }
            
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == segueIdentifier.openInWebView {
            if let dest = segue.destination as? webViewController {
                dest.url = self.externalURL
            }
        }
    }
}


extension traineePaymentViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView.tag == 1 {
            return ( paymentHistories?.count ?? 0 ) * 2
        }else if tableView.tag == 0 {
            return ( paymentMethodsArray?.count ?? 0 ) * 2
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView.tag == 0 {
            // payment credits
            
            if indexPath.row % 2 == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: nib_identifier_methods, for: indexPath) as! paymentMethodsTableViewCell
                
                let num = indexPath.row / 2
                let radio: String = ( num == 0 ) ? "radio-on-button" : "radio-off-button"
                if let PinMask = paymentMethodsArray?[num]["PinMask"].string {
                    let type = paymentMethodsArray?[num]["CreditType"]["Id"].int ?? 1
                    cell.configCell(radio: radio, visa: ( type == 1 ) ? "visa" : "master_card", card: PinMask)
                }
                
                cell.delete = { [weak self] in
                    if let self = self {
                        Alerts.DisplayDefaultAlertWithActions(title: "", message: "Are You Sure?", object: self, buttons: ["CANCEL" : .cancel, "OK": .default], actionType: .default, completion: { (name) in
                            if name == "OK" {
                                let params = ["Id": self.paymentMethodsArray?[num]["Id"].int ?? 0]
                                self.deleteCredit(params: params)
                            }
                        })
                    }
                }
                
                cell.closure = { [weak self] in
                    self?.selectedCreditCardId = self?.paymentMethodsArray?[num]["Id"].int ?? 0
                    if let PinMask = self?.paymentMethodsArray?[num]["PinMask"].string {
                        self?.selectedPinMask = PinMask
                    }
                    self?.paymentMethods.reloadData()
                }
                
                if self.selectedCreditCardId == ( paymentMethodsArray?[num]["Id"].int ?? 0) {
                    cell.radioButton.setImage(UIImage(named: "radio-on-button"), for: .normal)
                } else {
                    cell.radioButton.setImage(UIImage(named: "radio-off-button"), for: .normal)
                }
                
                return cell
            }else {
                let cell = tableView.dequeueReusableCell(withIdentifier: nib_identifier_separator, for: indexPath) as! separatorCellTableViewCell
                return cell
            }
            
            
        } else { // tag == 1
            // payment history
            
            if indexPath.row % 2 == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: nib_identifier, for: indexPath) as! paymentHistoryTableViewCell
                
                let num = indexPath.row / 2
                
                if let payment = self.paymentHistories?[num].dictionary {
                    let name = payment["Package"]?["Name"].string ?? ""
                    let TotalPaid = payment["TotalPaid"]?.int ?? 0
                    let TotalUnPaid = payment["TotalUnPaid"]?.int ?? 0
                    let method = payment["PaymentOption"]?["Name"].string ?? ""
                    
                    cell.configCell(package: name, paid: String(TotalPaid), outStanding: TotalUnPaid, date: "null", method: method)
                
                    cell.closure = { [weak self] in
                        guard ( self?.paymentMethodsArray?.count ?? 0 ) > 0 else {
                            return
                        }
                        if let Fk_Reservation = payment["Reservation"]?["Id"].int {
                            self?.Fk_Reservation = Fk_Reservation
                        }
                        
                        if let price = payment["TotalUnPaid"]?.int {
                            self?.display(price: price, mask: (self?.selectedPinMask)!)
                        }
                    }
                }
                return cell
            }else {
                let cell = tableView.dequeueReusableCell(withIdentifier: nib_identifier_separator, for: indexPath) as! separatorCellTableViewCell
                
                return cell
            }
            
        }
        
    }
    
    
    func deleteCredit(params: [String:Any]) {
        PaymentGetUserPaymentHistoryModel.DeletePaymentMethodsRequest(object: self, params: params, completion: { (reponse, error) in
            if error == false {
                self.viewDidAppear(true)
            }else {
                Alerts.DisplayDefaultAlert(title: "", message: "can not delete the credit", object:self, actionType: .default)
            }
        })
        
    }
    
    func display(price: Int, mask: String) {
        let tab = PopusHandle.paymyinstallmentPopupViewController()
        tab.price = price
        tab.creditCard = mask
        present(tab, animated: true, completion: nil)
    }
    
}


extension traineePaymentViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row % 2 == 0 {
            if tableView.tag == 0 {
                return 40
            } else {
                return 250
            }
        }else {
            if tableView.tag == 0 {
                return 10
            }else {
                return 20
            }
        }
    }
}
