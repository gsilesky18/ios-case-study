//
//  HarmonyScreen.swift
//  HarmonyKit
//
//  Created by Erik Kerber on 11/10/15.
//  Copyright © 2015 Target. All rights reserved.
//

import UIKit

public struct HarmonyScreen {
    public static let onePixel = 1 / UIScreen.mainScreen().scale
}

@objc
public class HarmonyScreenObjC: NSObject {
    public static let onePixel = 1 / UIScreen.mainScreen().scale
}