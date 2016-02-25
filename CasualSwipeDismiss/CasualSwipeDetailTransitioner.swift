//
//  CasualSwipeDetailTransitioner.swift
//  CasualUX
//
//  Created by Lacy Rhoades on 2/25/16.
//  Copyright © 2016 Lacy Rhoades. All rights reserved.
//

import UIKit

class CasualSwipeDetailTransitioner: NSObject, UIViewControllerTransitioningDelegate {
    var interactive: Bool = false
    var fromView: UIView!
    var dismissTransitioningController: UIPercentDrivenInteractiveTransition!
    
    private var zoomOutFrame: CGRect = CGRectZero
    private var snapshotView: UIView!
    
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        let animator = PresentFeedDetailAnimatedTransitioning()
        
        self.zoomOutFrame = self.fromView.convertRect(self.fromView.bounds, toView: source.view)
        animator.zoomOutFrame = self.zoomOutFrame
        
        self.snapshotView = self.fromView.snapshotViewAfterScreenUpdates(true)
        animator.snapshotView = self.snapshotView

        return animator
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        let animator = DismissFeedDetailAnimatedTransitioning()
        
        animator.zoomOutFrame = self.zoomOutFrame
        animator.snapshotView = self.snapshotView
        
        return animator
    }
    
    func interactionControllerForDismissal(animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        if (interactive) {
            self.dismissTransitioningController = UIPercentDrivenInteractiveTransition()
            return self.dismissTransitioningController
        } else {
            return nil
        }
    }
}

class PresentFeedDetailAnimatedTransitioning: NSObject, UIViewControllerAnimatedTransitioning {
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return self.duration
    }
    
    var duration = 0.5
    
    var zoomOutFrame: CGRect = CGRectZero
    var snapshotView: UIView!
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        let toVC = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)!
        let toView = toVC.view
        
        let fromVC = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)!
        let fromView = fromVC.view
        
        let coverupView = UIView()
        coverupView.backgroundColor = UIColor.blackColor()
        coverupView.frame = fromView.bounds
        
        let topCutY = fromView.bounds.height - 120
        UIGraphicsBeginImageContextWithOptions(fromView.bounds.size, false, UIScreen.mainScreen().scale)
        fromView.drawViewHierarchyInRect(CGRect(x: 0, y: topCutY, width: fromView.bounds.width, height: fromView.bounds.height), afterScreenUpdates: true)
        let topImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        let rightMargin = fromView.frame.width - (zoomOutFrame.origin.x + zoomOutFrame.width + 2.0)
        let rightCutX = fromView.bounds.width - rightMargin
        UIGraphicsBeginImageContextWithOptions(fromView.bounds.size, false, UIScreen.mainScreen().scale)
        fromView.drawViewHierarchyInRect(CGRect(x: -1 * rightCutX, y: 0.0, width: fromView.bounds.width, height: fromView.bounds.height), afterScreenUpdates: true)
        let rightImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        let leftMargin = zoomOutFrame.origin.x - 2.0
        let leftCutX = fromView.bounds.width - leftMargin
        UIGraphicsBeginImageContextWithOptions(fromView.bounds.size, false, UIScreen.mainScreen().scale)
        fromView.drawViewHierarchyInRect(CGRect(x: leftCutX, y: 0.0, width: fromView.bounds.width, height: fromView.bounds.height), afterScreenUpdates: true)
        let leftImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        let bottomMargin = fromView.bounds.height - (zoomOutFrame.origin.y + zoomOutFrame.height) - 28.0
        let bottomCutY = bottomMargin - fromView.bounds.height
        UIGraphicsBeginImageContextWithOptions(fromView.bounds.size, false, UIScreen.mainScreen().scale)
        fromView.drawViewHierarchyInRect(CGRect(x: 0, y: bottomCutY, width: fromView.bounds.width, height: fromView.bounds.height), afterScreenUpdates: true)
        let bottomImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        let topPiece = UIImageView(image: topImage)
        let rightPiece = UIImageView(image: rightImage)
        let leftPiece = UIImageView(image: leftImage)
        let bottomPiece = UIImageView(image: bottomImage)
        
        var topFrame = topPiece.frame
        topFrame.origin.y = -1 * topCutY
        topPiece.frame = topFrame
        topFrame.origin.y = -700
        let farAwayTopFrame = topFrame
        
        var rightFrame = rightPiece.frame
        rightFrame.origin.x = rightCutX
        rightPiece.frame = rightFrame
        rightFrame.origin.x = 500
        let farAwayRightFrame = rightFrame
        
        var leftFrame = leftPiece.frame
        leftFrame.origin.x = -1 * leftCutX
        leftPiece.frame = leftFrame
        leftFrame.origin.x = -500
        let farAwayLeftFrame = leftFrame
        
        var bottomFrame = bottomPiece.frame
        bottomFrame.origin.y = -1 * bottomCutY
        bottomPiece.frame = bottomFrame
        bottomFrame.origin.y = 700
        let farAwayBottomFrame = bottomFrame
        
        let contView = transitionContext.containerView()
        
        contView?.addSubview(coverupView)
        contView?.addSubview(topPiece)
        contView?.addSubview(rightPiece)
        contView?.addSubview(leftPiece)
        contView?.addSubview(bottomPiece)
        
        let finalFrame = transitionContext.finalFrameForViewController(toVC)
        
        let imageView = self.snapshotView
        imageView.frame = self.zoomOutFrame
        contView?.addSubview(imageView)
        
        toView.alpha = 0.0
        contView?.addSubview(toView)
        
        toVC.view.frame = transitionContext.finalFrameForViewController(toVC)
        
        toVC.view.layoutIfNeeded()
        
        UIView.animateWithDuration(self.duration, animations: { () -> Void in
            imageView.frame = finalFrame
            topPiece.frame = farAwayTopFrame
            rightPiece.frame = farAwayRightFrame
            leftPiece.frame = farAwayLeftFrame
            bottomPiece.frame = farAwayBottomFrame
            }) { (done) -> Void in
                toView.alpha = 1.0
                imageView.removeFromSuperview()
                coverupView.removeFromSuperview()
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
        }
    }
}

