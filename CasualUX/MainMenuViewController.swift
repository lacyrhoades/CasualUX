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
        
        var vc = CollectionViewViewController()
        vc.modalTransitionStyle = UIModalTransitionStyle.CrossDissolve
        vc.layout = CasualCenterBasedFrictionFlowLayout()
        self.menuItems.append(MenuItem(title: "Simple Friction (center-based)", vc: vc))
        
        vc = CollectionViewViewController()
        vc.modalTransitionStyle = UIModalTransitionStyle.CrossDissolve
        vc.layout = CasualCollectionViewFlowLayout()
        self.menuItems.append(MenuItem(title: "Friction Collection (physics)", vc: vc))
        
        vc = CollectionViewViewController()
        vc.modalTransitionStyle = UIModalTransitionStyle.CrossDissolve
        vc.layout = SpringyCollectionViewFlowLayout()
        self.menuItems.append(MenuItem(title: "Springy Collection (physics)", vc:vc))
        
        let vc2 = UIViewController()
        vc2.modalTransitionStyle = UIModalTransitionStyle.CrossDissolve
        self.menuItems.append(MenuItem(title: "Physics Demo", vc:vc2))
        
        self.tableView = UITableView()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.tableView)
        
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "MenuTableCell")
        
        self.setupConstraints()
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

