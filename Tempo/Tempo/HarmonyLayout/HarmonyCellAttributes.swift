//
//  HarmonyCellAttributes.swift
//  Harmony
//
//  Created by Samuel Kirchmeier on 4/9/15.
//  Copyright (c) 2015 Target. All rights reserved.
//

import UIKit

/**
 *  Custom attributes for Harmony-styled collection view items.
 */
final class HarmonyCellAttributes: UICollectionViewLayoutAttributes {
    // MARK: - Internal Properties
    
    /// Indicates how the cell at this index path should be displayed.
    var style = HarmonyCellStyle.Grouped

    /// Indicates how the call will show a highlighted state.
    var highlightStyle = HarmonyHighlightStyle.background
    
    /// Indicates where this cell appears in a group of cells.
    var position = HarmonyCellPosition.Solo
    
    /// Indicates the edge insets of the cell separator.
    var separatorInsets = UIEdgeInsetsZero

    /// Indicates the space between the cell and its content.
    var margins = UIEdgeInsetsZero
}

// MARK: - UICollectionViewLayoutAttributes

extension HarmonyCellAttributes {
    override func isEqual(object: AnyObject?) -> Bool {
        if let object = object as? HarmonyCellAttributes {
            return self.style == object.style &&
                self.highlightStyle == object.highlightStyle &&
                self.position == object.position &&
                self.separatorInsets == object.separatorInsets &&
                self.margins == object.margins &&
                super.isEqual(object)
        } else {
            return false
        }
    }
}

// MARK: - NSCopying

extension HarmonyCellAttributes {
    override func copyWithZone(zone: NSZone) -> AnyObject {
        let cell = super.copyWithZone(zone) as! HarmonyCellAttributes
        cell.style = self.style
        cell.highlightStyle = self.highlightStyle
        cell.position = self.position
        cell.separatorInsets = self.separatorInsets
        cell.margins = self.margins
        
        return cell
    }
}
