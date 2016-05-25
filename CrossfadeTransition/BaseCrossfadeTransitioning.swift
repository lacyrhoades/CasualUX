//
//  BaseCrossfadeTransitioning.swift
//  CasualUX
//
//  Created by Lacy Rhoades on 5/24/16.
//  Copyright © 2016 Lacy Rhoades. All rights reserved.
//

import UIKit

class BaseCrossfadeTransitioning: NSObject {
    
    var duration: NSTimeInterval = 0.5
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return self.duration
    }
    
}

