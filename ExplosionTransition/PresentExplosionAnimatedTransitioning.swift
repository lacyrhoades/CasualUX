//
//  PresentExplosionAnimatedTransitioning.swift
//  CasualUX
//
//  Created by Lacy Rhoades on 5/22/16.
//  Copyright © 2016 Lacy Rhoades. All rights reserved.
//

import UIKit

class PresentExplosionAnimatedTransitioning: BaseExplosionTransitioning, UIViewControllerAnimatedTransitioning {
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        
        guard let containerView = transitionContext.containerView(),
            fromVC = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey),
            toVC = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey),
            toView = transitionContext.viewForKey(UITransitionContextToViewKey),
            zoomingView = self.zoomingView
            else {
                assert(false, "Animation bailed out early")
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
                return
        }
        
        let snapshotView = fromVC.view.snapshotViewAfterScreenUpdates(true)
        UIGraphicsBeginImageContextWithOptions(snapshotView.bounds.size, true, UIScreen.mainScreen().scale)
        snapshotView.drawViewHierarchyInRect(snapshotView.bounds, afterScreenUpdates: true)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        let snapshot = UIImageView(image:image)
        
        let coverupView = UIView()
        coverupView.backgroundColor = UIColor.blackColor()
        coverupView.frame = snapshot.bounds
        containerView.addSubview(coverupView)
        
        let y1 = self.zoomOutFrame.origin.y
        let y2 = y1 + self.zoomOutFrame.size.height
        
        let x1 = self.zoomOutFrame.origin.x
        let x2 = x1 + self.zoomOutFrame.size.width
        
        var startFrame = CGRect(x: 0, y: y1, width: x1, height: y2 - y1)
        self.leftPiece = self.viewFromSliceRect(startFrame, fromView: snapshot, piece: .Left, explosionDirection: .Out)
        
        startFrame = CGRect(x: x2, y: y1, width: snapshot.bounds.width - x2, height: y2 - y1)
        self.rightPiece = self.viewFromSliceRect(startFrame, fromView: snapshot, piece: .Right, explosionDirection: .Out)
        
        startFrame = CGRect(x: 0, y: y2, width: snapshot.bounds.width, height: snapshot.bounds.height - y2)
        self.bottomPiece = self.viewFromSliceRect(startFrame, fromView: snapshot, piece: .Down, explosionDirection: .Out)
        
        startFrame = CGRect(x: 0, y: 0, width: snapshot.bounds.width, height: y1)
        self.topPiece = self.viewFromSliceRect(startFrame, fromView: snapshot, piece: .Up, explosionDirection: .Out)
        
        containerView.addSubview(self.leftPiece!.view)
        containerView.addSubview(self.rightPiece!.view)
        containerView.addSubview(self.bottomPiece!.view)
        containerView.addSubview(self.topPiece!.view)
        
        zoomingView.frame = self.zoomOutFrame
        containerView.addSubview(zoomingView)
        
        let finalFrame = transitionContext.finalFrameForViewController(toVC)
        toView.frame = finalFrame
        toView.layoutIfNeeded()
        
        containerView.addSubview(toView)
        containerView.bringSubviewToFront(toView)
        
        toView.alpha = 0.0
        
        UIView.animateWithDuration(self.duration, animations: { () -> Void in
            zoomingView.frame = finalFrame
            
            self.leftPiece!.view.frame = self.leftPiece!.endingFrame
            self.rightPiece!.view.frame = self.rightPiece!.endingFrame
            self.bottomPiece!.view.frame = self.bottomPiece!.endingFrame
            self.topPiece!.view.frame = self.topPiece!.endingFrame
        }) { (done) -> Void in
            toVC.view.alpha = 1.0
            coverupView.removeFromSuperview()
            zoomingView.removeFromSuperview()
            
            self.leftPiece?.view.removeFromSuperview()
            self.rightPiece?.view.removeFromSuperview()
            self.bottomPiece?.view.removeFromSuperview()
            self.topPiece?.view.removeFromSuperview()
            
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
        }
        
    }
    
}
