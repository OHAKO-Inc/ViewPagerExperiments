//
//  CenterCellCollectionViewFlowLayout.swift
//  ViewPagerExperiments
//
//  Created by Yoshikuni Kato on 2016/04/21.
//  Copyright © 2016年 Ohako Inc. All rights reserved.
//

import UIKit

class CenterCellCollectionViewFlowLayout: UICollectionViewFlowLayout {

    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        
        guard let collectionView = collectionView,
            let attributesForVisibleElements = layoutAttributesForElements(in: collectionView.bounds) else {
                return super.targetContentOffset(forProposedContentOffset: proposedContentOffset)
        }
        
        let attributesForVisibleCells = attributesForVisibleElements.filter { (attributes) -> Bool in
            return attributes.representedElementCategory == .cell
        }
        
        guard !attributesForVisibleCells.isEmpty else {
            return super.targetContentOffset(forProposedContentOffset: proposedContentOffset)
        }
        
        
        let visibleRectHalfWidth = collectionView.bounds.size.width * 0.5
        let proposedVisibleRectCenterX = proposedContentOffset.x + visibleRectHalfWidth
        
        
        // find centerCell in proposedVisibleRect
        var centerCellCandidateAttributes = attributesForVisibleCells.first!
        
        for attributes in attributesForVisibleCells {
            
            let centerDistanceBetweenCurrentCellAndVisibleRect = fabs(attributes.center.x - proposedVisibleRectCenterX)
            let centerDistanceBetweenCandidateCellAndVisibleRect = fabs(centerCellCandidateAttributes.center.x - proposedVisibleRectCenterX)
            
            if centerDistanceBetweenCurrentCellAndVisibleRect < centerDistanceBetweenCandidateCellAndVisibleRect {
                centerCellCandidateAttributes = attributes
            }
        }
        
        return CGPoint(x: round(centerCellCandidateAttributes.center.x - visibleRectHalfWidth), y: proposedContentOffset.y)
    }
}
