//
//  CenterCellCollectionViewFlowLayout.swift
//  ViewPagerExperiments
//
//  Created by Yoshikuni Kato on 2016/04/21.
//  Copyright © 2016年 Ohako Inc. All rights reserved.
//

import UIKit

class CenterCellCollectionViewFlowLayout: UICollectionViewFlowLayout {

    override func targetContentOffsetForProposedContentOffset(proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        
        guard let _collectionView = collectionView,
            attributesForVisibleCells = layoutAttributesForElementsInRect(_collectionView.bounds) else {
                return super.targetContentOffsetForProposedContentOffset(proposedContentOffset)
        }
        
        let halfWidth = _collectionView.bounds.size.width * 0.5
        let proposedContentOffsetCenterX = proposedContentOffset.x + halfWidth
        
        var candidateAttributes: UICollectionViewLayoutAttributes?
        for attributes in attributesForVisibleCells {
            guard attributes.representedElementCategory == UICollectionElementCategory.Cell else {
                continue
            }
            
            guard let _candidateAttributes = candidateAttributes else {
                candidateAttributes = attributes
                continue
            }
            
            let a = attributes.center.x - proposedContentOffsetCenterX
            let b = _candidateAttributes.center.x - proposedContentOffsetCenterX
            
            if fabs(a) < fabs(b) {
                candidateAttributes = attributes
            }
        }
        print(CGPoint(x: round(candidateAttributes!.center.x - halfWidth), y: proposedContentOffset.y))
        return CGPoint(x: round(candidateAttributes!.center.x - halfWidth), y: proposedContentOffset.y)
    }
}
