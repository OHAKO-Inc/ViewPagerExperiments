//
//  UIColorExtension.swift
//  ViewPagerExperiments
//
//  Created by Yoshikuni Kato on 2016/04/07.
//  Copyright © 2016年 Ohako Inc. All rights reserved.
//

import UIKit

extension UIColor {
    static func randomColor(index: Int) -> UIColor {
        switch index % 10 {
        case 0:
            return UIColor.blackColor()
        case 1:
            return UIColor.blueColor()
        case 2:
            return UIColor.brownColor()
        case 3:
            return UIColor.cyanColor()
        case 4:
            return UIColor.darkGrayColor()
        case 5:
            return UIColor.grayColor()
        case 6:
            return UIColor.greenColor()
        case 7:
            return UIColor.lightGrayColor()
        case 8:
            return UIColor.magentaColor()
        case 9:
            return UIColor.orangeColor()
        default:
            return UIColor.whiteColor()
        }
    }
}
