//
//  ConfirmPaymentViewController.swift
//  trainee
//
//  Created by Kamal on 12/13/18.
//  Copyright © 2018 personal. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

class ConfirmPaymentViewController: UIViewController {

    var selectedPaymentOption: Int = 0
    var selectedPaymentWay: Int = 2
    var selectedPaymentCredit: Int = 0
    
    let nib_identifier_methods: String = "confirmPaymentTableViewCell"
    var bookingModel: BookingDataModel!
    var externalURL: String = ""
    
    @IBOutlet weak var promoCodeTF: UITextField!
    @IBOutlet weak var stack: UIView!
    @IBOutlet weak var discountLabel: UILabel!
    @IBOutlet var paymentMethodsBtns: [UIButton]!
    
    @IBOutlet var paymentOptionsBtns: [UIButton]! {
        didSet {
            for (index, element) in paymentOptionsBtns.enumerated() {
                element.tag = index
            }
        }
    }
    
    @IBOutlet var radioOptionLabels: [UILabel]! {
        didSet {
            for (index, element) in radioOptionLabels.enumerated() {
                element.tag = index
            }
        }
    }
    @IBOutlet weak var radioMethodLabel: UILabel!
    
    var paymentMethodsArray: [JSON]? = nil
    
    @IBOutlet weak var programLabel: UILabel!
    @IBOutlet weak var packageLabel: UILabel!
    @IBOutlet weak var ofSessionsLabel: UILabel!
    @IBOutlet weak var ofTraineeLabel: UILabel!
    @IBOutlet weak var costPerLabel: UILabel!
    @IBOutlet weak var totalCostLabel: UILabel!
    @IBOutlet weak var paymentMethods: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerTable(tableView: paymentMethods, nib_identifier: nib_identifier_methods)
        paymentMethods.isScrollEnabled = false
        //paymentMethods.allowsSelection = false
        self.bookingModel.totalPaid = self.bookingModel.packagePrice * self.bookingModel.availableSessions * (self.bookingModel.friends.count + 1)
        
        self.paymentMethods.isHidden = true 
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.ofSessionsLabel.text = String(self.bookingModel.availableSessions)
        self.ofTraineeLabel.text = String(self.bookingModel.friends.count + 1)
        self.costPerLabel.text = "\(self.bookingModel.packagePrice) L.E"
        self.totalCostLabel.text = "\(self.bookingModel.totalPaid) L.E"
        self.programLabel.text = self.bookingModel.Second_Category_Program_Name
        self.packageLabel.text = self.bookingModel.Package_Name
        
        PaymentGetUserPaymentHistoryModel.GetUserPaymentMethodsRequest(object: self) { (response, error ) in
            
            if error == false {
                if let methods =  response?["Data"].array {
                    self.paymentMethodsArray = methods
                    if methods.count > 0 {
                        self.selectedPaymentCredit =  methods[0]["Id"].int ?? 0
                    }
                    self.paymentMethods.reloadData()
                }
            }else {
                
                return
            }
        }
        
        self.sideMenuController?.cacheViewController(withIdentifier: "traineesessionView", with: "trainee-session")
        
