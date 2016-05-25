//
//  ExplosionTransitionDelegate.swift
//  CasualUX
//
//  Created by Lacy Rhoades on 5/22/16.
//  Copyright © 2016 Lacy Rhoades. All rights reserved.
//

import UIKit

class ExplosionTransitionDelegate: NSObject, UIViewControllerTransitioningDelegate {
    /// The view we're going to "zoom in" from
    var zoomingView: UIView!
    
    /// Duration of both transitions, default 0.5 sec
    var duration: NSTimeInterval = 0.5
    
    weak var geometryDelegate: ExplosionTransitionGeometryDelegate?
    
    /// Animations play out, or need to be updated
    var interactive: Bool = false
    
    /// If this exists, you can update it to interactively dismiss
    var dismissTransitioningController: UIPercentDrivenInteractiveTransition!
    
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let animator = PresentExplosionAnimatedTransitioning()
        animator.duration = self.duration
        
        animator.zoomOutFrame = self.zoomingView.convertRect(self.zoomingView.bounds, toView: source.view)
        animator.zoomingView = self.zoomingView.snapshotViewAfterScreenUpdates(true)
        
        return animator
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let animator = DismissExplosionAnimatedTransitioning()
        animator.duration = self.duration

        animator.zoomingView = dismissed.view.snapshotViewAfterScreenUpdates(true)
        
        if let delegate = self.geometryDelegate {
            animator.zoomOutFrame = delegate.zoomOutRect()
        }
        
        return animator
    }
    
    func interactionControllerForDismissal(animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        if (self.interactive) {
            self.dismissTransitioningController = UIPercentDrivenInteractiveTransition()
            return self.dismissTransitioningController
        } else {
            return nil
        }
    }
}

