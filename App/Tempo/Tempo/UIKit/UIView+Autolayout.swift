//
//  UIView+Autolayout.swift
//  HarmonyKit
//
//  Created by Erik.Kerber on 11/24/15.
//  Copyright © 2015 Target. All rights reserved.
//

import UIKit

/// All-to-common utility for pinning a subviews edges to it's parentview edges.
public extension UIView {
    public func pinSubview(subview: UIView) {
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[subview]-0-|", options: .DirectionLeadingToTrailing, metrics: nil, views: ["subview": subview]))
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[subview]-0-|", options: .DirectionLeadingToTrailing, metrics: nil, views: ["subview": subview]))
    }
    
    public func addAndPinSubview(subview: UIView) {
        addSubview(subview)
        pinSubview(subview)
    }
    
    public func addAndCenterSubview(subview: UIView) {
        addSubview(subview)
        centerSubview(subview)
    }
    
    func pinSubviewToMargins(subview: UIView) {
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-[subview]-|", options: .DirectionLeadingToTrailing, metrics: nil, views: ["subview": subview]))
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-[subview]-|", options: .DirectionLeadingToTrailing, metrics: nil, views: ["subview": subview]))
    }
    
    func centerSubview(subview: UIView) {
        addConstraints([
            NSLayoutConstraint(item: subview, attribute: .CenterX, relatedBy: .Equal, toItem: self, attribute: .CenterX, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: subview, attribute: .CenterY, relatedBy: .Equal, toItem: self, attribute: .CenterY, multiplier: 1.0, constant: 0.0)
        ])
    }
    
    func addAndPinSubviewToMargins(subview: UIView) {
        addSubview(subview)
        pinSubviewToMargins(subview)
    }
    
}

extension UIViewController {
    public func pinRootSubview(subview: UIView) {
        let views: [String: AnyObject] = ["subview": subview, "topGuide": topLayoutGuide, "bottomGuide": bottomLayoutGuide]
        
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[subview]-0-|", options: .DirectionLeadingToTrailing, metrics: nil, views:views))
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[topGuide][subview][bottomGuide]|", options: .DirectionLeadingToTrailing, metrics: nil, views: views))
    }
    
    public func addAndPinRootSubview(subview: UIView) {
        view.addSubview(subview)
        pinRootSubview(subview)
    }
}

