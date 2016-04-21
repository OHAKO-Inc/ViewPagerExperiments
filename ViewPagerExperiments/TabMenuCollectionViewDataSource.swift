//
//  TabMenuCollectionViewDataSource.swift
//  ViewPagerExperiments
//
//  Created by Yoshikuni Kato on 2016/04/21.
//  Copyright © 2016年 Ohako Inc. All rights reserved.
//

import UIKit

class TabMenuCollectionViewDataSource: NSObject {
    let menuTitles = ["1","2","3","4","5"]
    let actualTitles = ["5", "1","2","3","4","5","1"]
}

extension TabMenuCollectionViewDataSource: UICollectionViewDataSource {
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return actualTitles.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(String(TabMenuCollectionViewCell), forIndexPath: indexPath) as! TabMenuCollectionViewCell
        cell.configure(actualTitles[indexPath.row])
        return cell
    }
}
