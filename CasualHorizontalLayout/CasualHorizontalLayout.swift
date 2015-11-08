//
//  CasualHorizontalLayout.swift
//  CasualUX
//
//  Created by Lacy Rhoades on 11/2/15.
//  Copyright © 2015 Lacy Rhoades. All rights reserved.
//

import UIKit

class CasualHorizontalLayout : UICollectionViewFlowLayout {
    
    var resistance: CGFloat = 500.0
    var length: CGFloat = 0.0
    var damping: CGFloat = 1.0
    var frequency: CGFloat = 1.0
    
    private var dynamicAnimator: UIDynamicAnimator!
    
    private var visiblePaths: Set<NSIndexPath>!
    private var latestDelta: CGFloat = 0
    
    override init() {
        super.init()
        self.scrollDirection = .Horizontal
        self.minimumLineSpacing = 15
        
        self.dynamicAnimator = UIDynamicAnimator(collectionViewLayout: self)
        self.visiblePaths = Set()
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    override func prepareLayout() {
        super.prepareLayout()
        
        guard let cv = self.collectionView else { return }
        
        let visibleRect = CGRectInset(cv.bounds, -100, -100)
        let itemsInVisibleRect = super.layoutAttributesForElementsInRect(visibleRect)!
        
        let itemsIndexPathsInVisibleRect = Set(itemsInVisibleRect.map({ (attribute) -> NSIndexPath in
            return attribute.indexPath
        }))
        
        
        // PART 1 - REMOVING any old behaviors as cells go away
        
        let noLongerVisisbleBehaviors = self.dynamicAnimator.behaviors.filter { (behavior) -> Bool in
            var currentlyVisible = false
            if let attachmentBehavior = behavior as? UIAttachmentBehavior, last = attachmentBehavior.items.last as? UICollectionViewLayoutAttributes {
                currentlyVisible = itemsIndexPathsInVisibleRect.contains(last.indexPath)
            }
            return !currentlyVisible
        }
        
        for behavior in noLongerVisisbleBehaviors {
            self.dynamicAnimator.removeBehavior(behavior)
            if let attachmentBehavior = behavior as? UIAttachmentBehavior, last = attachmentBehavior.items.last as? UICollectionViewLayoutAttributes {
                visiblePaths.remove(last.indexPath)
            }
        }
        
        
        // PART 2 - ADDING any new behaviors as cells appear
        
        let newlyVisibleItems = itemsInVisibleRect.filter { (layoutAttribute) -> Bool in
            return !visiblePaths.contains(layoutAttribute.indexPath)
        }
        
        let scrollView = self.collectionView!
        
        var panningTouchLocation: CGPoint
        if (scrollView.panGestureRecognizer.numberOfTouches() < 1) {
            panningTouchLocation = CGPointZero
        } else {
            panningTouchLocation = scrollView.panGestureRecognizer.locationOfTouch(0, inView: scrollView)
        }
        
        var pannedCellFrame: CGRect = CGRectZero
        if let view = scrollView.hitTest(panningTouchLocation, withEvent: nil), superview = view.superview as? UICollectionViewCell {
            pannedCellFrame = superview.frame
        };
        
        let panningLeft = (scrollView.panGestureRecognizer.velocityInView(scrollView).x < 0)
        
        var disturbanceOrigin: CGFloat
        if (panningLeft) {
            disturbanceOrigin = pannedCellFrame.origin.x + pannedCellFrame.size.width
        } else {
            disturbanceOrigin = pannedCellFrame.origin.x
        }
        
        for item in newlyVisibleItems {
            var center = item.center
            
            let springBehavior = UIAttachmentBehavior(item: item, attachedToAnchor: center)
            
            springBehavior.length = self.length
            springBehavior.damping = self.damping
            springBehavior.frequency = self.frequency
            
            if (!CGPointEqualToPoint(CGPointZero, panningTouchLocation)) {
                let distance = fabs(disturbanceOrigin - springBehavior.anchorPoint.x)
                let resistance = distance / self.resistance
                
                if (self.latestDelta < 0) {
                    center.x += max(self.latestDelta, self.latestDelta * resistance)
                } else {
                    center.x += min(self.latestDelta, self.latestDelta * resistance)
                }
                
                item.center = center
            }
            
            self.dynamicAnimator.addBehavior(springBehavior)
            
            self.visiblePaths.insert(item.indexPath)
        }
    }
    
    override func layoutAttributesForElementsInRect(rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return self.dynamicAnimator.itemsInRect(rect) as? [UICollectionViewLayoutAttributes];
    }
    
    override func layoutAttributesForItemAtIndexPath(indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
        return self.dynamicAnimator.layoutAttributesForCellAtIndexPath(indexPath)
    }
    
    override func shouldInvalidateLayoutForBoundsChange(newBounds: CGRect) -> Bool {
        let scrollView = self.collectionView!
        
        var panningTouchLocation: CGPoint
        if (scrollView.panGestureRecognizer.numberOfTouches() < 1) {
            panningTouchLocation = CGPointZero
        } else {
            panningTouchLocation = scrollView.panGestureRecognizer.locationOfTouch(0, inView: scrollView)
        }
        
        var pannedCellFrame: CGRect = CGRectZero
        if let view = scrollView.hitTest(panningTouchLocation, withEvent: nil), superview = view.superview as? UICollectionViewCell {
            pannedCellFrame = superview.frame
        };
        
        let panningLeft = (scrollView.panGestureRecognizer.velocityInView(scrollView).x < 0)
        
        var disturbanceOrigin: CGFloat
        if (panningLeft) {
            disturbanceOrigin = pannedCellFrame.origin.x + pannedCellFrame.size.width
        } else {
            disturbanceOrigin = pannedCellFrame.origin.x
        }
        
        self.latestDelta = newBounds.origin.x - scrollView.bounds.origin.x
        
        for behavior in self.dynamicAnimator.behaviors {
            let attachmentBehavior = behavior as! UIAttachmentBehavior
            
            let distance = fabs(disturbanceOrigin - attachmentBehavior.anchorPoint.x)
            let resistance = distance / self.resistance
            
            let item = attachmentBehavior.items.first!
            
            var center = item.center
            
            var shouldUseBehavior = false;
            
            if (panningLeft) {
                shouldUseBehavior = attachmentBehavior.anchorPoint.x > disturbanceOrigin
            } else {
                shouldUseBehavior =  attachmentBehavior.anchorPoint.x < disturbanceOrigin
            }
            
            if (shouldUseBehavior) {
                if (self.latestDelta < 0) {
                    center.x += max(self.latestDelta, self.latestDelta * resistance)
                } else {
                    center.x += min(self.latestDelta, self.latestDelta * resistance)
                }
            }
            
            item.center = center
            
            self.dynamicAnimator.updateItemUsingCurrentState(item)
        }
        
        return false
    }
}
