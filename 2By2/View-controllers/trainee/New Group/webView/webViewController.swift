//
//  webViewController.swift
//  2By2
//
//  Created by rocky on 12/24/18.
//  Copyright © 2018 personal. All rights reserved.
//

import UIKit
import WebKit
import SwiftyJSON

class webViewController: UIViewController, UIWebViewDelegate {
    
    //@IBOutlet weak var webView: UIWebView!
    var url: String = ""
    var abs: String = "https://webservice.2by2club.com/Credit/Paymob_txn_response_callback"
    
    var comingFromPaymentConfirmation: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let screenWidth = UIScreen.main.bounds.size.width
        let screenHeight = UIScreen.main.bounds.size.height
        
        let termWebView = UIWebView(frame:CGRect(x:0, y:80, width:screenWidth, height:screenHeight))
        termWebView.delegate = self
        
        self.view.addSubview(termWebView)
        
        let urlString = url
        
        if let url = URL(string: urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)   {
            let request = URLRequest(url: url as URL)
            termWebView.loadRequest(request)
        }
        
        self.sideMenuController?.cacheViewController(withIdentifier: "traineepaymentsView", with: "trainee-payments")
        
    }
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        if webView.request?.url?.absoluteString.hasPrefix(abs) == true {
            self.sideMenuController?.setContentViewController(with: "trainee-payments")
        }
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView)
    {
        if webView.request?.url?.absoluteString.hasPrefix(abs) == true {
            webView.isHidden = true
            CreditCreatModel.CreateGetRequest.getStatus(url: webView.request?.url?.absoluteString ?? "", object: self, completion: { (response, error) in
                if error == false {
                    let json = JSON(response as Any)
                    if json["Success"].bool == true {
                        print("success")
                    }
                    if self.comingFromPaymentConfirmation == true {
                        self.navigationController?.popViewController(animated: true)
                    }else {
                        self.navigationController?.popToRootViewController(animated: true)
                        self.sideMenuController?.setContentViewController(with: "trainee-payments")
                    }
                }
            })
            
        }
    }
    
}
