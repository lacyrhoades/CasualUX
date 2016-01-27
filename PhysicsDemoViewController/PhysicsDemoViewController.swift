//
//  PhysicsDemoViewController.swift
//  CasualUX
//
//  Created by Lacy Rhoades on 1/21/16.
//  Copyright © 2016 Lacy Rhoades. All rights reserved.
//

import UIKit

class PhysicsDemoViewController: UIViewController, DraggableViewDelegate {
    var view1: DraggableView!
    var view2: DraggableView!
    
    var animator: UIDynamicAnimator!
    
    var behavior1: UIAttachmentBehavior!
    var behavior2: UIAttachmentBehavior!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.blackColor()
        
        let tap = UITapGestureRecognizer(target: self, action: "didTap:")
        self.view.addGestureRecognizer(tap)
        
        self.view1 = DraggableView()
        view1.delegate = self
        view1.frame = CGRectMake(10, 200, 100, 100)
        view1.backgroundColor = UIColor.grayColor()
        self.view.addSubview(view1)
        
        self.view2 = DraggableView()
        view2.delegate = self
        view2.frame = CGRectMake(self.view.bounds.size.width - 100 - 10, 200, 100, 100)
        view2.backgroundColor = UIColor.grayColor()
        self.view.addSubview(view2)
        
        let marker = UIView()
        marker.backgroundColor = UIColor.yellowColor()
        marker.frame = CGRectMake(self.view.bounds.size.width/2.0,200,1,1)
        self.view.addSubview(marker)
        
        self.animator = UIDynamicAnimator()
        
        let centerx = floor(self.view.bounds.size.width/2.0)
        
        self.behavior1 = UIAttachmentBehavior(item: view1, attachedToAnchor: CGPointMake(centerx, 200))
        self.behavior1.length = 0.0
        self.behavior1.damping = 1.0
        self.behavior1.frequency = 1.0
        animator.addBehavior(behavior1)
        
        self.behavior2 = UIAttachmentBehavior(item: view2, attachedToAnchor: CGPointMake(centerx, 200))
        self.behavior2.length = 0.0
        self.behavior2.damping = 1.0
        self.behavior2.frequency = 1.0
        animator.addBehavior(behavior2)
    }
    
    func didTap(tap: UITapGestureRecognizer) {
        view1.frame = CGRectMake(10, 200, 100, 100)
        view2.frame = CGRectMake(self.view.bounds.size.width - 100 - 10, 200, 100, 100)
        
        self.animator.removeBehavior(self.behavior1)
        self.animator.addBehavior(self.behavior1)
        self.animator.removeBehavior(self.behavior2)
        self.animator.addBehavior(self.behavior2)
    }
    
    func viewMoved(view: UIView) {
        self.animator.updateItemUsingCurrentState(view)
    }
}
