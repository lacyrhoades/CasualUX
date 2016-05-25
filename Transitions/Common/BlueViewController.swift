//
//  BlueViewController.swift
//  CasualUX
//
//  Created by Lacy Rhoades on 5/22/16.
//  Copyright © 2016 Lacy Rhoades. All rights reserved.
//

import UIKit

class BlueViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.blueColor()
        
        let label = UILabel()
        label.frame = self.view.bounds
        label.text = "Done"
        label.textAlignment = .Center
        label.textColor = UIColor.whiteColor()
        self.view.addSubview(label)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTap))
        self.view.addGestureRecognizer(tap)
    }
    
    func didTap() {
        if let vc = self.presentingViewController {
            vc.dismissViewControllerAnimated(true) {
                // done
            }
        }
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
}
