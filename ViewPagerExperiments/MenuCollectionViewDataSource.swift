//
//  MenuCollectionViewDataSource.swift
//  ViewPagerExperiments
//
//  Created by Yoshikuni Kato on 2016/04/22.
//  Copyright © 2016年 Ohako Inc. All rights reserved.
//

import UIKit

class MenuCollectionViewDataSource: NSObject {
    let titles: [String]
    init(titles: [String]) {
        self.titles = titles
    }
}

extension MenuCollectionViewDataSource: UICollectionViewDataSource {
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return titles.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(String(TabMenuCollectionViewCell), forIndexPath: indexPath) as! TabMenuCollectionViewCell
        cell.configure(titles[indexPath.row])
        return cell
    }

}
