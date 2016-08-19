//
//  Grid.swift
//  HarmonyKit
//
//  Created by Adam May on 5/6/16.
//  Copyright © 2016 Target. All rights reserved.
//

import Foundation

public struct Grid {

    // MARK: Public properties

    /// The fixed number of columns in the grid.
    public let columns: Int

    /// The current number of rows in the grid.
    public private(set) var rows: Int = 0

    // MARK: Private properties

    private var spaces: [Space] = []

    // MARK: Public methods

    public init(columns: Int) {
        self.columns = columns
    }

    public mutating func place(tile: Tile) -> Rect {
        var remainingSpaces = spaces

        while !remainingSpaces.isEmpty {
            if let first = remainingSpaces.first {
                if let column = place(tile, space: first, spaces: remainingSpaces) {
                    let rect = Rect(x: column, y: first.position, width: tile.width, height: tile.height)

                    // Replace remaining spaces with this rect cut out of it
                    var newSpaces = [Space]()
                    for space in spaces {
                        newSpaces.appendContentsOf(space.bisect(rect))
                    }

                    // If the tile extends past the available spaces, make new spaces for partial rows
                    if (tile.width < columns && rows < rect.y + rect.height) {
                        for row in rows..<rect.y + rect.height {
                            let space = Space(position: row, columns: columns)
                            newSpaces.appendContentsOf(space.bisect(rect))
                        }
                    }

                    rows = max(rows, rect.y + rect.height)

                    spaces = newSpaces

                    return rect
                }
            }

            remainingSpaces.removeFirst()
        }

        // If the tile is taking space beyond the available spaces, make new spaces for partial rows
        if (tile.width < columns) {
            for row in rows..<rows + tile.height {
                spaces.append(Space(position: row, indexes: tile.width..<columns))
            }
        }
        
        let rect = Rect(x: 0, y: rows, width: tile.width, height: tile.height)
        rows += tile.height

        return rect
    }

    // MARK: Private methods

    private func place(tile: Tile, space: Space, row: Int, column: Int) -> Bool {
        let requiredSpace = Space(position: row, indexes: column..<column + tile.width)
        return space.contains(requiredSpace)
    }

    private func place(tile: Tile, spaces: [Space], row: Int, column: Int) -> Bool {
        for space in spaces {
            if place(tile, space: space, row: row, column: column) {
                return true
            }
        }

        return false
    }

    private func place(tile: Tile, spaces: [Space], rows: Range<Int>, column: Int) -> Bool {
        for row in rows {
            if !place(tile, spaces: spaces, row: row, column: column) && row < self.rows {
                return false
            }
        }

        return true
    }

    private func place(tile: Tile, space: Space, spaces: [Space]) -> Int? {
        for column in space.indexes {
            if place(tile, spaces: spaces, rows: space.position..<space.position + tile.height, column: column) {
                return column
            }
        }

        return nil
    }

    // MARK: - Nested types

    public struct Tile {
        let width: Int
        let height: Int

        public init(width: Int, height: Int) {
            self.width = width
            self.height = height
        }
    }

    public struct Rect: Equatable {
        var x: Int
        var y: Int
        var width: Int
        var height: Int
    }

    struct Space: CustomDebugStringConvertible {
        let position: Int
        let indexes: Range<Int>

        var debugDescription: String {
            return "\(position): \(indexes)"
        }

        init(position: Int, indexes: Range<Int>) {
            self.position = position
            self.indexes = indexes
        }

        init(position: Int, columns: Int) {
            self.init(position: position, indexes: 0..<columns)
        }

        var isEmpty: Bool {
            return indexes.isEmpty
        }

        func contains(space: Space) -> Bool {
            return space.position == position
                && space.indexes.startIndex >= indexes.startIndex
                && space.indexes.endIndex <= indexes.endIndex
        }

        func bisect(rect: Rect) -> [Space] {
            guard position >= rect.y && position < rect.y + rect.height else {
                return [self]
            }

            guard indexes.contains(rect.x) || indexes.contains(rect.x + rect.width) else {
                return [self]
            }

            var sections = [Space]()
            if indexes.startIndex < rect.x && rect.x < indexes.endIndex {
                sections.append(Space(position: position, indexes: indexes.startIndex..<rect.x))
            }

            if indexes.startIndex < rect.x + rect.width && rect.x + rect.width < indexes.endIndex {
                sections.append(Space(position: position, indexes: rect.x + rect.width..<indexes.endIndex))
            }
            
            return sections
        }
    }
}

public func == (lhs: Grid.Rect, rhs: Grid.Rect) -> Bool {
    return lhs.x == rhs.x
        && lhs.y == rhs.y
        && lhs.width == rhs.width
        && lhs.height == rhs.height
}