        if self.bookingModel.FK_Gift == 0 {
            self.stack.isHidden = true
        }else {
            let disc = ( ( self.bookingModel.DisCount ) * (self.bookingModel.packagePrice * self.bookingModel.availableSessions) ) / 100
            self.discountLabel.text = "\(disc) L.E (\(self.bookingModel.DisCount) %)"
        }
        
        
    }
    
    @IBAction func paymentOptionsBtns(_ sender: UIButton) {
        
        if sender.tag == 1 {
            guard self.bookingModel.totalPaid > 3000 else {
                Alerts.DisplayDefaultAlert(title: "", message: "This option only available for packages above 3000 L.E", object: self, actionType: .default)
                return
            }
        }
        
        paymentOptionsBtns.forEach { (option) in
            if option.tag == sender.tag {
                option.setImage(UIImage(named: "radio-on-button"), for: .normal)
            }else {
                option.setImage(UIImage(named: "radio-off-button"), for: .normal)
            }
            if sender.tag == 1 {
                let price = ( 60 * ( (self.bookingModel.friends.count + 1) * self.bookingModel.packagePrice * self.bookingModel.availableSessions) ) / 100
                self.radioOptionLabels[sender.tag].text = "\(price) L.E (60%) now, 40% halfway"
            }
        }
        
        radioOptionLabels.forEach { (label) in
            if label.tag == sender.tag {
                label.isHidden = false
            }else {
                label.isHidden = true
            }
        }
        
        self.selectedPaymentOption = sender.tag + 1
    }
    
    @IBAction func paymentMethodsBtnsClicked(_ sender: UIButton) {
        
        if sender.tag == 2 {
            self.paymentMethods.isHidden = true
            self.radioMethodLabel.isHidden = false
        }else {
            self.paymentMethods.isHidden = false
            self.radioMethodLabel.isHidden = true
        }
        
        paymentMethodsBtns.forEach { (method) in
            if method.tag == sender.tag {
                method.setImage(UIImage(named: "radio-on-button"), for: .normal)
                
            }else {
                method.setImage(UIImage(named: "radio-off-button"), for: .normal)
            }
        }
        
        self.selectedPaymentWay = sender.tag
    }
    
    @IBAction func confirm(_ sender: UIButton) {
        
        self.bookingModel.paymentMethod = self.selectedPaymentWay
        self.bookingModel.paymentOption = self.selectedPaymentOption + 1
        self.bookingModel.CreditId = self.selectedPaymentCredit
        
        if self.bookingModel.paymentOption > 2 {
           self.bookingModel.paymentOption = 2 
        }
        
        if (paymentMethodsArray?.count ?? 0) <= 0 && self.selectedPaymentWay == 1 {
            self.addCreditCardFirst()
        }else {
            createReservation()
        }
    }
    // TODO:- HERE'S A DUPLICATE CODE .....
    func createReservation() {
        
        guard self.bookingModel.FK_Agenda.count > 0 else {
            Alerts.DisplayDefaultAlert(title: "", message: "add at least one Appointment", object: self, actionType: .default)
            return
        } // user add nothing
        
        let params = BookingDataModel.returnJsonRequest(object: self.bookingModel)
        print(params)
        
        ReservationCreateModel.AgendaCreateRequest(object: self, params: params) { (response, error) in
            if error == false {
                if let status = response?[Constants.status]["Id"].int, status == 0 {
                    if let message = response?[Constants.status][Constants.Message].string {
                        Alerts.DisplayDefaultAlert(title: "Oooops!", message: message, object: self, actionType: .default)
                    }
                }else {
                    self.sideMenuController?.setContentViewController(with: "trainee-session")
                }
            }
        }
    }
    
    func deleteReservation() {
        let params = [
            "Id": self.bookingModel.isModifyingFk_Reservation
        ]
        
        ReservationReservationsInfoModel.DeleteReservationsInfo.deleteReservation(object: self, params: params) { (response, error) in
            if error == false {
                self.createReservation()
            }else {
                print("NOTHING TO DELETE")
            }
            
        }
        
    }
    
    func addCreditCardFirst() {
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
                dest.comingFromPaymentConfirmation = true 
            }
        }
    }
    
    @IBAction func validatePromoPressed(_ sender: Any) {
        if let promo = promoCodeTF.text {
            print(promo)
            let params = ["Code":promo,
                          "Fk_User":UserDataUsedThroughTheApp.userId,
                          "Fk_SecondCategoryProgram":self.bookingModel.Second_Category_Program] as [String : Any]
            print(params)
            APIRequests.sendRequest(method: .get, url: "https://webservice.2by2club.com/Reservation/CheckCoupon", params: params, object: self) { (resp, error) in
                if error == false {
                print(resp)
                    let presentage = (resp["Discount"]?.intValue ?? 0) * self.bookingModel.totalPaid / 100
                    let NewTotal =  self.bookingModel.totalPaid - presentage
                self.totalCostLabel.text = "\(NewTotal) L.E"
                    self.bookingModel.FK_Gift = Int(resp["Id"]?.intValue ?? 0)
               // self.promoCodeTF.isEnabled = false
                } else {
                    print(resp)
                    let massage = resp["Message"]?.stringValue ?? ""
                    self.promoCodeTF.text = ""
                    self.totalCostLabel.text = "\(self.bookingModel.totalPaid) L.E"
                    Alerts.DisplayDefaultAlert(title: "Error", message: massage, object: self, actionType: .default)
                    
                }
            }
        }
}
}
extension ConfirmPaymentViewController : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.paymentMethodsArray?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: nib_identifier_methods, for: indexPath) as! confirmPaymentTableViewCell
        
        let num = indexPath.row
        cell.tag = paymentMethodsArray?[num]["Id"].int ?? 0
        
        let radio: String = ( self.selectedPaymentCredit == cell.tag ) ? "radio-on-button" : "radio-off-button"
        
        if let PinMask = paymentMethodsArray?[num]["PinMask"].string {
            let type = paymentMethodsArray?[num]["CreditType"]["Id"].int ?? 1
            cell.configCell(radio: radio, visa: ( type == 1 ) ? "visa" : "master_card", card: PinMask)
        }
        
        cell.closure = {
            self.selectedPaymentCredit = cell.tag
            self.paymentMethods.reloadData()
        }
        
        cell.backgroundColor = .clear
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 35
    }
    
}

/* APIRequests.sendJSONRequest(method: .get, url: "https://webservice.2by2club.com/Reservation/CheckCoupon", params: params, object: self) { (JSON, error) in
 if error != true {
 print(JSON)
 let NewTotal =  self.bookingModel.totalPaid - (JSON?["Data"]["Discount"].int ?? 0)
 self.totalCostLabel.text = "\(NewTotal) L.E"
 self.bookingModel.FK_Gift = JSON?["Data"]["Id"].int ?? 0
 self.promoCodeTF.isEnabled = false
 
 }
 else {
 print(JSON)
 let massage = JSON?["Status"]["Message"].string ?? ""
 self.promoCodeTF.text = ""
 Alerts.DisplayDefaultAlert(title: "Error", message: massage, object: self, actionType: .default)
 
 }
 }
 }*/
