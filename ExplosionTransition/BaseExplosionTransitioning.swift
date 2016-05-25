//
//  ExplosionTransition.swift
//  CasualUX
//
//  Created by Lacy Rhoades on 5/22/16.
//  Copyright © 2016 Lacy Rhoades. All rights reserved.
//

import UIKit

enum ExplosionDirection {
    case In
    case Out
}

enum TranslationAxis {
    case X
    case Y
}

enum ExplosionPiece {
    case Up
    case Down
    case Left
    case Right
}

struct AnimatedViewPiece {
    let startingFrame: CGRect
    let endingFrame: CGRect
    let view: UIView
}

func CGRectTranslate(rect: CGRect, translation: CGFloat, axis: TranslationAxis) -> CGRect {
    switch axis {
    case .X:
        return CGRectMake(translation, rect.origin.y, rect.size.width, rect.size.height)
    case .Y:
        return CGRectMake(rect.origin.x, translation, rect.size.width, rect.size.height)
    }
    
}

class BaseExplosionTransitioning: NSObject {
    var leftPiece: AnimatedViewPiece?
    var rightPiece: AnimatedViewPiece?
    var bottomPiece: AnimatedViewPiece?
    var topPiece: AnimatedViewPiece?
    
    var zoomOutFrame: CGRect = CGRectZero
    var zoomingView: UIView?
    
    var duration: NSTimeInterval = 0.5
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return self.duration
    }
    
    func viewFromSliceRect(sliceRect: CGRect, fromView: UIView, piece: ExplosionPiece, explosionDirection: ExplosionDirection) -> AnimatedViewPiece {
        UIGraphicsBeginImageContextWithOptions(sliceRect.size, true, UIScreen.mainScreen().scale)
        let cropRect = CGRect(x: -1 * sliceRect.origin.x, y: -1 * sliceRect.origin.y, width: fromView.bounds.width, height: fromView.bounds.height)
        fromView.drawViewHierarchyInRect(cropRect, afterScreenUpdates: true)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        let pieceView = UIImageView(image: image)
        
        let startingFrame = sliceRect
        var endingFrame = sliceRect
        
        switch (piece) {
        case .Up:
            endingFrame.origin.y = endingFrame.origin.y - 700
            break;
        case .Down:
            endingFrame.origin.y = endingFrame.origin.y + 700
            break;
        case .Left:
            endingFrame.origin.x = endingFrame.origin.x - 500
            break;
        case .Right:
            endingFrame.origin.x = endingFrame.origin.x + 500
            break;
        }
        
        if (explosionDirection == .Out) {
            pieceView.frame = startingFrame
            return AnimatedViewPiece(startingFrame: startingFrame, endingFrame: endingFrame, view: pieceView)
        } else {
            pieceView.frame = endingFrame
            return AnimatedViewPiece(startingFrame: endingFrame, endingFrame: startingFrame, view: pieceView)
        }
    }
    
    func snapshotView(view: UIView) -> UIView {
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.opaque, UIScreen.mainScreen().scale);
        view.layer.renderInContext(UIGraphicsGetCurrentContext()!);
        let img = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return UIImageView(image: img)
    }
}