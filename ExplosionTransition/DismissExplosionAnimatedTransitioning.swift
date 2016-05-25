//
//  DismissExplosionAnimatedTransitioning.swift
//  CasualUX
//
//  Created by Lacy Rhoades on 5/22/16.
//  Copyright © 2016 Lacy Rhoades. All rights reserved.
//

import UIKit

class DismissExplosionAnimatedTransitioning: BaseExplosionTransitioning, UIViewControllerAnimatedTransitioning {
    var dismissalTransitionContext: UIViewControllerContextTransitioning!
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        guard let containerView = transitionContext.containerView(),
            fromView = transitionContext.viewForKey(UITransitionContextFromViewKey),
            toVC = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey),
            zoomingView = self.zoomingView else {
                assert(false, "Animation bailed out early")
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
                return
        }
        
        let snapshotView = toVC.view.snapshotViewAfterScreenUpdates(true)
        UIGraphicsBeginImageContextWithOptions(snapshotView.bounds.size, true, UIScreen.mainScreen().scale)
        snapshotView.drawViewHierarchyInRect(snapshotView.bounds, afterScreenUpdates: true)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        let snapshot = UIImageView(image:image)
        
        self.dismissalTransitionContext = transitionContext
        
        let coverupView = UIView()
        coverupView.backgroundColor = UIColor.blackColor()
        coverupView.frame = fromView.bounds
        containerView.addSubview(coverupView)
        
        let y1 = self.zoomOutFrame.origin.y
        let y2 = y1 + self.zoomOutFrame.size.height
        
        let x1 = self.zoomOutFrame.origin.x
        let x2 = x1 + self.zoomOutFrame.size.width
        
        var startFrame = CGRect(x: 0, y: y1, width: x1, height: y2 - y1)
        self.leftPiece = self.viewFromSliceRect(startFrame, fromView: snapshot, piece: .Left, explosionDirection: .In)
        
        startFrame = CGRect(x: x2, y: y1, width: snapshot.bounds.width - x2, height: y2 - y1)
        self.rightPiece = self.viewFromSliceRect(startFrame, fromView: snapshot, piece: .Right, explosionDirection: .In)
        
        startFrame = CGRect(x: 0, y: y2, width: snapshot.bounds.width, height: snapshot.bounds.height - y2)
        self.bottomPiece = self.viewFromSliceRect(startFrame, fromView: snapshot, piece: .Down, explosionDirection: .In)
        
        startFrame = CGRect(x: 0, y: 0, width: snapshot.bounds.width, height: y1)
        self.topPiece = self.viewFromSliceRect(startFrame, fromView: snapshot, piece: .Up, explosionDirection: .In)
        
        containerView.addSubview(self.leftPiece!.view)
        containerView.addSubview(self.rightPiece!.view)
        containerView.addSubview(self.bottomPiece!.view)
        containerView.addSubview(self.topPiece!.view)
        
        containerView.addSubview(zoomingView)
        
        fromView.alpha = 0.0
        UIView.animateWithDuration(self.duration, animations: { () -> Void in
            zoomingView.frame = self.zoomOutFrame
            
            self.leftPiece!.view.frame = self.leftPiece!.endingFrame
            self.rightPiece!.view.frame = self.rightPiece!.endingFrame
            self.bottomPiece!.view.frame = self.bottomPiece!.endingFrame
            self.topPiece!.view.frame = self.topPiece!.endingFrame
        }) { (done) -> Void in
            coverupView.removeFromSuperview()
            
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
        }
        
    }
    
    override func animationDidStop(anim: CAAnimation, finished flag: Bool) {
        if let zoomingView = self.zoomingView {
            zoomingView.removeFromSuperview()
        }
        
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
