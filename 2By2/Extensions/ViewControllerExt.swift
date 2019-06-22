//
//  ViewControllerExt.swift
//  2By2
//
//  Created by mac on 10/29/18.
//  Copyright © 2018 personal. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

extension UIViewController: NVActivityIndicatorViewable {
    
    func registerTable(tableView: UITableView, nib_identifier: String) {
        tableView.register(UINib.init(nibName: nib_identifier, bundle: nil), forCellReuseIdentifier: nib_identifier)
    }
    
    func registerCollection(collectionView: UICollectionView, nib_identifier: String) {
        collectionView.register(UINib.init(nibName: nib_identifier, bundle: nil), forCellWithReuseIdentifier: nib_identifier)
    }
    
    
    func moveToViewController(trainee: UIStoryboard?, coach: UIStoryboard?) {
        #if trainee
            if let trainee = trainee {
                DispatchQueue.main.async {
                    let window = UIApplication.shared.keyWindow!
                    let st = MoveToStoryBoard.moveTo(sb: trainee)
                    window.rootViewController = st
                }
            }
        #else
            if let coach = coach {
                DispatchQueue.main.async {
                    let window = UIApplication.shared.keyWindow!
                    let st = MoveToStoryBoard.moveTo(sb: coach)
                    window.rootViewController = st
                }
            }
        #endif
    }
    
    func addCustomObserver(name: Notification.Name, completion: @escaping (_ notification: Notification) -> () ) -> NSObjectProtocol? {
        
        let observer = NotificationCenter.default.addObserver(forName: name, object: nil, queue: OperationQueue.main) { (notification) in
            completion(notification)
        }
        return observer
    }
 
    func rootViewController () {
        let key = UIApplication.shared.keyWindow!
        let sb = MoveToStoryBoard.trainee_home
        key.rootViewController = sb.instantiateInitialViewController()
    }
}


extension FloatingPoint {
    var isIntVal: Bool {
        return floor(self) == self
    }
}

