//
//  TabMenuCollectionViewCell.swift
//  ViewPagerExperiments
//
//  Created by Yoshikuni Kato on 2016/04/21.
//  Copyright © 2016年 Ohako Inc. All rights reserved.
//

import UIKit

class TabMenuCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    func configure(title: String) {
        titleLabel.text = title
    }
}
