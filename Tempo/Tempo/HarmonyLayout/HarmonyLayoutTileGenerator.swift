//
//  HarmonyLayoutTileGenerator.swift
//  HarmonyKit
//
//  Created by Adam May on 5/12/16.
//  Copyright © 2016 Target. All rights reserved.
//

import Foundation

struct HarmonyTileGenerator: HarmonySectionGenerator {
    let layout: HarmonyLayout

    var grid = Grid(columns: 12)
    var indexPaths: [NSIndexPath]

    init(layout: HarmonyLayout, indexPaths: [NSIndexPath]) {
        self.layout = layout
        self.indexPaths = indexPaths
    }

    mutating func next(indexPath: NSIndexPath) -> HarmonyCellAttributes {
        let spacing = layout.tileSpacing(forIndexPath: indexPath)
        let insets = layout.tileInsets(forIndexPath: indexPath)
        let width = layout.width(forSection: indexPath.section)

        let projection = GridProjection(width: width, columns: grid.columns, spacing: spacing, insets: insets)

        let size = layout.tileSize(forIndexPath: indexPath)
        let tile = gridTile(forTileSize: size)
        let rect = grid.place(tile)
        let frame = projection.project(rect)

        let attributes = HarmonyCellAttributes(forCellWithIndexPath: indexPath)

        attributes.frame = frame
        attributes.style = .None
        attributes.margins = layout.tileMargins(forIndexPath: indexPath)

        return attributes
    }

    func gridTile(forTileSize size: HarmonyTileSize) -> Grid.Tile {
        return Grid.Tile(width: size.dimensions.columns, height: size.dimensions.rows)
    }
}
