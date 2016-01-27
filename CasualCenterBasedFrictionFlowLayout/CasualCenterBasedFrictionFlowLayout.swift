//
//  CasualCenterBasedFrictionFlowLayout.swift
//  CasualUX
//
//  Created by Lacy Rhoades on 1/25/16.
//  Copyright © 2016 Lacy Rhoades. All rights reserved.
//

import UIKit

class CasualCenterBasedFrictionFlowLayout: UICollectionViewFlowLayout {
    var marign: CGFloat = 68.0
    var spread: CGFloat = 40.0
    
    override init() {
        super.init()
        
        self.scrollDirection = .Horizontal
        self.minimumLineSpacing = 15.0
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    override func layoutAttributesForElementsInRect(rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let oldItems = super.layoutAttributesForElementsInRect(rect)!
        
        var newItems: Array<UICollectionViewLayoutAttributes> = []
        
        for eachItem in oldItems {
            let item = eachItem.copy() as! UICollectionViewLayoutAttributes
            
            let convertedItemFrame = CGRectOffset(item.frame, -1 * self.collectionView!.contentOffset.x, -1 * self.collectionView!.contentOffset.y)
            let itemLeftEdge = convertedItemFrame.origin.x
            let cvWidth = self.collectionView!.frame.size.width
            let centerX = (cvWidth - self.spread) / 2.0
            let leftMargin = self.marign
            
            if (itemLeftEdge < centerX && itemLeftEdge > leftMargin) {
                let distance = itemLeftEdge - self.marign
                let remainingDistance = centerX - self.marign
                item.frame.origin.x += (distance / remainingDistance) * self.spread
            } else if (itemLeftEdge >= centerX) {
                item.frame.origin.x += self.spread
            }
            
            newItems.append(item)
        }
        
        return newItems
    }
    
    override func shouldInvalidateLayoutForBoundsChange(newBounds: CGRect) -> Bool {
        return true
    }
}
