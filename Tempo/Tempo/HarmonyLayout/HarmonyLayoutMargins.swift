//
//  HarmonyLayout.swift
//  Harmony
//
//  Created by Samuel Kirchmeier on 4/10/15.
//  Copyright (c) 2015 Target. All rights reserved.
//

public enum HarmonyLayoutMarginStyle {
    // Legacy margins
    case None
    case Narrow
    case Wide

    // New margins
    case Quarter
    case Half
    case Full

    public var points: CGFloat {
        switch self {
        case .None:
            return 0.0

        case .Quarter, .Narrow:
            return 4.0

        case .Half:
            return 8.0

        case .Full, .Wide:
            return 16.0
        }
    }
}

@objc
public class HarmonyLayoutMargins: NSObject {
    public var top: HarmonyLayoutMarginStyle
    public var right: HarmonyLayoutMarginStyle
    public var bottom: HarmonyLayoutMarginStyle
    public var left: HarmonyLayoutMarginStyle
    
    public init(top: HarmonyLayoutMarginStyle,
                right: HarmonyLayoutMarginStyle,
                bottom: HarmonyLayoutMarginStyle,
                left: HarmonyLayoutMarginStyle) {
        self.top = top
        self.right = right
        self.bottom = bottom
        self.left = left
    }
    
    public static let HarmonyLayoutMarginsZero = HarmonyLayoutMargins(top: .None, right: .None, bottom: .None, left: .None)
}
