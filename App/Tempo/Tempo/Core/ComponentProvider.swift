//
//  ComponentProvider.swift
//  HarmonyKit
//
//  Created by Adam May on 11/13/15.
//  Copyright © 2015 Target. All rights reserved.
//

import Foundation

public class ComponentProvider {
    let components: [ComponentType]
    let dispatcher: Dispatcher

    public init(components: [ComponentType], dispatcher: Dispatcher) {
        self.components = components
        self.dispatcher = dispatcher
    }

    public func registerComponents(container: ReusableViewContainer) {
        for component in components {
            component.registerWrappers(container)
        }
    }

    public func componentFor(item: TempoViewStateItem) -> ComponentType {
        for var component in components {
            if component.canDisplayItem(item) {
                component.dispatcher = dispatcher
                return component
            }
        }

        fatalError("Missing component for \(item)")
    }
}
