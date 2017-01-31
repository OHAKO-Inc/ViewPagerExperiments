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
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return titles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: TabMenuCollectionViewCell.self), for: indexPath) as! TabMenuCollectionViewCell
        cell.configure(titles[indexPath.row])
        return cell
    }

}
