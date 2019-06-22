//
//  detailsPOPUPViewController.swift
//  2By2
//
//  Created by rocky on 1/6/19.
//  Copyright © 2019 personal. All rights reserved.
//

import UIKit

class detailsPOPUPViewController: UIViewController {

    @IBOutlet weak var detail: UILabel!
    @IBOutlet weak var detailsView: customDesignableView!
    var message: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGestureRecognizer1 = UITapGestureRecognizer(target: self, action: #selector(viewTapped(tapGestureRecognizer:)))
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(tapGestureRecognizer1)
        
        let tapGestureRecognizer2 = UITapGestureRecognizer(target: self, action: #selector(detailsViewTapped(tapGestureRecognizer:)))
        detailsView.isUserInteractionEnabled = true
        detailsView.addGestureRecognizer(tapGestureRecognizer2)
        
        self.detail.text = self.message
    }
    
    @objc func viewTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        if tapGestureRecognizer.view == detailsView {
            return
        }
        dismiss(animated: true, completion: nil)
    }
    
    @objc func detailsViewTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        return
    }
    
}
