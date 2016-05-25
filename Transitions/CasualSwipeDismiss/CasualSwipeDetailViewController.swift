//
//  CasualSwipeDetailViewController.swift
//  CasualUX
//
//  Created by Lacy Rhoades on 2/25/16.
//  Copyright © 2016 Lacy Rhoades. All rights reserved.
//

import UIKit

class CasualSwipeDetailViewController: UIViewController {
    override func viewDidLoad() {
        self.view.backgroundColor = UIColor.yellowColor()
        
        let tap = UITapGestureRecognizer(target: self, action: "didTap")
        self.view.addGestureRecognizer(tap)
    }
    
    func didTap() {
        self.presentingViewController?.dismissViewControllerAnimated(true, completion: { () -> Void in
            // done.
        })
    }
}
