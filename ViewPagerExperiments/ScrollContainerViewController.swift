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
        onMemoryVCs.forEach { (vc) in
            print(vc.view.frame)
        }
        print("currentVC: \(currentVC.view.frame.minX)")
        scrollView.contentOffset.x = currentVC.view.frame.origin.x
    }
    
    
    private func addViewController(viewController: UIViewController) {
        viewController.view.frame = .zero
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


    private func constructViewControllers(visibleViewControllers: [UIViewController]) {
        
        for previousChildViewController in self.childViewControllers {
            if !visibleViewControllers.contains(previousChildViewController) {
                removeViewController(previousChildViewController)
            }
        }
        
        for visibleViewController in visibleViewControllers {
            if !childViewControllers.contains(visibleViewController) {
                addViewController(visibleViewController)
            }
        }
        
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        
        guard let position = PagingViewPosition(order: Int(scrollView.contentOffset.x / scrollView.bounds.width)),
            let previousCenterVCIndex = contentVCs.indexOf(currentVC) else {
                return
        }

        onMemoryVCs = []
        switch position {
        case .Right:
            onMemoryVCs.append(contentVCs[previousCenterVCIndex])
            onMemoryVCs.append(contentVCs[previousCenterVCIndex + 1])
            currentVC = contentVCs[previousCenterVCIndex + 1]
            if previousCenterVCIndex + 2 < contentVCs.count {
                onMemoryVCs.append(contentVCs[previousCenterVCIndex + 2])
            }


        case .Left:
            if previousCenterVCIndex - 2 >= 0 {
                onMemoryVCs.append(contentVCs[previousCenterVCIndex - 2])
            }
            onMemoryVCs.append(contentVCs[previousCenterVCIndex - 1])
            currentVC = contentVCs[previousCenterVCIndex - 1]
            onMemoryVCs.append(contentVCs[previousCenterVCIndex])
        }
        
        NSLayoutConstraint.deactivateConstraints(scrollView.constraints)
        contentVCs.forEach { (vc) in
            NSLayoutConstraint.deactivateConstraints(vc.view.constraints)
        }
        
        
        constructViewControllers(onMemoryVCs)
        layoutViewControllers()
        view.setNeedsLayout()
        view.layoutIfNeeded()
    }
}

enum PagingViewPosition {
    case Left
    case Right
    
    init?(order: Int) {
        switch order {
        case 0:
            self = .Left
        case 2:
            self = .Right
        default:
            return nil
        }
    }
}
