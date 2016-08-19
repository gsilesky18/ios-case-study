//
//  UIImage+HarmonyKit.swift
//  HarmonyKit
//
//  Created by Erik.Kerber on 11/17/15.
//  Copyright © 2015 Target. All rights reserved.
//

import UIKit

extension UIImage {
    convenience init?(namedFromBundle: String) {
        self.init(named: namedFromBundle, inBundle: NSBundle(forClass: HarmonyCellBase.self), compatibleWithTraitCollection: nil)
    }
    
    public convenience init?(namedFromHarmonyKitBundle: String) {
        self.init(namedFromBundle: namedFromHarmonyKitBundle)
    }
    
    @objc
    public class func imageNamedFromHarmonyKitBundle(named: String) -> UIImage? {
        return UIImage(namedFromHarmonyKitBundle: named)
    }
    
    public class func fromColor(color: UIColor) -> UIImage {
        let rect = CGRectMake(0.0, 0.0, 1.0, 1.0)
        UIGraphicsBeginImageContext(rect.size)
        
        let context = UIGraphicsGetCurrentContext()
        CGContextSetFillColorWithColor(context, color.CGColor)
        CGContextFillRect(context, rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return image
    }
    
    @nonobjc
    public static let clearImage = UIImage(named: "ClearPlaceholder")
}
