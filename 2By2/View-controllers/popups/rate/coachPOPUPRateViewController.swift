//
//  coachPOPUPRateViewController.swift
//  2By2
//
//  Created by rocky on 1/6/19.
//  Copyright © 2019 personal. All rights reserved.
//

import UIKit
import Cosmos

class coachPOPUPRateViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var rate: CosmosView!
    @IBOutlet weak var comment: UITextView!
    @IBOutlet weak var rateView: customDesignableView!
    var rating: Double = 0.0
    var textComment: String = "write your comment"
    var rateModel: rateDataModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGestureRecognizer1 = UITapGestureRecognizer(target: self, action: #selector(viewTapped(tapGestureRecognizer:)))
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(tapGestureRecognizer1)
        
        let tapGestureRecognizer2 = UITapGestureRecognizer(target: self, action: #selector(rateViewTapped(tapGestureRecognizer:)))
        rateView.isUserInteractionEnabled = true
        rateView.addGestureRecognizer(tapGestureRecognizer2)
        
        self.comment.delegate = self
        
        
        if let com = self.rateModel.CoachComment, com.isEmpty == false {
            self.rate.rating = self.rateModel.CoachRate!
            self.comment.text = com
        } else if let com = self.rateModel.UserComment, com.isEmpty == false {
            self.rate.rating = self.rateModel.UserRate!
            self.comment.text = com
        } else {
            self.rate.rating = 5
            self.comment.text = self.textComment
        }
        
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
    
    
    @IBAction func confirm(_ sender: UIButton) {
        guard self.rate.rating != 0.0 else {
            return
        }
        
        guard let com = self.comment.text, com.isEmpty == false  else {
            return
        }
        
        self.textComment = com
        self.rating = self.rate.rating
        
        self.dismiss(animated: true) {
            NotificationCenter.default.post(name: .rate, object: self)
        }
        
    }
    
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == self.textComment {
            self.comment.text = ""
        }
    }
}
