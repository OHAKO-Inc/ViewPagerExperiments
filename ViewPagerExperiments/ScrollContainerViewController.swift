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
    
    
    fileprivate func addViewController(_ viewController: UIViewController) {
        viewController.view.frame = .zero
        viewController.view.translatesAutoresizingMaskIntoConstraints = false
        
        addChildViewController(viewController)
        scrollView.addSubview(viewController.view)
        viewController.didMove(toParentViewController: self)
    }

    fileprivate func removeViewController(_ viewController: UIViewController) {
        viewController.willMove(toParentViewController: nil)
        viewController.view.removeFromSuperview()
        viewController.removeFromParentViewController()
    }
    
    fileprivate func layoutViewControllers() {
        
        onMemoryVCs[0].view.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        
        for (index, contentVC) in onMemoryVCs.enumerated() {
            
            contentVC.view.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
            contentVC.view.heightAnchor.constraint(equalTo: scrollView.heightAnchor).isActive = true
            contentVC.view.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
            contentVC.view.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
            
            
            if index == onMemoryVCs.count - 1 {
                break
            }
            let nextContentVC = onMemoryVCs[index + 1]
            contentVC.view.trailingAnchor.constraint(equalTo: nextContentVC.view.leadingAnchor).isActive = true
        }
        
        onMemoryVCs[onMemoryVCs.count - 1].view.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        
    }

}

extension ScrollContainerViewController: UIScrollViewDelegate {


    fileprivate func constructViewControllers(_ visibleViewControllers: [UIViewController]) {
        
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
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        guard let position = PagingViewPosition(order: Int(scrollView.contentOffset.x / scrollView.bounds.width)),
            let previousCenterVCIndex = contentVCs.index(of: currentVC) else {
                return
        }

        onMemoryVCs = []
        switch position {
        case .right:
            onMemoryVCs.append(contentVCs[previousCenterVCIndex])
            onMemoryVCs.append(contentVCs[previousCenterVCIndex + 1])
            currentVC = contentVCs[previousCenterVCIndex + 1]
            if previousCenterVCIndex + 2 < contentVCs.count {
                onMemoryVCs.append(contentVCs[previousCenterVCIndex + 2])
            }


        case .left:
            if previousCenterVCIndex - 2 >= 0 {
                onMemoryVCs.append(contentVCs[previousCenterVCIndex - 2])
            }
            onMemoryVCs.append(contentVCs[previousCenterVCIndex - 1])
            currentVC = contentVCs[previousCenterVCIndex - 1]
            onMemoryVCs.append(contentVCs[previousCenterVCIndex])
        }
        
        NSLayoutConstraint.deactivate(scrollView.constraints)
        contentVCs.forEach { (vc) in
            NSLayoutConstraint.deactivate(vc.view.constraints)
        }
        
        
        constructViewControllers(onMemoryVCs)
        layoutViewControllers()
        view.setNeedsLayout()
        view.layoutIfNeeded()
    }
}

enum PagingViewPosition {
    case left
    case right
    
    init?(order: Int) {
        switch order {
        case 0:
            self = .left
        case 2:
            self = .right
        default:
            return nil
        }
    }
}
