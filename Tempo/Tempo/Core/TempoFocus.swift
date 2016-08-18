//
//  TempoFocus.swift
//  HarmonyKit
//
//  Created by Samuel Kirchmeier on 3/23/16.
//  Copyright © 2016 Target. All rights reserved.
//

import Foundation

/**
 *  Indicates how focus should be applied to a Tempo view state.
 */
public struct TempoFocus: Equatable {
    public enum Position {
        case CenteredHorizontally
        case CenteredVertically
    }

    public let indexPath: NSIndexPath
    public let position: Position
    public let animated: Bool

    public init(indexPath: NSIndexPath, position: Position, animated: Bool) {
        self.indexPath = indexPath
        self.position = position
        self.animated = animated
    }
}

public func ==(lhs: TempoFocus, rhs: TempoFocus) -> Bool {
    return lhs.indexPath == rhs.indexPath
        && lhs.position == rhs.position
        && lhs.animated == rhs.animated
}
