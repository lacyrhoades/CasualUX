//
//  ViewController.swift
//  CasualUX
//
//  Created by Lacy Rhoades on 11/2/15.
//  Copyright © 2015 Lacy Rhoades. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var collectionView: UICollectionView!
    
    var layout: UICollectionViewFlowLayout!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.blackColor()
        
        self.layout = SpringyCollectionViewFlowLayout()
        self.layout.scrollDirection = .Horizontal
        self.layout.minimumLineSpacing = 15.0

        self.collectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: self.layout)
        self.collectionView.layer.borderColor = UIColor.whiteColor().CGColor
        self.collectionView.layer.borderWidth = 1.0
        self.collectionView.clipsToBounds = false
        self.collectionView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.collectionView)
        
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
        self.collectionView.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: "Ident")
        
        self.setupConstraints()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.collectionView.collectionViewLayout.invalidateLayout()
    }
    
    func setupConstraints() {
        let metrics = ["margin": 25]
        let views = ["collectionView": self.collectionView]
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
            "H:|-margin-[collectionView]-margin-|",
            options: [],
            metrics: metrics,
            views: views))
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
            "V:|-margin-[collectionView]-margin-|",
            options: [],
            metrics: metrics,
            views: views))
    }

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 300
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Ident", forIndexPath: indexPath)
        cell.backgroundColor = UIColor.lightGrayColor()
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        if (self.layout.scrollDirection == .Horizontal) {
            return CGSizeMake(50, self.collectionView.frame.height)
        } else {
            return CGSizeMake(self.collectionView.frame.width, 50)
        }
    }

}

