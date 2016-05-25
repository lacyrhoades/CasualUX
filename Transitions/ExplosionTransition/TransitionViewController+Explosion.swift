//
//  TransitionViewController+Explosion.swift
//  CasualUX
//
//  Created by Lacy Rhoades on 5/25/16.
//  Copyright © 2016 Lacy Rhoades. All rights reserved.
//

import UIKit

extension TransitionViewController: ExplosionTransitionGeometryDelegate {
    func zoomOutRect() -> CGRect {
        return self.centerView.frame
    }
}