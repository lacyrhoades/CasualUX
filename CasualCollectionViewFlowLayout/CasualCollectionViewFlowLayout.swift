//
//  CasualCollectionViewFlowLayout.swift
//  CasualUX
//
//  Created by Lacy Rhoades on 11/2/15.
//  Copyright © 2015 Lacy Rhoades. All rights reserved.
//

import UIKit

class CasualCollectionViewFlowLayout : UICollectionViewFlowLayout {
    private var dynamicAnimator: UIDynamicAnimator!
    private var visibleItemPaths: Set<NSIndexPath>!

    override init() {
        super.init()
        
        self.dynamicAnimator = UIDynamicAnimator(collectionViewLayout: self)
        self.visibleItemPaths = Set()
        
        self.scrollDirection = .Horizontal
        self.minimumLineSpacing = 15.0
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.dynamicAnimator = UIDynamicAnimator(collectionViewLayout: self)
        self.visibleItemPaths = Set()
        
        self.scrollDirection = .Horizontal
        self.minimumLineSpacing = 15.0
    }
    
    override func layoutAttributesForElementsInRect(rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return self.dynamicAnimator.itemsInRect(rect) as? [UICollectionViewLayoutAttributes]
    }
    
    override func layoutAttributesForItemAtIndexPath(indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
        return self.dynamicAnimator.layoutAttributesForCellAtIndexPath(indexPath)
    }
    
    override func prepareLayout() {
        super.prepareLayout()
        
        let scrollView: UIScrollView = self.collectionView!
        let visibleRect = CGRectInset(scrollView.bounds, -100, -100)
        let itemsInVisibleRect = super.layoutAttributesForElementsInRect(visibleRect)!
        let indexPathsInVisibleRect = Set(itemsInVisibleRect.map({ (attribute) -> NSIndexPath in
            return attribute.indexPath
        }))
        
        // PART 1 - REMOVING any old behaviors as old cells go away
        let noLongerVisisbleBehaviors = self.dynamicAnimator.behaviors.filter { (eachBehavior) -> Bool in
            var currentlyVisible = false
            if let behavior = eachBehavior as? UIAttachmentBehavior, last = behavior.items.last as? UICollectionViewLayoutAttributes {
                currentlyVisible = indexPathsInVisibleRect.contains(last.indexPath)
            }
            return !currentlyVisible
        }
        
        for eachBehavior in noLongerVisisbleBehaviors {
            self.dynamicAnimator.removeBehavior(eachBehavior)
            if let behavior = eachBehavior as? UIAttachmentBehavior, last = behavior.items.last as? UICollectionViewLayoutAttributes {
                self.visibleItemPaths.remove(last.indexPath)
            }
        }
        
        // PART 2 - ADDING any new behaviors as new cells appear
        let newlyVisibleItems = itemsInVisibleRect.filter { (layoutAttribute) -> Bool in
            return !self.visibleItemPaths.contains(layoutAttribute.indexPath)
        }

        for item in newlyVisibleItems {
            let behavior = UIAttachmentBehavior(item: item, attachedToAnchor: item.center)
            behavior.length = 0.0
            behavior.frequency = 1
            behavior.damping = 1
            self.dynamicAnimator.addBehavior(behavior)
            
            self.visibleItemPaths.insert(item.indexPath)
        }
    }

    override func shouldInvalidateLayoutForBoundsChange(newBounds: CGRect) -> Bool {
        let delta = newBounds.origin.x - self.collectionView!.bounds.origin.x
        let velo = self.collectionView!.velocityOfPanGesture()
        
        for eachBehavior in self.dynamicAnimator.behaviors {
            if let behavior = eachBehavior as? UIAttachmentBehavior {
                let item = behavior.items.first as! UICollectionViewLayoutAttributes
                
                let panPoint = self.collectionView!.pointOfPanGesture()
                
                if (!CGRectContainsPoint(item.frame, panPoint)) {
                    let displacement = item.center.x - behavior.anchorPoint.x
                    if (fabs(displacement) > 0.0) {
                        var centerX = item.center.x
                        centerX += min(delta, displacement * delta / velo.x)
                        item.center.x = centerX
                        self.dynamicAnimator.updateItemUsingCurrentState(item)
                    } else if (item.center.x < panPoint.x && fabs(delta) > 0.0) {
                        var centerX = item.center.x
                        centerX += delta
                        item.center.x = centerX
                        self.dynamicAnimator.updateItemUsingCurrentState(item)
                    } else if (item.center.x > panPoint.x && fabs(delta) > 0.0) {
                        var centerX = item.center.x
                        centerX -= delta
                        item.center.x = centerX
                        self.dynamicAnimator.updateItemUsingCurrentState(item)
                    }
                }
            }
        }

        return false
    }
}

private extension UICollectionView {
    func velocityOfPanGesture() -> CGPoint {
        let panGesture = self.panGestureRecognizer
        
        if (panGesture.numberOfTouches() < 1) {
            return CGPointZero
        }
        
        return panGesture.velocityInView(self)
    }
    
    func pointOfPanGesture() -> CGPoint {
        return self.panGestureRecognizer.locationInView(self)
    }
}
