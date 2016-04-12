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
    var onMemoryVCs = [UIViewController]()
    var currentVC: UIViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        scrollView.translatesAutoresizingMaskIntoConstraints = false

        onMemoryVCs = Array(contentVCs[0...2])
        currentVC = onMemoryVCs[1]
        
        for contentVC in onMemoryVCs {
            addViewController(contentVC)
        }
        
        layoutViewControllers()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollView.contentOffset.x = UIScreen.mainScreen().bounds.width
    }
    
    
    private func addViewController(viewController: UIViewController) {
        viewController.view.translatesAutoresizingMaskIntoConstraints = false
        
        addChildViewController(viewController)
        scrollView.addSubview(viewController.view)
        viewController.didMoveToParentViewController(self)
    }

    private func removeViewController(viewController: UIViewController) {
        viewController.willMoveToParentViewController(nil)
        viewController.view.removeFromSuperview()
        viewController.removeFromParentViewController()
    }
    
    private func layoutViewControllers() {
        
        onMemoryVCs[0].view.leadingAnchor.constraintEqualToAnchor(scrollView.leadingAnchor).active = true
        
        for (index, contentVC) in onMemoryVCs.enumerate() {
            
            contentVC.view.widthAnchor.constraintEqualToAnchor(scrollView.widthAnchor).active = true
            contentVC.view.heightAnchor.constraintEqualToAnchor(scrollView.heightAnchor).active = true
            contentVC.view.topAnchor.constraintEqualToAnchor(scrollView.topAnchor).active = true
            contentVC.view.bottomAnchor.constraintEqualToAnchor(scrollView.bottomAnchor).active = true
            
            
            if index == onMemoryVCs.count - 1 {
                break
            }
            let nextContentVC = onMemoryVCs[index + 1]
            contentVC.view.trailingAnchor.constraintEqualToAnchor(nextContentVC.view.leadingAnchor).active = true
        }
        
        onMemoryVCs[onMemoryVCs.count - 1].view.trailingAnchor.constraintEqualToAnchor(scrollView.trailingAnchor).active = true
        
    }
}

extension ScrollContainerViewController: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        print(scrollView.contentOffset.x / scrollView.bounds.width)
        
        guard let position = PagingViewPosition(order: Int(scrollView.contentOffset.x / scrollView.bounds.width)) where position != .Center,
            let previousCenterVCIndex = contentVCs.indexOf(currentVC) else {
                return
        }
        
        
        print("previousCenterVCIndex: \(previousCenterVCIndex)")
        print(position)
        switch position {
        case .Right:
            removeViewController(onMemoryVCs.removeFirst())
            onMemoryVCs.append(contentVCs[previousCenterVCIndex+2])
            addViewController(contentVCs[previousCenterVCIndex+2])
            currentVC = onMemoryVCs[1]
            
        case .Left:
            removeViewController(onMemoryVCs.removeLast())
            onMemoryVCs.insert(contentVCs[previousCenterVCIndex-2], atIndex: 0)
            addViewController(contentVCs[previousCenterVCIndex-2])
            currentVC = onMemoryVCs[1]

        case .Center:
            return
        }
        
        NSLayoutConstraint.deactivateConstraints(scrollView.constraints)
        layoutViewControllers()

        view.setNeedsLayout()
        view.layoutIfNeeded()
    }
}

enum PagingViewPosition {
    case Left
    case Center
    case Right
    
    init?(order: Int) {
        switch order {
        case 0:
            self = .Left
        case 1:
            self = .Center
        case 2:
            self = .Right
        default:
            return nil
        }
    }
}
