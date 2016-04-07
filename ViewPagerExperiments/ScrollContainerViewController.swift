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

        scrollView.translatesAutoresizingMaskIntoConstraints = false


        let initialContentVCs = Array(contentVCs[0...1])
        
        for contentVC in initialContentVCs {
            
            contentVC.view.translatesAutoresizingMaskIntoConstraints = false
            
            addChildViewController(contentVC)
            scrollView.addSubview(contentVC.view)
            contentVC.didMoveToParentViewController(self)
            
            contentVC.view.widthAnchor.constraintEqualToAnchor(scrollView.widthAnchor).active = true
            contentVC.view.heightAnchor.constraintEqualToAnchor(scrollView.heightAnchor).active = true
            contentVC.view.topAnchor.constraintEqualToAnchor(scrollView.topAnchor).active = true
            contentVC.view.bottomAnchor.constraintEqualToAnchor(scrollView.bottomAnchor).active = true
        }
        
        initialContentVCs[0].view.leadingAnchor.constraintEqualToAnchor(scrollView.leadingAnchor).active = true

        initialContentVCs.enumerate().forEach { (index, contentVC) in
            if index == initialContentVCs.count - 1 {
                return
            }
            let nextContentVC = initialContentVCs[index + 1]
            contentVC.view.trailingAnchor.constraintEqualToAnchor(nextContentVC.view.leadingAnchor).active = true
        }
        
        initialContentVCs[initialContentVCs.count - 1].view.trailingAnchor.constraintEqualToAnchor(scrollView.trailingAnchor).active = true
    }
    
}

