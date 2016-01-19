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
    private var visiblePaths: Set<NSIndexPath>!
    private var latestDelta: CGFloat = 0
    
    override init() {
        super.init()
        
        self.dynamicAnimator = UIDynamicAnimator(collectionViewLayout: self)
        self.visiblePaths = Set()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.dynamicAnimator = UIDynamicAnimator(collectionViewLayout: self)
        self.visiblePaths = Set()
    }
    
    override func layoutAttributesForElementsInRect(rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return self.dynamicAnimator.itemsInRect(rect) as? [UICollectionViewLayoutAttributes]
    }
    
    override func layoutAttributesForItemAtIndexPath(indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
        return self.dynamicAnimator.layoutAttributesForCellAtIndexPath(indexPath)
    }
    
    override func layoutAttributesForSupplementaryViewOfKind(elementKind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
        return self.dynamicAnimator.layoutAttributesForSupplementaryViewOfKind(elementKind, atIndexPath: indexPath)
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
                visiblePaths.remove(last.indexPath)
            }
        }

        // PART 2 - ADDING any new behaviors as new cells appear
        
        let touchLocation = self.collectionView!.touchedCellCenter()

        let newlyVisibleItems = itemsInVisibleRect.filter { (layoutAttribute) -> Bool in
            return !visiblePaths.contains(layoutAttribute.indexPath)
        }
        
        for item in newlyVisibleItems {
            var center = item.center
            
            let behavior = UIAttachmentBehavior(item: item, attachedToAnchor: center)
            
            behavior.length = 0.0
            behavior.damping = 0.8
            behavior.frequency = 1.0
            
            if (!CGPointEqualToPoint(CGPointZero, touchLocation)) {
                let yDistanceFromTouch = fabs(touchLocation.y - behavior.anchorPoint.y)
                let xDistanceFromTouch = fabs(touchLocation.x - behavior.anchorPoint.x)
                let scrollResistance = (yDistanceFromTouch + xDistanceFromTouch) / 1500.0
                
                if (self.latestDelta < 0) {
                    center.x += max(self.latestDelta, self.latestDelta*scrollResistance);
                }
                else {
                    center.x += min(self.latestDelta, self.latestDelta*scrollResistance);
                }
                item.center = center;
            }
            
            self.dynamicAnimator.addBehavior(behavior)
            self.visiblePaths.insert(item.indexPath)
        }
    }

    
    override func shouldInvalidateLayoutForBoundsChange(newBounds: CGRect) -> Bool {
        let scrollView = self.collectionView! as UIScrollView
        
        let delta = newBounds.origin.x - scrollView.bounds.origin.x
        
        self.latestDelta = delta
        
        let touchLocation = self.collectionView!.touchedCellCenter()
        
        for eachBehavior in self.dynamicAnimator.behaviors {
            if let behavior = eachBehavior as? UIAttachmentBehavior {
                let yDistanceFromTouch = fabs(touchLocation.y - behavior.anchorPoint.y)
                let xDistanceFromTouch = fabs(touchLocation.x - behavior.anchorPoint.x)
                let scrollResistance = (yDistanceFromTouch + xDistanceFromTouch) / 1500.0
            
                let item = behavior.items.first as! UICollectionViewLayoutAttributes
            
                var center = item.center
                
                if (delta < 0) {
                    center.x += max(delta, delta*scrollResistance)
                } else {
                    center.x += min(delta, delta*scrollResistance)
                }

                item.center = center
                
                self.dynamicAnimator.updateItemUsingCurrentState(item)
            }
        }
        
        return false
    }   
}

private extension UICollectionView {
    func touchedCellCenter() -> CGPoint {
        let panGesture = self.panGestureRecognizer
        
        if (panGesture.numberOfTouches() < 1) {
            return CGPointZero
        }
        
        let panningTouchLocation = panGesture.locationOfTouch(0, inView: self)
        
        if let view = self.hitTest(panningTouchLocation, withEvent: nil), superview = view.superview as? UICollectionViewCell {
            return superview.center
        }

        return panningTouchLocation
    }
}
