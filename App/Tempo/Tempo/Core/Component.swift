//
//  Component.swift
//  HarmonyKit
//
//  Created by Ryan.Sander on 11/4/15.
//  Copyright © 2015 Target. All rights reserved.
//

import Foundation

public protocol ComponentType {
    var dispatcher: Dispatcher? { get set }

    func canDisplayItem(item: TempoViewStateItem) -> Bool
    func willDisplayItem(item: TempoViewStateItem)

    func prepareView(view: UIView, viewState: TempoViewStateItem)
    func configureView(view: UIView, viewState: TempoViewStateItem)
    func selectView(view: UIView, viewState: TempoViewStateItem)
    func shouldSelectView(view: UIView, viewState: TempoViewStateItem) -> Bool
    func shouldHighlightView(view: UIView, viewState: TempoViewStateItem) -> Bool
    func didFocus(frame: CGRect?, coordinateSpace: UICoordinateSpace?, viewState: TempoViewStateItem)
    func focusAccessibility(view: UIView, viewState: TempoViewStateItem)

    func registerWrappers(container: ReusableViewContainer)

    func dequeueWrapper<Container: ReusableViewItemContainer>(container: Container, viewState: TempoViewStateItem) -> ComponentWrapper<Container.Cell>
    func visibleWrapper<Container: ReusableViewItemContainer>(container: Container, viewState: TempoViewStateItem) -> ComponentWrapper<Container.Cell>?
}

public extension ComponentType {
    func willDisplayItem(item: TempoViewStateItem) { }
    func prepareView(view: UIView, viewState: TempoViewStateItem) { }
    func selectView(view: UIView, viewState: TempoViewStateItem) { }
    func shouldSelectView(view: UIView, viewState: TempoViewStateItem) -> Bool { return true }
    func shouldHighlightView(view: UIView, viewState: TempoViewStateItem) -> Bool { return shouldSelectView(view, viewState: viewState) }
    func didFocus(frame: CGRect?, coordinateSpace: UICoordinateSpace?, viewState: TempoViewStateItem) { }
    func focusAccessibility(view: UIView, viewState: TempoViewStateItem) { view.focusAccessibility(afterDelay: 0.1) }
}

public protocol Component: ComponentType {
    associatedtype Item: TempoViewStateItem
    associatedtype View: UIView

    func willDisplayItem(item: Item)
    func prepareView(view: View, item: Item)
    func configureView(view: View, item: Item)
    func selectView(view: View, item: Item)
    func shouldSelectView(view: View, item: Item) -> Bool
    func shouldHighlightView(view: View, item: Item) -> Bool
    func didFocus(frame: CGRect?, coordinateSpace: UICoordinateSpace?, item: Item)
    func focusAccessibility(view: View, item: Item)
}

public extension Component {
    func willDisplayItem(item: Item) { }
    func prepareView(view: View, item: Item) { }
    func selectView(view: View, item: Item) { }
    func shouldSelectView(view: View, item: Item) -> Bool { return true }
    func shouldHighlightView(view: View, item: Item) -> Bool { return shouldSelectView(view, item: item) }
    func didFocus(frame: CGRect?, coordinateSpace: UICoordinateSpace?, item: Item) { }
    func focusAccessibility(view: View, item: Item) { view.focusAccessibility(afterDelay: 0.1) }
}

public extension ComponentType where Self: Component {
    func withSpecificView<T>(view: UIView, viewState: TempoViewStateItem, @noescape perform: (View, Item) -> T) -> T {
        return perform(view as! Self.View, viewState as! Self.Item)
    }

    func canDisplayItem(item: TempoViewStateItem) -> Bool {
        return item is Item
    }

    func willDisplayItem(item: TempoViewStateItem) {
        willDisplayItem(item as! Item)
    }

    func prepareView(view: UIView, viewState: TempoViewStateItem) {
        withSpecificView(view, viewState: viewState) { view, item in
            prepareView(view, item: item)
        }
    }

    func configureView(view: UIView, viewState: TempoViewStateItem) {
        withSpecificView(view, viewState: viewState) { view, item in
            configureView(view, item: item)
        }
    }

    func selectView(view: UIView, viewState: TempoViewStateItem) {
        withSpecificView(view, viewState: viewState) { view, item in
            selectView(view, item: item)
        }
    }

    func shouldSelectView(view: UIView, viewState: TempoViewStateItem) -> Bool {
        return withSpecificView(view, viewState: viewState) { view, item in
            return shouldSelectView(view, item: item)
        }
    }
    
    func shouldHighlightView(view: UIView, viewState: TempoViewStateItem) -> Bool {
        return withSpecificView(view, viewState: viewState) { view, item in
            return shouldHighlightView(view, item: item)
        }
    }

    func didFocus(frame: CGRect?, coordinateSpace: UICoordinateSpace?, viewState: TempoViewStateItem) {
        didFocus(frame, coordinateSpace: coordinateSpace, item: viewState as! Self.Item)
    }

    func focusAccessibility(view: UIView, viewState: TempoViewStateItem) {
        withSpecificView(view, viewState: viewState) { view, item in
            focusAccessibility(view, item: item)
        }
    }
    

}

public extension Component where View: Reusable, View: Creatable {
    func registerWrappers(container: ReusableViewContainer) {
        container.registerReusableView(View.self)
    }
    
    func dequeueWrapper<Container: ReusableViewItemContainer>(container: Container, item: Item) -> ComponentWrapper<Container.Cell> {
        return container.dequeueReusableWrapper(View.self)
    }
    
    func visibleWrapper<Container: ReusableViewItemContainer>(container: Container, item: Item) -> ComponentWrapper<Container.Cell>? {
        return container.visibleWrapper(View.self)
    }
    
    func dequeueWrapper<Container: ReusableViewItemContainer>(container: Container, viewState: TempoViewStateItem) -> ComponentWrapper<Container.Cell> {
        return dequeueWrapper(container, item: viewState as! Self.Item)
    }
    
    func visibleWrapper<Container: ReusableViewItemContainer>(container: Container, viewState: TempoViewStateItem) -> ComponentWrapper<Container.Cell>? {
        return visibleWrapper(container, item: viewState as! Self.Item)
    }
}
