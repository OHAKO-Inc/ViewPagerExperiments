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
        setupMenuCollectionView()
        setupPageViewController()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupMenuCollectionView()
    }
    private func setupMenuCollectionView() {
        menuCollectionView.dataSource = menuCollectionViewDataSource
        
        var insets = menuCollectionView.contentInset
        let value = (view.frame.size.width - (self.menuCollectionView.collectionViewLayout as! UICollectionViewFlowLayout).itemSize.width) * 0.5
        insets.left = value
        insets.right = value
        menuCollectionView.contentInset = insets
        print("\(value)")
        menuCollectionView.decelerationRate = UIScrollViewDecelerationRateFast;
    }
    
    private func setupPageViewController() {

        let pageViewController = UIPageViewController(transitionStyle: .Scroll, navigationOrientation: .Horizontal, options: nil)
        pageViewController.dataSource = contentPageViewControllerDataSource
        pageViewController.delegate = self
        pageViewController.setViewControllers([contentVCs[0]], direction: .Forward, animated: true, completion: nil)
        
        func setupConstraints() {
            pageViewController.view.translatesAutoresizingMaskIntoConstraints = false
            pageViewController.view.bottomAnchor.constraintEqualToAnchor(contentPageContainerView.bottomAnchor).active = true
            pageViewController.view.topAnchor.constraintEqualToAnchor(contentPageContainerView.topAnchor).active = true
            pageViewController.view.leadingAnchor.constraintEqualToAnchor(contentPageContainerView.leadingAnchor).active = true
            pageViewController.view.trailingAnchor.constraintEqualToAnchor(contentPageContainerView.trailingAnchor).active = true
        }

        addChildViewController(pageViewController)
        self.contentPageContainerView.addSubview(pageViewController.view)
        setupConstraints()
        pageViewController.didMoveToParentViewController(self)

        
        for view in pageViewController.view.subviews {
            if let scrollView = view as? UIScrollView {
                scrollView.delegate = self
            }
        }
    }
    
}

extension PageWithMenuViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(scrollView: UIScrollView) {

        guard let currentContentVC = currentContentVC,
            currentContentVCIndex = contentVCs.indexOf(currentContentVC) else {
                return
        }
        
        menuCollectionView.contentOffset.x = (150.0 / scrollView.bounds.width) * scrollView.contentOffset.x - (scrollView.bounds.width - 150.0) / 2 + CGFloat(currentContentVCIndex) * 150.0

        print(menuCollectionView.contentOffset.x)
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
