//
//  PageViewController.swift
//  ViewPagerExperiments
//
//  Created by Yoshikuni Kato on 2016/04/18.
//  Copyright © 2016年 Ohako Inc. All rights reserved.
//

import UIKit

class PageViewController: UIViewController {
    
    var contentVCs: [UIViewController]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        pageViewController.setViewControllers([contentVCs[0]], direction: .forward, animated: true, completion: nil)
        pageViewController.dataSource = self
        
        addChildViewController(pageViewController)
        self.view.addSubview(pageViewController.view)
        pageViewController.didMove(toParentViewController: self)
        
    }
    
}

extension PageViewController: UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        guard let index = contentVCs.index(of: viewController) else {
            return nil
        }
        
        return (index - 1) >= 0 ? contentVCs[index - 1] : contentVCs[contentVCs.count-1]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        guard let index = contentVCs.index(of: viewController) else {
            return nil
        }
        
        return (index + 1) < contentVCs.count ? contentVCs[index + 1] : contentVCs[0]
    }
}
