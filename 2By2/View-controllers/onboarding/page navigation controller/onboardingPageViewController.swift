//
//  onboardingPageViewController.swift
//  trainee
//
//  Created by rocky on 12/25/18.
//  Copyright © 2018 personal. All rights reserved.
//

import UIKit

class onboardingPageViewController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    lazy var VCArr: [UIViewController] = {
        return [
            self.VCInstance(name: "firstOnboardingVC"),
            self.VCInstance(name: "secondOnboardingVC"),
            self.VCInstance(name: "thirdOnboardingVC"),
            self.VCInstance(name: "fourthOnboardingVC")
        ]
    }()
    
    private func VCInstance(name: String) -> UIViewController {
        return MoveToStoryBoard.moveTo(sb: MoveToStoryBoard.trainee_onboarding, storyBoardId: name)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataSource = self
        self.delegate = self
        if let first = VCArr.first {
            setViewControllers([first], direction: .forward, animated: true, completion: nil)
        }
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        for view in self.view.subviews {
            if view is UIScrollView {
                view.frame = UIScreen.main.bounds
            }else if view is UIPageControl {
                view.backgroundColor = UIColor.clear
            }
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        guard let viewControllerIndex = VCArr.index(of: viewController) else {
            return nil
        }
        
        let previousIndex = viewControllerIndex - 1
        
        guard previousIndex >= 0 else {
            return nil
        }
        
        guard VCArr.count > previousIndex else {
            return nil
        }
        
        return VCArr[previousIndex]
        
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        guard let viewControllerIndex = VCArr.index(of: viewController) else {
            return nil
        }
        
        let nextIndex = viewControllerIndex + 1
        
        guard nextIndex < VCArr.count else {
            return nil
        }
        
        guard VCArr.count > nextIndex else {
            return nil
        }
       
        
        return VCArr[nextIndex]
        
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return VCArr.count
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        guard let firstViewController = viewControllers?.first,
            let firstViewControllerIndex = VCArr.index(of: firstViewController) else {
                return 0
        }
        
        return firstViewControllerIndex
    }
    
    
}
