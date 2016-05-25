//
//  PresentCrossfadeTransitioning.swift
//  CasualUX
//
//  Created by Lacy Rhoades on 5/24/16.
//  Copyright © 2016 Lacy Rhoades. All rights reserved.
//

import UIKit

class PresentCrossfadeTransitioning: BaseCrossfadeTransitioning, UIViewControllerAnimatedTransitioning {
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        guard let containerView = transitionContext.containerView(),
            toVC = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey),
            toView = transitionContext.viewForKey(UITransitionContextToViewKey)
            else {
                assert(false, "Animation bailed out early")
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
                return
        }
        
        let finalFrame = transitionContext.finalFrameForViewController(toVC)
        toView.frame = finalFrame
        toView.layoutIfNeeded()
        
        containerView.addSubview(toView)
        containerView.bringSubviewToFront(toView)
        
        toView.alpha = 0.0
        
        UIView.animateWithDuration(self.duration, animations: { () -> Void in
            toView.alpha = 1.0
        }) { (done) -> Void in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
        }
    }

}