class DismissFeedDetailAnimatedTransitioning: NSObject, UIViewControllerAnimatedTransitioning {
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return self.duration
    }
    
    var duration = 0.5
    
    var zoomOutFrame: CGRect = CGRectZero
    var snapshotView: UIView!
    
    var dismissalTransitionContext: UIViewControllerContextTransitioning!
    var dismissalImageView: UIView!
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        self.dismissalTransitionContext = transitionContext
        
        let fromView = transitionContext.viewForKey(UITransitionContextFromViewKey)!
        fromView.alpha = 0.0
        
        let finalFrame = self.zoomOutFrame
        
        self.dismissalImageView = self.snapshotView
        self.dismissalImageView.frame = fromView.frame
        transitionContext.containerView()?.addSubview(self.dismissalImageView)
        
        var interstitialFrame = self.dismissalImageView.frame
        interstitialFrame.origin.y += 70
        
        UIView.animateWithDuration(self.duration, animations: { () -> Void in
            self.dismissalImageView.frame = finalFrame
            }, completion: { (done2) -> Void in
                self.dismissalImageView.removeFromSuperview()
                if (transitionContext.transitionWasCancelled()) {
                    fromView.alpha = 1.0
                    transitionContext.completeTransition(false)
                } else {
                    fromView.removeFromSuperview()
                    transitionContext.completeTransition(true)
                }
        })
    }
    
    override func animationDidStop(anim: CAAnimation, finished flag: Bool) {
        self.dismissalImageView.removeFromSuperview()
        
        let fromView = self.dismissalTransitionContext.viewForKey(UITransitionContextFromViewKey)!
        if (self.dismissalTransitionContext.transitionWasCancelled()) {
            fromView.alpha = 1.0
            self.dismissalTransitionContext.completeTransition(false)
        } else {
            fromView.removeFromSuperview()
            self.dismissalTransitionContext.completeTransition(true)
        }
    }
}

extension CGRect {
    func center() -> CGPoint {
        var center = self.origin
        center.x += self.size.width / 2.0
        center.y += self.size.height / 2.0
        return center
    }
}
