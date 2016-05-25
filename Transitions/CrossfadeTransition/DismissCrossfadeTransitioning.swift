//
//  DismissCrossfadeTransitioning.swift
//  CasualUX
//
//  Created by Lacy Rhoades on 5/24/16.
//  Copyright © 2016 Lacy Rhoades. All rights reserved.
//

import UIKit

class DismissCrossfadeTransitioning: BaseCrossfadeTransitioning, UIViewControllerAnimatedTransitioning {

    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        guard let containerView = transitionContext.containerView(),
            fromVC = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey),
            fromView = transitionContext.viewForKey(UITransitionContextFromViewKey)
            else {
                assert(false, "Animation bailed out early")
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
                return
        }
        
        let finalFrame = transitionContext.finalFrameForViewController(fromVC)
        fromView.frame = finalFrame
        fromView.layoutIfNeeded()
        
        containerView.addSubview(fromView)
        containerView.bringSubviewToFront(fromView)
        
        fromView.alpha = 1.0
        
        UIView.animateWithDuration(self.duration, animations: { () -> Void in
            fromView.alpha = 0.0
        }) { (done) -> Void in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
        }
    }

}
