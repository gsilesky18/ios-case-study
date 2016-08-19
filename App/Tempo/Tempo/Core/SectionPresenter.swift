//
//  SectionPresenter.swift
//  HarmonyKit
//
//  Created by Adam May on 11/9/15.
//  Copyright © 2015 Target. All rights reserved.
//

import Foundation

public enum CollectionViewSectionUpdate: Equatable {
    case Insert(Int)
    case Delete(Int)
    case Reload(Int)
    case Update(Int, Int, [CollectionViewItemUpdate])
    case Focus(TempoFocus)
}

public func == (lhs: CollectionViewSectionUpdate, rhs: CollectionViewSectionUpdate) -> Bool {
    switch (lhs, rhs) {
    case (.Insert(let leftIndex), .Insert(let rightIndex)):
        return leftIndex == rightIndex
    case (.Delete(let leftIndex), .Delete(let rightIndex)):
        return leftIndex == rightIndex
    case (.Reload(let leftIndex), .Reload(let rightIndex)):
        return leftIndex == rightIndex
    case (.Update(let leftFromIndex, let leftToIndex, let leftItemUpdates), .Update(let rightFromIndex, let rightToIndex, let rightItemUpdates)):
        return leftFromIndex == rightFromIndex && leftToIndex == rightToIndex && leftItemUpdates == rightItemUpdates
    case (.Focus(let leftFocus), .Focus(let rightFocus)):
        return leftFocus == rightFocus
    default:
        return false
    }
}

public enum CollectionViewItemUpdate: Equatable {
    case Insert(Int)
    case Delete(Int)
    case Update(Int, Int)
}

public func == (lhs: CollectionViewItemUpdate, rhs: CollectionViewItemUpdate) -> Bool {
    switch (lhs, rhs) {
    case (.Insert(let leftIndex), .Insert(let rightIndex)):
        return leftIndex == rightIndex
    case (.Delete(let leftIndex), .Delete(let rightIndex)):
        return leftIndex == rightIndex
    case (.Update(let leftFromIndex, let leftToIndex), .Update(let rightFromIndex, let rightToIndex)):
        return leftFromIndex == rightFromIndex && leftToIndex == rightToIndex
    default:
        return false
    }
}

public protocol SectionPresenterAdapter: class {
    func applyUpdates(updates: [CollectionViewSectionUpdate], viewState: TempoSectionedViewState)
}

public final class SectionPresenter: NSObject, TempoPresenter {
    public var dispatcher: Dispatcher?
    private var viewState: MemoizedTempoSectionedViewState?
    private let adapter: SectionPresenterAdapter

    public init(adapter: SectionPresenterAdapter) {
        self.adapter = adapter
    }

    public func present(viewState: TempoSectionedViewState) {
        let memoizedViewState = MemoizedTempoSectionedViewState(viewState: viewState)
        let updates: [CollectionViewSectionUpdate]

        if let fromViewState = self.viewState {
            updates = SectionPresenter.updatesFrom(fromViewState, toViewState: memoizedViewState)
        } else {
            updates = []
        }

        self.viewState = memoizedViewState

        adapter.applyUpdates(updates, viewState: memoizedViewState)
    }

    private static func updatesFrom(fromViewState: TempoSectionedViewState, toViewState: TempoSectionedViewState) -> [CollectionViewSectionUpdate] {
        var updates = [CollectionViewSectionUpdate]()

        let previousSections = fromViewState.sections
        let updatedSections = toViewState.sections

        for (index, updated) in updatedSections.enumerate() {
            if !previousSections.contains({ $0.identifier == updated.identifier }) {
                updates.append(.Insert(index))
            }
        }

        for (index, previous) in previousSections.enumerate() {
            if !updatedSections.contains({ $0.identifier == previous.identifier }) {
                updates.append(.Delete(index))
            }
        }

        for (fromIndex, previous) in previousSections.enumerate() {
            if let (toIndex, updated) = updatedSections.enumerate().detect({ $0.element.identifier == previous.identifier && !$0.element.isEqualTo(previous) }) {
                if let previousItems = previous.items, updatedItems = updated.items {
                    let itemUpdates = updatesFrom(previousItems, toItems: updatedItems)
                    updates.append(.Update(fromIndex, toIndex, itemUpdates))
                } else if previous.numberOfItems == updated.numberOfItems {
                    updates.append(.Update(fromIndex, toIndex, []))
                } else {
                    updates.append(.Reload(fromIndex))
                }
            }
        }

        if let focus = toViewState.focus {
            updates.append(.Focus(focus))
        }

        return updates
    }

    private static func updatesFrom(fromItems: [TempoViewStateItem], toItems: [TempoViewStateItem]) -> [CollectionViewItemUpdate] {
        var updates: [CollectionViewItemUpdate] = []

        for (index, updated) in toItems.enumerate() {
            if !fromItems.contains({ $0.identifier == updated.identifier }) {
                updates.append(.Insert(index))
            }
        }

        for (index, previous) in fromItems.enumerate() {
            if !toItems.contains({ $0.identifier == previous.identifier }) {
                updates.append(.Delete(index))
            }
        }

        for (fromIndex, previous) in fromItems.enumerate() {
            if let (toIndex, _) = toItems.enumerate().detect({ $0.element.identifier == previous.identifier && !$0.element.isEqualTo(previous) }) {
                updates.append(.Update(fromIndex, toIndex))
            }
        }
        
        return updates
    }
}
