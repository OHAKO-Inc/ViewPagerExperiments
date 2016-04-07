//
//  StoryboardInstantiable.swift
//  ViewPagerExperiments
//
//  Created by Yoshikuni Kato on 2016/04/05.
//  Copyright © 2016年 Ohako Inc. All rights reserved.
//

import UIKit

protocol StoryboardInstantiable {}

extension StoryboardInstantiable {
    static func instantiate() -> Self {
        let storyBoard = UIStoryboard(name: String(Self), bundle: nil)
        return storyBoard.instantiateInitialViewController() as! Self
    }
}
