//
//  HarmonyLayoutSection.swift
//  HarmonyKit
//
//  Created by Adam May on 5/12/16.
//  Copyright © 2016 Target. All rights reserved.
//

import Foundation

/**
 A type that represents a section of items in `HarmonyLayout`.

 As a sequence, a section allows the use of `for` to iterate over the layout attributes:

     for attributes in section {
         // 💁 attributes are UICollectionViewAttributes
     }

 Per `SequenceType`, sections are destructively "consumed" by iteration, since the calculation
 of a given layout attributes can be dependent on previous iterations.
 */
struct HarmonyLayoutSection: SequenceType {
    let style: HarmonySectionStyle
    let indexPaths: [NSIndexPath]
    let layout: HarmonyLayout

    init(indexPaths: [NSIndexPath], layout: HarmonyLayout, style: HarmonySectionStyle) {
        self.indexPaths = indexPaths
        self.layout = layout
        self.style = style
    }

    func generate() -> AnyGenerator<HarmonyCellAttributes> {
        switch style {
        case .grid:
            return AnyGenerator(HarmonyTileGenerator(layout: layout, indexPaths: indexPaths))
        case .list:
            return AnyGenerator(HarmonyCellGenerator(layout: layout, indexPaths: indexPaths))
        }
    }
}

extension HarmonyLayoutSection {
    /**
     Returns a new section that offsets the frame of the section's attributes vertically by the
     given amount.

     - Parameter dy: The amount offset to offset in points.
     */
    func offsetBy(dy: CGFloat) -> AnySequence<HarmonyCellAttributes> {
        return AnySequence(
            map { attributes in
                let attrs = attributes.copy() as! HarmonyCellAttributes
                attrs.frame = attributes.frame.offsetBy(dx: 0, dy: dy)
                return attrs
            }
        )
    }
}

protocol HarmonySectionGenerator: GeneratorType {
    var indexPaths: [NSIndexPath] { get set }

    mutating func next(indexPath: NSIndexPath) -> HarmonyCellAttributes
}

extension HarmonySectionGenerator {
    mutating func next() -> HarmonyCellAttributes? {
        guard let indexPath = indexPaths[indexPaths.indices].popFirst() else {
            return nil
        }

        return next(indexPath)
    }
}
