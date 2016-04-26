//
//  PageWithMenuViewController.swift
//  ViewPagerExperiments
//
//  Created by Yoshikuni Kato on 2016/04/22.
//  Copyright © 2016年 Ohako Inc. All rights reserved.
//

import UIKit

class PageWithMenuViewController: UIViewController, StoryboardInstantiable {

    @IBOutlet weak var contentPageContainerView: UIView!
    @IBOutlet weak var menuCollectionView: UICollectionView!

    let pageViewController = UIPageViewController(transitionStyle: .Scroll, navigationOrientation: .Horizontal, options: nil)
    lazy var scrollViewInPageViewController: UIScrollView! = {
        for view in self.pageViewController.view.subviews {
            if let scrollView = view as? UIScrollView {
                return scrollView
            }
        }
        return nil
    }()
    
    var contentVCs: [UIViewController]!
    
    var currentContentVC: UIViewController?
    
    lazy var menuCollectionViewDataSource: MenuCollectionViewDataSource = {
        let titles = self.contentVCs.map { (vc) -> String in
            return vc.title ?? ""
        }
        return MenuCollectionViewDataSource(titles: titles)
    }()
    lazy var contentPageViewControllerDataSource: ContentPageViewControllerDataSource = {
        return ContentPageViewControllerDataSource(contentVCs: self.contentVCs)
    }()
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupPageViewController()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupMenuCollectionView()
    }
    
    private func setupMenuCollectionView() {
        menuCollectionView.dataSource = menuCollectionViewDataSource
        (menuCollectionView as UIScrollView).delegate = self
        
        var insets = menuCollectionView.contentInset
        let value = (view.frame.size.width - (self.menuCollectionView.collectionViewLayout as! UICollectionViewFlowLayout).itemSize.width) * 0.5
        insets.left = value
        insets.right = value
        menuCollectionView.contentInset = insets
        menuCollectionView.decelerationRate = UIScrollViewDecelerationRateFast;
    }
    
    private func setupPageViewController() {

        pageViewController.dataSource = contentPageViewControllerDataSource
        pageViewController.delegate = self
        scrollViewInPageViewController?.delegate = self

        currentContentVC = contentVCs[0]
        pageViewController.setViewControllers([currentContentVC!], direction: .Forward, animated: true, completion: nil)
        
        func setupConstraints() {
            pageViewController.view.translatesAutoresizingMaskIntoConstraints = false
            pageViewController.view.bottomAnchor.constraintEqualToAnchor(contentPageContainerView.bottomAnchor).active = true
            pageViewController.view.topAnchor.constraintEqualToAnchor(contentPageContainerView.topAnchor).active = true
            pageViewController.view.leadingAnchor.constraintEqualToAnchor(contentPageContainerView.leadingAnchor).active = true
            pageViewController.view.trailingAnchor.constraintEqualToAnchor(contentPageContainerView.trailingAnchor).active = true
        }

        addChildViewController(pageViewController)
        contentPageContainerView.addSubview(pageViewController.view)
        setupConstraints()
        pageViewController.didMoveToParentViewController(self)

    }
    
}

extension PageWithMenuViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(scrollView: UIScrollView) {

        if scrollView === menuCollectionView {
            
            let destinationContentOffsetX = (scrollView.contentOffset.x + (scrollView.bounds.width - 150.0) / 2.0) * ((scrollViewInPageViewController!.bounds.width / 150.0))
            let contentVCIndex = Int(round(destinationContentOffsetX / scrollViewInPageViewController!.bounds.width))

            if contentVCIndex >= 0 && contentVCIndex < contentVCs.count {
                currentContentVC = contentVCs[contentVCIndex]
                pageViewController.setViewControllers([currentContentVC!], direction: .Forward, animated: false, completion: nil)
            }
            
            
        } else { // page view controller
            guard let currentContentVC = currentContentVC,
                currentContentVCIndex = contentVCs.indexOf(currentContentVC) else {
                    return
            }
            let menuScrollContentOffsetX = (150.0 / scrollView.bounds.width) * scrollView.contentOffset.x - (scrollView.bounds.width - 150.0) / 2 + CGFloat(currentContentVCIndex - 1) * 150.0
            var scrollBounds = menuCollectionView.bounds
            scrollBounds.origin = CGPoint(x: menuScrollContentOffsetX, y: scrollBounds.origin.y)
            menuCollectionView.bounds = scrollBounds
        }

    }
}

extension PageWithMenuViewController: UIPageViewControllerDelegate {
    func pageViewController(pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        guard completed else {
            return
        }
        currentContentVC = pageViewController.viewControllers?.first
    }
}
