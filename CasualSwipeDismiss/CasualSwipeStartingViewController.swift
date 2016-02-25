//
//  CasualSwipeStartingViewController.swift
//  CasualUX
//
//  Created by Lacy Rhoades on 2/25/16.
//  Copyright © 2016 Lacy Rhoades. All rights reserved.
//

import UIKit

class CasualSwipeStartingViewController: UIViewController {
    var animationTransitioner: CasualSwipeDetailTransitioner!
    
    var tappableView: UIView!
    
    override func viewDidLoad() {
        let width = self.view.bounds.size.width / 2.0
        let height = self.view.bounds.size.height / 2.0
        
        let x = (self.view.bounds.size.width - width) / 2.0
        let y = (self.view.bounds.size.height - height) / 2.0

        self.tappableView = UIView(frame: CGRect(x: x, y: y, width: width, height:height))
        self.tappableView.backgroundColor = UIColor.yellowColor()
        
        self.view.addSubview(self.tappableView)
        
        let tap = UITapGestureRecognizer(target: self, action: "didTap")
        self.tappableView.addGestureRecognizer(tap)
    }
    
    func didTap() {
        self.animationTransitioner = CasualSwipeDetailTransitioner()
        self.animationTransitioner.interactive = false
        self.animationTransitioner.fromView = self.tappableView
        
        let vc = CasualSwipeDetailViewController()
        vc.transitioningDelegate = self.animationTransitioner
        self.presentViewController(vc, animated: true) { () -> Void in
            // done
        }
    }
}
