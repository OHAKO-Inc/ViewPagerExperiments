//
//  TabMenuViewController.swift
//  ViewPagerExperiments
//
//  Created by Yoshikuni Kato on 2016/04/21.
//  Copyright © 2016年 Ohako Inc. All rights reserved.
//

import UIKit

class TabMenuViewController: UIViewController, StoryboardInstantiable {

    let dataSource = TabMenuCollectionViewDataSource()
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = dataSource
        collectionView.delegate = self
        collectionView.delegate = self
        collectionView.reloadData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        var insets = self.collectionView.contentInset
        let value = (self.view.frame.size.width - (self.collectionView.collectionViewLayout as! UICollectionViewFlowLayout).itemSize.width) * 0.5
        insets.left = value
        insets.right = value
        self.collectionView.contentInset = insets
        print("\(value)")
        self.collectionView.decelerationRate = UIScrollViewDecelerationRateFast;
    }
}

extension TabMenuViewController: UICollectionViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        print("didScroll")
//        let contentOffsetWhenFullyScrolledRight = collectionView.frame.size.width * CGFloat(dataSource.actualTitles.count - 1)
//        if scrollView.contentOffset.x == contentOffsetWhenFullyScrolledRight {
//            collectionView.scrollToItemAtIndexPath(
//                NSIndexPath(forItem: 1, inSection: 0),
//                atScrollPosition: .Left,
//                animated: false)
//        } else if scrollView.contentOffset.x == 0 {
//            collectionView.scrollToItemAtIndexPath(
//                NSIndexPath(forItem: dataSource.actualTitles.count - 2, inSection: 0),
//                atScrollPosition: .Left,
//                animated: false)
//        }
    }
}
