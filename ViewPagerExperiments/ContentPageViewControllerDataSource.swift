//
//  ContentPageViewControllerDataSource.swift
//  ViewPagerExperiments
//
//  Created by Yoshikuni Kato on 2016/04/22.
//  Copyright © 2016年 Ohako Inc. All rights reserved.
//

import UIKit

class ContentPageViewControllerDataSource: NSObject {
    let contentVCs: [UIViewController]
    
    init(contentVCs: [UIViewController]) {
        self.contentVCs = contentVCs
    }
}

extension ContentPageViewControllerDataSource: UIPageViewControllerDataSource {

    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        
        guard let index = contentVCs.indexOf(viewController) else {
            return nil
        }
        
        return (index - 1) >= 0 ? contentVCs[index - 1] : nil
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        guard let index = contentVCs.indexOf(viewController) else {
            return nil
        }
        
        return (index + 1) < contentVCs.count ? contentVCs[index + 1] : nil
    }
    
}
