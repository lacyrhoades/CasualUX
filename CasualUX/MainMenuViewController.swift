//
//  MainMenuViewController.swift
//  CasualUX
//
//  Created by Lacy Rhoades on 1/25/16.
//  Copyright © 2016 Lacy Rhoades. All rights reserved.
//

import UIKit

struct MenuItem {
    var title: String!
    var vc: UIViewController!
}

class MainMenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var tableView: UITableView!
    var menuItems: Array<MenuItem>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.blackColor()
        
        self.menuItems = []
        
        do {
            let vc = TransitionViewController()
            let del = ExplosionTransitionDelegate()
            del.duration = 0.5
            del.zoomingView = vc.centerView
            del.geometryDelegate = vc
            vc.presentationDelegate = del
            self.addViewController(vc, title: "Explosion Transition")
        }
        
        do {
            let vc = TransitionViewController()
            let del = CrossfadeTransitioningDelegate()
            del.duration = 0.5
            vc.presentationDelegate = del
            self.addViewController(vc, title: "Crossfade Transition")
        }
        
        do {
            let vc = CasualSwipeStartingViewController()
            self.addViewController(vc, title: "Interactive Swipe Transition")
        }
        
        do {
            let vc = CollectionViewViewController()
            vc.layout = CasualCenterBasedFrictionFlowLayout()
            self.addViewController(vc, title: "Center-based Friction Layout")
        }
        
        do {
            let vc = CollectionViewViewController()
            vc.layout = CasualCollectionViewFlowLayout()
            self.addViewController(vc, title: "Casual Flow Layout")
        }
        
        do {
            let vc = CollectionViewViewController()
            vc.layout = SpringyCollectionViewFlowLayout()
            self.addViewController(vc, title: "Springy Flow Layout")
        }
        
        self.tableView = UITableView()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.tableView)
        
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "MenuTableCell")
        
        self.setupConstraints()
    }
    
    func addViewController(vc: UIViewController, title: String) {
        vc.modalTransitionStyle = UIModalTransitionStyle.CrossDissolve
        self.menuItems.append(MenuItem(title: title, vc: vc))
    }
    
    func setupConstraints() {
        let metrics = ["margin": 25]
        let views = ["table": self.tableView]
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
            "H:|-margin-[table]-margin-|",
            options: [],
            metrics: metrics,
            views: views))
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
            "V:|-margin-[table]-margin-|",
            options: [],
            metrics: metrics,
            views: views))
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("MenuTableCell", forIndexPath: indexPath)
        cell.textLabel?.text = self.menuItems[indexPath.row].title
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 44.0
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.menuItems.count;
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.tableView .deselectRowAtIndexPath(indexPath, animated: true)
        
        let menuItem = self.menuItems[indexPath.row]
        let vc = menuItem.vc
        self.presentViewController(vc, animated: true) { () -> Void in
            //
        }
    }
    
}

