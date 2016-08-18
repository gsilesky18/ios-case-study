//
//  UICollectionView+HarmonyLayout.swift
//  HarmonyKit
//
//  Created by Erik.Kerber on 1/20/16.
//  Copyright © 2016 Target. All rights reserved.
//

import Foundation

/// Reference type for holding onto the views to be removed
class HarmonyLayoutHideViewHandle {
    
    private let appliedMaskViews: Set<UIView>
    
    private init(views: Set<UIView>) {
        self.appliedMaskViews = views
    }
    
    func unmask() {
        for v in appliedMaskViews {
            v.removeFromSuperview()
        }
    }
}

extension UICollectionView {
    
    /// Masks all "groups" in a section.
    func maskSection(section: Int) -> HarmonyLayoutHideViewHandle {
        var appliedMaskViews: Set<UIView> = []
        
        guard   let harmonyLayout = collectionViewLayout as? HarmonyLayout,
                let groupFrames = harmonyLayout.groupFramesForSection(section) else {
            assertionFailure("hide only available on collections views with HarmonyLayout")
            return HarmonyLayoutHideViewHandle(views: Set<UIView>())
        }
        
        for groupFrame in groupFrames {
            let maskView = UIView(frame: groupFrame)
            let activity = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
            activity.center = CGPoint(x: CGRectGetMidX(maskView.bounds), y: CGRectGetMidY(maskView.bounds))
            activity.startAnimating()
            maskView.addSubview(activity)
            addSubview(maskView)
            maskView.layer.cornerRadius = 5
            maskView.layer.backgroundColor = UIColor.clearColor().CGColor
            UIView.animateWithDuration(0.2) {
                maskView.layer.backgroundColor = UIColor.targetStarkWhiteColor.colorWithAlphaComponent(0.4).CGColor
            }
            
            // Store for later so it can be removed
            appliedMaskViews.insert(maskView)
        }
        
        return HarmonyLayoutHideViewHandle(views: appliedMaskViews)
    }
}
