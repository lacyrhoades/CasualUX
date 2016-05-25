//
//  CrossfadeTransitioningDelegate.swift
//  CasualUX
//
//  Created by Lacy Rhoades on 5/24/16.
//  Copyright © 2016 Lacy Rhoades. All rights reserved.
//

import UIKit


class CrossfadeTransitioningDelegate: NSObject, UIViewControllerTransitioningDelegate {
    var duration = 0.5
    
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let animator = PresentCrossfadeTransitioning()
        return animator
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let animator = DismissCrossfadeTransitioning()
        return animator
    }
}