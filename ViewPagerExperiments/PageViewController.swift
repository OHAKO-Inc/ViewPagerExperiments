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
        
        let pageViewController = UIPageViewController(transitionStyle: .Scroll, navigationOrientation: .Horizontal, options: nil)
        pageViewController.setViewControllers([contentVCs[0]], direction: .Forward, animated: true, completion: nil)
        pageViewController.dataSource = self
        
        addChildViewController(pageViewController)
        self.view.addSubview(pageViewController.view)
        pageViewController.didMoveToParentViewController(self)
        
    }
    
}

extension PageViewController: UIPageViewControllerDataSource {
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        
        guard let index = contentVCs.indexOf(viewController) else {
            return nil
        }
        
        return (index - 1) >= 0 ? contentVCs[index - 1] : contentVCs[contentVCs.count-1]
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        
        guard let index = contentVCs.indexOf(viewController) else {
            return nil
        }
        
        return (index + 1) < contentVCs.count ? contentVCs[index + 1] : contentVCs[0]
    }
}
