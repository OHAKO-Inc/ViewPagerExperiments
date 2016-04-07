//
//  ScrollContainerViewController.swift
//  ViewPagerExperiments
//
//  Created by Yoshikuni Kato on 2016/04/05.
//  Copyright © 2016年 Ohako Inc. All rights reserved.
//

import UIKit

class ScrollContainerViewController: UIViewController, StoryboardInstantiable {
    
    @IBOutlet weak var scrollView: UIScrollView!

    var contentVCs = [UIViewController]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        for _ in 0..<1 {
            let contentVC = ContentViewController.instantiate()
            contentVCs.append(contentVC)
        }
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false

        for contentVC in contentVCs {
            
            contentVC.view.translatesAutoresizingMaskIntoConstraints = false
            
            addChildViewController(contentVC)
            scrollView.addSubview(contentVC.view)
            contentVC.didMoveToParentViewController(self)
            
            contentVC.view.widthAnchor.constraintEqualToAnchor(scrollView.widthAnchor).active = true
            contentVC.view.heightAnchor.constraintEqualToAnchor(scrollView.heightAnchor).active = true
            contentVC.view.topAnchor.constraintEqualToAnchor(scrollView.topAnchor).active = true
            contentVC.view.bottomAnchor.constraintEqualToAnchor(scrollView.bottomAnchor).active = true
        }
        
        contentVCs[0].view.leadingAnchor.constraintEqualToAnchor(scrollView.leadingAnchor).active = true

        for (index, contentVC) in contentVCs.enumerate() {
            if index == contentVCs.count - 1 {
                break
            }
            let nextContentVC = contentVCs[index + 1]
            contentVC.view.trailingAnchor.constraintEqualToAnchor(nextContentVC.view.leadingAnchor).active = true
        }
        
        contentVCs[contentVCs.count - 1].view.trailingAnchor.constraintEqualToAnchor(scrollView.trailingAnchor).active = true
        
    }
    
}

