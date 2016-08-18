//
//  TempoPresenter.swift
//  HarmonyKit
//
//  Created by Adam May on 11/6/15.
//  Copyright © 2015 Target. All rights reserved.
//

import Foundation

public protocol TempoPresenterType: class {
    func present(viewState: TempoViewState)
}

public protocol TempoPresenter: TempoPresenterType {
    associatedtype ViewState
    func present(viewState: ViewState)
}

extension TempoPresenter {
    public func present(viewState: TempoViewState) {
        if let viewState = viewState as? Self.ViewState {
            present(viewState)
        }
    }
}
