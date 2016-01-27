//
//  DraggableView.swift
//  CasualUX
//
//  Created by Lacy Rhoades on 1/21/16.
//  Copyright © 2016 Lacy Rhoades. All rights reserved.
//

import UIKit

protocol DraggableViewDelegate {
    func viewMoved(view: UIView)
}

class DraggableView: UIView {
    var delegate: DraggableViewDelegate?
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch in touches {
            let xdiff = touch.previousLocationInView(self).x - touch.locationInView(self).x
            self.frame.origin.x -= xdiff
            print(self.frame.origin.x)
            // self.frame.origin.y = touch.locationInView(self.superview).y
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let delegate = self.delegate {
            delegate.viewMoved(self)
        }
    }
}
