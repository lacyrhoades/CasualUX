//
//  ViewController.swift
//  CasualUX
//
//  Created by Lacy Rhoades on 11/2/15.
//  Copyright © 2015 Lacy Rhoades. All rights reserved.
//

import UIKit

class CollectionViewViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var collectionView: UICollectionView!
    
    var layout: UICollectionViewFlowLayout!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.blackColor()

        self.collectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: self.layout)
        self.collectionView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.collectionView)
        
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
        self.collectionView.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: "Ident")
        
        self.setupConstraints()
    }

    func setupConstraints() {
        let metrics = ["margin": 0]
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
        return 10
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Ident", forIndexPath: indexPath)
        switch (indexPath.row % 4) {
            case 0:
                cell.backgroundColor = UIColor.lightGrayColor()
                break;
            case 1:
                cell.backgroundColor = UIColor.yellowColor()
                break;
            case 2:
                cell.backgroundColor = UIColor.whiteColor()
                break;
            default:
                cell.backgroundColor = UIColor.darkGrayColor()
                break;
        }
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        if (self.layout.scrollDirection == .Horizontal) {
            return CGSizeMake(100, self.collectionView.frame.height)
        } else {
            return CGSizeMake(self.collectionView.frame.width, 100)
        }
    }

}

