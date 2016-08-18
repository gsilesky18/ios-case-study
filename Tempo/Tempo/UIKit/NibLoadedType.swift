//
//  NibView.swift
//  HarmonyKit
//
//  Created by Erik.Kerber on 12/3/15.
//  Copyright © 2015 Target. All rights reserved.
//

import Foundation

public protocol NibLoadedType {
    static var nibName: String { get }
}

extension NibLoadedType where Self: AnyObject {
    
    public static func loadFromNib() -> Self {
        guard let view = NSBundle(forClass: self).loadNibNamed(Self.nibName, owner: nil, options: nil).first as? Self else {
            // Choosing fatalError over throws for cleaner consumer API.
            fatalError("Misconfigured NibLoadedType \(Self.nibName)")
        }
        
        return view
    }
}
