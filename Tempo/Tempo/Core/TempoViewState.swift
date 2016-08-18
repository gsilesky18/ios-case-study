//
//  TempoViewState.swift
//  HarmonyKit
//
//  Created by Ryan.Sander on 11/4/15.
//  Copyright © 2015 Target. All rights reserved.
//

import Foundation

public protocol TempoViewState {

}

public protocol TempoSectionedViewState {
    var sections: [TempoViewStateItem] { get }
    var focus: TempoFocus? { get }
}

public extension TempoSectionedViewState {
    var focus: TempoFocus? {
        return nil
    }
}

// MARK: - MemoizedTempoSectionedViewState

/**
 *  Copies view state for internal use to avoid expense when sections are calculated.
 */
struct MemoizedTempoSectionedViewState: TempoViewState, TempoSectionedViewState {
    let sections: [TempoViewStateItem]
    let focus: TempoFocus?

    init(viewState: TempoSectionedViewState) {
        self.sections = viewState.sections
        self.focus = viewState.focus
    }
}
