//
//  CasualHorizontalLayout.swift
//  CasualUX
//
//  Created by Lacy Rhoades on 11/2/15.
//  Copyright © 2015 Lacy Rhoades. All rights reserved.
//

import UIKit

class CasualCollectionViewFlowLayout : UICollectionViewFlowLayout {
    
    var resistance: CGFloat = 800
    var length: CGFloat = 0.0
    var damping: CGFloat = 1.0
    var frequency: CGFloat = 1.0
    
    private var dynamicAnimator: UIDynamicAnimator!
    
    private var visiblePaths: Set<NSIndexPath>!
    private var latestDelta: CGPoint = CGPointZero
    
    override init() {
        super.init()
        
        self.dynamicAnimator = UIDynamicAnimator(collectionViewLayout: self)
        self.visiblePaths = Set()
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError()
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
        
        let noLongerVisisbleBehaviors = self.dynamicAnimator.behaviors.filter { (behavior) -> Bool in
            var currentlyVisible = false
            if let attachmentBehavior = behavior as? UIAttachmentBehavior, last = attachmentBehavior.items.last as? UICollectionViewLayoutAttributes {
                currentlyVisible = indexPathsInVisibleRect.contains(last.indexPath)
            }
            return !currentlyVisible
        }
        
        for behavior in noLongerVisisbleBehaviors {
            self.dynamicAnimator.removeBehavior(behavior)
            if let attachmentBehavior = behavior as? UIAttachmentBehavior, last = attachmentBehavior.items.last as? UICollectionViewLayoutAttributes {
                visiblePaths.remove(last.indexPath)
            }
        }
        
        
        // PART 2 - ADDING any new behaviors as new cells appear
        
        let newlyVisibleItems = itemsInVisibleRect.filter { (layoutAttribute) -> Bool in
            return !visiblePaths.contains(layoutAttribute.indexPath)
        }
        
        let touchedCellCenter = self.collectionView!.touchedCellCenter()
        
        for item in newlyVisibleItems {
            var center = item.center
            
            let attachmentBehavior = UIAttachmentBehavior(item: item, attachedToAnchor: item.center)
            
            attachmentBehavior.length = self.length
            attachmentBehavior.damping = self.damping
            attachmentBehavior.frequency = self.frequency
            
            let distance = CGPointMake(
                fabs(touchedCellCenter.x - attachmentBehavior.anchorPoint.x),
                fabs(touchedCellCenter.y - attachmentBehavior.anchorPoint.y)
            )
            
            let resistance = CGPointMake(
                distance.x / self.resistance,
                distance.y / self.resistance
            )

            var shouldBeSpringy = false
            if (self.latestDelta.x > 0) {
                shouldBeSpringy = item.center.x > touchedCellCenter.x
            } else if (self.latestDelta.x < 0) {
                shouldBeSpringy = item.center.x < touchedCellCenter.x
            } else if (self.latestDelta.y > 0) {
                shouldBeSpringy = item.center.y > touchedCellCenter.y
            } else if (self.latestDelta.y < 0) {
                shouldBeSpringy = item.center.y < touchedCellCenter.y
            }
            
            if (shouldBeSpringy) {
                center.x += self.latestDelta.x * resistance.x
                center.y += self.latestDelta.y * resistance.y
            }
            
            item.center = center
            
            self.dynamicAnimator.addBehavior(attachmentBehavior)
            
            self.visiblePaths.insert(item.indexPath)
        }
    }
    
    override func layoutAttributesForElementsInRect(rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return self.dynamicAnimator.itemsInRect(rect) as? [UICollectionViewLayoutAttributes]
    }
    
    override func layoutAttributesForItemAtIndexPath(indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
        return self.dynamicAnimator.layoutAttributesForCellAtIndexPath(indexPath)
    }
    
    override func shouldInvalidateLayoutForBoundsChange(newBounds: CGRect) -> Bool {
        let touchedCellCenter = self.collectionView!.touchedCellCenter()
        
        let scrollView: UIScrollView = self.collectionView!
        
        self.latestDelta = CGPointMake(
            newBounds.origin.x - scrollView.bounds.origin.x,
            newBounds.origin.y - scrollView.bounds.origin.y
        )
        
        for behavior in self.dynamicAnimator.behaviors {
            let attachmentBehavior = behavior as! UIAttachmentBehavior
        
            let distance = CGPointMake(
                fabs(touchedCellCenter.x - attachmentBehavior.anchorPoint.x),
                fabs(touchedCellCenter.y - attachmentBehavior.anchorPoint.y)
            )
            
            let resistance = CGPointMake(
                distance.x / self.resistance,
                distance.y / self.resistance
            )
            
            let item = attachmentBehavior.items.first!
            
            var center = item.center
            
            var shouldBeSpringy = false
            if (self.latestDelta.x > 0) {
                shouldBeSpringy = item.center.x > touchedCellCenter.x
            } else if (self.latestDelta.x < 0) {
                shouldBeSpringy = item.center.x < touchedCellCenter.x
            } else if (self.latestDelta.y > 0) {
                shouldBeSpringy = item.center.y > touchedCellCenter.y
            } else if (self.latestDelta.y < 0) {
                shouldBeSpringy = item.center.y < touchedCellCenter.y
            }
            
            if (shouldBeSpringy) {
                center.x += self.latestDelta.x * resistance.x
                center.y += self.latestDelta.y * resistance.y
            }
            
            item.center = center
            
            self.dynamicAnimator.updateItemUsingCurrentState(item)
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
