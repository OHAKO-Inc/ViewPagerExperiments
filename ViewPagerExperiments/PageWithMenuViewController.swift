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

    let pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
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
    
    fileprivate func setupMenuCollectionView() {
        menuCollectionView.dataSource = menuCollectionViewDataSource
        (menuCollectionView as UIScrollView).delegate = self
        
        var insets = menuCollectionView.contentInset
        let value = (view.frame.size.width - (self.menuCollectionView.collectionViewLayout as! UICollectionViewFlowLayout).itemSize.width) * 0.5
        insets.left = value
        insets.right = value
        menuCollectionView.contentInset = insets
        menuCollectionView.decelerationRate = UIScrollViewDecelerationRateFast;
    }
    
    fileprivate func setupPageViewController() {

        pageViewController.dataSource = contentPageViewControllerDataSource
        pageViewController.delegate = self
        scrollViewInPageViewController?.delegate = self

        currentContentVC = contentVCs[0]
        pageViewController.setViewControllers([currentContentVC!], direction: .forward, animated: true, completion: nil)
        
        func setupConstraints() {
            pageViewController.view.translatesAutoresizingMaskIntoConstraints = false
            pageViewController.view.bottomAnchor.constraint(equalTo: contentPageContainerView.bottomAnchor).isActive = true
            pageViewController.view.topAnchor.constraint(equalTo: contentPageContainerView.topAnchor).isActive = true
            pageViewController.view.leadingAnchor.constraint(equalTo: contentPageContainerView.leadingAnchor).isActive = true
            pageViewController.view.trailingAnchor.constraint(equalTo: contentPageContainerView.trailingAnchor).isActive = true
        }

        addChildViewController(pageViewController)
        contentPageContainerView.addSubview(pageViewController.view)
        setupConstraints()
        pageViewController.didMove(toParentViewController: self)

    }
    
}

extension PageWithMenuViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {

        if scrollView === menuCollectionView {
            
            let destinationContentOffsetX = (scrollView.contentOffset.x + (scrollView.bounds.width - 150.0) / 2.0) * ((scrollViewInPageViewController!.bounds.width / 150.0))
            let contentVCIndex = Int(round(destinationContentOffsetX / scrollViewInPageViewController!.bounds.width))

            if contentVCIndex >= 0 && contentVCIndex < contentVCs.count {
                currentContentVC = contentVCs[contentVCIndex]
                pageViewController.setViewControllers([currentContentVC!], direction: .forward, animated: false, completion: nil)
            }
            
            
        } else { // page view controller
            guard let currentContentVC = currentContentVC,
                let currentContentVCIndex = contentVCs.index(of: currentContentVC) else {
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
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        guard completed else {
            return
        }
        currentContentVC = pageViewController.viewControllers?.first
    }
}
