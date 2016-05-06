//
//  Dimmable.swift
//  ExpandingCollectionView
//
//  Created by Saul on 5/5/16.
//  Copyright © 2016 Andrew Copp. All rights reserved.
//

import Foundation
import UIKit

protocol Dimmable {
    var overlayView: UIView { get set }
    func fadeInOverlayView()
    func fadeOutOverlayView()
}

extension Dimmable where Self: UIView {
    func fadeInOverlayView() {
        overlayView.frame = bounds
        overlayView.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.5)
        overlayView.alpha = 0
        addSubview(overlayView)
        UIView.animateWithDuration(0.3) {
            self.overlayView.alpha = 1
        }
    }
    
    func fadeOutOverlayView() {
        UIView.animateWithDuration(0.3, animations: {
            self.overlayView.alpha = 0
        }) { (_) in
            self.overlayView.removeFromSuperview()
        }
    }
}