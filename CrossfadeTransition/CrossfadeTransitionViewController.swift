//
//  CrossfadeTransitionViewController.swift
//  CasualUX
//
//  Created by Lacy Rhoades on 5/24/16.
//  Copyright © 2016 Lacy Rhoades. All rights reserved.
//

import UIKit

class CrossfadeTransitionViewController: UIViewController {
    var centerView: UIView!
    var presentationDelegate: CrossfadeTransitioningDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let backgroundView = UIImageView(image: UIImage(named: "SampleImage"))
        backgroundView.contentMode = .ScaleAspectFill
        backgroundView.frame = self.view.bounds
        backgroundView.autoresizingMask = [UIViewAutoresizing.FlexibleHeight, UIViewAutoresizing.FlexibleWidth]
        backgroundView.backgroundColor = UIColor.lightGrayColor()
        self.view.addSubview(backgroundView)
        
        self.centerView = UIView()
        self.centerView.backgroundColor = UIColor.blueColor()
        self.centerView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.centerView)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapCenterView))
        self.centerView.addGestureRecognizer(tap)
        
        self.view.addConstraint(NSLayoutConstraint(item: self.centerView, attribute: .CenterX, relatedBy: .Equal, toItem: self.view, attribute: .CenterX, multiplier: 1, constant: 0))
        self.view.addConstraint(NSLayoutConstraint(item: self.centerView, attribute: .CenterY, relatedBy: .Equal, toItem: self.view, attribute: .CenterY, multiplier: 1, constant: 0))
        self.view.addConstraint(NSLayoutConstraint(item: self.centerView, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: 200))
        self.view.addConstraint(NSLayoutConstraint(item: self.centerView, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: 300))
    }
    
    func didTapCenterView() {
        let vc = BlueViewController()
        
        self.presentationDelegate = CrossfadeTransitioningDelegate()
        self.presentationDelegate.duration = 0.5
        
        vc.modalPresentationStyle = .Custom
        vc.transitioningDelegate = self.presentationDelegate
        self.presentViewController(vc, animated: true) {
            // done
        }
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return false
    }
}

