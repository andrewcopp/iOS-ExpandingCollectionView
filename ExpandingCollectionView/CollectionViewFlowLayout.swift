//
//  CollectionViewFlowLayout.swift
//  ExpandingCollectionView
//
//  Created by Andrew Copp on 5/5/16.
//  Copyright © 2016 Andrew Copp. All rights reserved.
//

import UIKit

class CollectionViewFlowLayout: UICollectionViewFlowLayout {

    var inserted: [UICollectionViewUpdateItem] = []
    var deleted: [UICollectionViewUpdateItem] = []
    
    var initialAppearingFrame: CGRect?
    
    override func prepareLayout() {
        super.prepareLayout()
    }
    
    override func prepareForCollectionViewUpdates(updateItems: [UICollectionViewUpdateItem]) {
        super.prepareForCollectionViewUpdates(updateItems)
        
        inserted = updateItems.filter { $0.updateAction == .Insert }
        deleted = updateItems.filter { $0.updateAction == .Delete }
    }
    
    override func targetContentOffsetForProposedContentOffset(proposedContentOffset: CGPoint) -> CGPoint {
        return proposedContentOffset
    }
    
    override func initialLayoutAttributesForAppearingItemAtIndexPath(itemIndexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
        let initialLayoutAttributes = super.initialLayoutAttributesForAppearingItemAtIndexPath(itemIndexPath)
        
        if inserted.contains({ $0.indexPathAfterUpdate == itemIndexPath }) {
            initialLayoutAttributes?.alpha = 0.0
            
            if let initialAppearingFrame = initialAppearingFrame {
                initialLayoutAttributes?.frame = initialAppearingFrame
            }
        }
        
        return initialLayoutAttributes
    }
    
    override func finalLayoutAttributesForDisappearingItemAtIndexPath(itemIndexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
        let finalLayoutAttributes = super.finalLayoutAttributesForDisappearingItemAtIndexPath(itemIndexPath)
        
        if deleted.contains({ $0.indexPathBeforeUpdate == itemIndexPath }) {
            finalLayoutAttributes?.alpha = 0.0
            
            if let initialLayoutAttributes = super.initialLayoutAttributesForAppearingItemAtIndexPath(itemIndexPath) {
                initialAppearingFrame = finalLayoutAttributes?.frame
                finalLayoutAttributes?.frame = initialLayoutAttributes.frame
            }
        }
        
        return finalLayoutAttributes
    }
    
}
