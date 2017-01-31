//
//  UIColorExtension.swift
//  ViewPagerExperiments
//
//  Created by Yoshikuni Kato on 2016/04/07.
//  Copyright © 2016年 Ohako Inc. All rights reserved.
//

import UIKit

extension UIColor {
    static func randomColor(_ index: Int) -> UIColor {
        switch index % 10 {
        case 0:
            return UIColor.black
        case 1:
            return UIColor.blue
        case 2:
            return UIColor.brown
        case 3:
            return UIColor.cyan
        case 4:
            return UIColor.darkGray
        case 5:
            return UIColor.gray
        case 6:
            return UIColor.green
        case 7:
            return UIColor.lightGray
        case 8:
            return UIColor.magenta
        case 9:
            return UIColor.orange
        default:
            return UIColor.white
        }
    }
}
