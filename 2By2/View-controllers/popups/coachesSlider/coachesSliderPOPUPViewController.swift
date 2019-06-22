//
//  coachesSliderPOPUPViewController.swift
//  2By2
//
//  Created by rocky on 12/12/18.
//  Copyright © 2018 personal. All rights reserved.
//

import UIKit
import SwiftyJSON

class coachesSliderPOPUPViewController: UIViewController, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var coaches = [JSON]()
    var pickedCoach: [String:JSON]? = nil
    var pickedCoachName: String = ""
    var pickedCoachImage: String = ""
    var openOnIndex: Int = 1
    var didDisplayOnce: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGestureRecognizer1 = UITapGestureRecognizer(target: self, action: #selector(viewTapped(tapGestureRecognizer:)))
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(tapGestureRecognizer1)
        
        let tapGestureRecognizer2 = UITapGestureRecognizer(target: self, action: #selector(rateTapped(tapGestureRecognizer:)))
        collectionView.isUserInteractionEnabled = true
        collectionView.addGestureRecognizer(tapGestureRecognizer2)
        
        collectionView.isPagingEnabled = true 
        self.automaticallyAdjustsScrollViewInsets = false
    }
    
    @objc func viewTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func rateTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        return
    }

}


extension coachesSliderPOPUPViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return coaches.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "coachesSliderImages", for: indexPath) as! CoachSliderCollectionViewCell
        
        
        let num = indexPath.row
        
        if let coach = coaches[num].dictionary {
            if let name = coach["Name"]?.string {
                cell.coachName.text = name
            }
            
            if let rate = coach["Rate"]?.double {
                if rate.isIntVal == true {
                    cell.starNumber.text = String(Int(rate))
                }else {
                    cell.starNumber.text = String(rate)
                }
            }else {
                cell.starNumber.text = "5"
            }
            if let image = coach["Image"]?.string {
                cell.coachImageSlider.findMe(url: image)
            }else {
                cell.coachImageSlider.image = UIImage(named: "default_avatar")
                //cell.coachImageSlider.imageRadius()
            }
            if let about = coach["About"]?.string {
                cell.aboutCoach.text = about 
            }
        }
        
        cell.closure = {
            self.pickedCoach = self.coaches[num].dictionary
            self.dismiss(animated: true, completion: {
                NotificationCenter.default.post(name: .picked, object: self)
            })
        }
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        if self.didDisplayOnce == false {
            //set the row and section you need.
            let indexToScrollTo = IndexPath(row: self.openOnIndex, section: indexPath.section)
            collectionView.scrollToItem(at: indexToScrollTo, at: .left, animated: false)
            self.didDisplayOnce = true
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.collectionView.bounds.width, height: self.collectionView.bounds.height)
    }
    
}
