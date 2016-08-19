//
//  CollectionViewAdapter.swift
//  HarmonyKit
//
//  Created by Adam May on 11/13/15.
//  Copyright © 2015 Target. All rights reserved.
//

import UIKit

public final class CollectionViewAdapter: NSObject {
    weak var scrollViewDelegate: UIScrollViewDelegate?

    let collectionView: UICollectionView
    private let componentProvider: ComponentProvider
    private var viewState: TempoSectionedViewState = InitialViewState()
    private var focusingIndexPath: NSIndexPath?

    private struct InitialViewState: TempoSectionedViewState {
        var sections: [TempoViewStateItem] {
            return []
        }
    }

    // MARK: - Init

    public init(collectionView: UICollectionView, componentProvider: ComponentProvider) {
        self.collectionView = collectionView
        self.componentProvider = componentProvider

        super.init()

        componentProvider.registerComponents(collectionView)

        collectionView.dataSource = self
        collectionView.delegate = self
    }

    // MARK: - Public Methods

    public func itemFor(indexPath: NSIndexPath) -> TempoViewStateItem {
        return itemFor(indexPath, inViewState: viewState)
    }

    public func sectionFor(section: Int) -> TempoViewStateItem {
        return viewState.sections[section]
    }

    public func componentFor(indexPath: NSIndexPath) -> ComponentType {
        let item = itemFor(indexPath)
        return componentProvider.componentFor(item)
    }

    // MARK: - Private Methods

    private func insertSection(section: Int) {
        collectionView.insertSections(NSIndexSet(index: section))
    }

    private func deleteSection(section: Int) {
        collectionView.deleteSections(NSIndexSet(index: section))
    }

    private func updateSection(fromSection: Int, fromViewState: TempoSectionedViewState, toSection: Int) {
        let section = fromViewState.sections[fromSection]

        for item in 0..<section.numberOfItems {
            let fromIndexPath = NSIndexPath(forItem: item, inSection: fromSection)
            let toIndexPath = NSIndexPath(forItem: item, inSection: toSection)
            itemInfoForIndexPath(fromIndexPath, fromViewState: fromViewState, toIndexPath: toIndexPath).configureView()
        }
    }

    private func updateSection(fromSection: Int, fromViewState: TempoSectionedViewState, toSection: Int, itemUpdates: [CollectionViewItemUpdate]) {
        for update in itemUpdates {
            switch update {
            case .Delete(let item):
                collectionView.deleteItemsAtIndexPaths([NSIndexPath(forItem: item, inSection: fromSection)])

            case .Insert(let item):
                collectionView.insertItemsAtIndexPaths([NSIndexPath(forItem: item, inSection: toSection)])

            case .Update(let fromItem, let toItem):
                let fromIndexPath = NSIndexPath(forItem: fromItem, inSection: fromSection)
                let toIndexPath = NSIndexPath(forItem: toItem, inSection: toSection)
                itemInfoForIndexPath(fromIndexPath, fromViewState: fromViewState, toIndexPath: toIndexPath).configureView()
            }
        }
    }

    private func reloadSection(section: Int) {
        collectionView.reloadSections(NSIndexSet(index: section))
    }

    private func focus(focus: TempoFocus) {
        guard focus.indexPath != focusingIndexPath else { // Scroll already in progress
            return
        }

        guard let attributes = collectionView.layoutAttributesForItemAtIndexPath(focus.indexPath) else {
            return
        }

        let scrollPosition: UICollectionViewScrollPosition

        switch focus.position {
        case .CenteredHorizontally:
            scrollPosition = .CenteredHorizontally

        case .CenteredVertically:
            scrollPosition = .CenteredVertically
        }

        if CGRectContainsRect(collectionView.bounds, attributes.frame) {
            // The item is already fully visible.
            didFocus(focus.indexPath, attributes: attributes)
        } else if focus.animated {
            // Track index path during animation. Reset in `scrollViewDidEndScrollingAnimation:`.
            focusingIndexPath = focus.indexPath
            collectionView.scrollToItemAtIndexPath(focus.indexPath, atScrollPosition: scrollPosition, animated: true)
        } else {
            collectionView.scrollToItemAtIndexPath(focus.indexPath, atScrollPosition: scrollPosition, animated: false)
            didFocus(focus.indexPath, attributes: attributes)
        }
    }

    private func itemInfoForIndexPath(indexPath: NSIndexPath) -> CollectionViewItemInfo {
        let toViewState = itemFor(indexPath, inViewState: viewState)
        let component = componentProvider.componentFor(toViewState)
        let container = ReusableCollectionViewItemContainer(fromIndexPath: indexPath, toIndexPath: indexPath, collectionView: collectionView)

        return CollectionViewItemInfo(fromViewState: toViewState, toViewState: toViewState, component: component, container: container)
    }

    private func itemInfoForIndexPath(fromIndexPath: NSIndexPath, fromViewState: TempoSectionedViewState, toIndexPath: NSIndexPath) -> CollectionViewItemInfo {
        let fromViewState = itemFor(fromIndexPath, inViewState: fromViewState)
        let toViewState = itemFor(toIndexPath, inViewState: viewState)
        let component = componentProvider.componentFor(toViewState)
        let container = ReusableCollectionViewItemContainer(fromIndexPath: fromIndexPath, toIndexPath: toIndexPath, collectionView: collectionView)

        return CollectionViewItemInfo(fromViewState: fromViewState, toViewState: toViewState, component: component, container: container)
    }

    private func itemFor(indexPath: NSIndexPath, inViewState viewState: TempoSectionedViewState) -> TempoViewStateItem {
        let section = viewState.sections[indexPath.section]

        if let items = section.items {
            return items[indexPath.item]
        } else {
            return section
        }
    }
    
    private func didFocus(indexPath: NSIndexPath, attributes: UICollectionViewLayoutAttributes) {
        let itemInfo = itemInfoForIndexPath(indexPath)
        itemInfo.focusAccessibility()
        itemInfo.didFocus(attributes.frame, coordinateSpace: collectionView)
    }
}

extension CollectionViewAdapter: SectionPresenterAdapter {
    public func applyUpdates(updates: [CollectionViewSectionUpdate], viewState: TempoSectionedViewState) {
        let fromViewState = self.viewState
        self.viewState = viewState

        guard !updates.isEmpty || collectionView.window == nil else {
            return
        }

        collectionView.performBatchUpdates({
            for update in updates {
                switch update {
                case .Delete(let index):
                    self.deleteSection(index)
                case .Insert(let index):
                    self.insertSection(index)
                case .Reload(let index):
                    self.reloadSection(index)
                case .Update(let fromIndex, let toIndex, let itemUpdates):
                    if itemUpdates.count > 0 {
                        self.updateSection(fromIndex, fromViewState: fromViewState, toSection: toIndex, itemUpdates: itemUpdates)
                    } else {
                        self.updateSection(fromIndex, fromViewState: fromViewState, toSection: toIndex)
                    }
                case .Focus(let focus):
                    self.focus(focus)
                }
            }
        }, completion: nil)
    }
}

public struct ComponentWrapper<Cell> {
    var cell: Cell
    var view: UIView
}

public protocol ReusableViewContainer {
    func registerReusableView<T: UIView where T: Reusable>(viewType: T.Type)
    func registerReusableView<T: UIView where T: Reusable>(viewType: T.Type, reuseIdentifier: String)
}

public protocol ReusableViewItemContainer {
    associatedtype Cell

    func dequeueReusableWrapper<T: UIView where T: Reusable, T: Creatable>(viewType: T.Type) -> ComponentWrapper<Cell>
    func dequeueReusableWrapper<T: UIView where T: Reusable, T: Creatable>(viewType: T.Type, reuseIdentifier: String) -> ComponentWrapper<Cell>
    func visibleWrapper<T: UIView where T: Reusable>(viewType: T.Type) -> ComponentWrapper<Cell>?
}

public extension ReusableViewItemContainer {
    func dequeueReusableWrapper<T: UIView where T: Reusable, T: Creatable>(viewType: T.Type) -> ComponentWrapper<Cell> {
        return dequeueReusableWrapper(viewType, reuseIdentifier: viewType.reuseIdentifier)
    }
}

struct ReusableCollectionViewItemContainer: ReusableViewItemContainer {
    typealias Cell = UICollectionViewCell

    var fromIndexPath: NSIndexPath
    var toIndexPath: NSIndexPath
    var collectionView: UICollectionView
    
    func dequeueReusableWrapper<T: UIView where T: Reusable, T: Creatable>(viewType: T.Type, reuseIdentifier: String) -> ComponentWrapper<Cell> {
        let cell = collectionView.dequeueWrappedReusable(viewType, reuseIdentifier: reuseIdentifier, indexPath: toIndexPath)
        let componentWrapper = ComponentWrapper(cell: cell as Cell, view: cell.reusableView)
        return componentWrapper
    }

    func visibleWrapper<T: UIView where T: Reusable>(viewType: T.Type) -> ComponentWrapper<Cell>? {
        guard let cell = collectionView.cellForItemAtIndexPath(fromIndexPath) as? CollectionViewWrapperCell<T> else {
            return nil
        }

        return ComponentWrapper(cell: cell, view: cell.reusableView)
    }
}

private struct CollectionViewItemInfo {
    let fromViewState: TempoViewStateItem
    let toViewState: TempoViewStateItem
    let component: ComponentType
    let container: ReusableCollectionViewItemContainer

    var view: UIView? {
        return component.visibleWrapper(container, viewState: fromViewState)?.view
    }

    var cell: UICollectionViewCell {
        let wrapper = component.dequeueWrapper(container, viewState: toViewState)
        component.willDisplayItem(toViewState)
        component.prepareView(wrapper.view, viewState: toViewState)
        component.configureView(wrapper.view, viewState: toViewState)
        return wrapper.cell
    }

    func configureView() {
        if let view = view {
            component.willDisplayItem(toViewState)
            component.configureView(view, viewState: toViewState)
        }
    }

    func focusAccessibility() {
        if let view = view {
            component.focusAccessibility(view, viewState: toViewState)
        }
    }
    
    func shouldHighlightView() -> Bool {
        if let view = view {
            return component.shouldHighlightView(view, viewState: toViewState)
        } else {
            return shouldSelectView()
        }
    }

    func shouldSelectView() -> Bool {
        if let view = view {
            return component.shouldSelectView(view, viewState: toViewState)
        } else {
            return true
        }
    }

    func selectView() {
        if let view = view where shouldSelectView() {
            component.selectView(view, viewState: toViewState)
        }
    }

    func didFocus(frame: CGRect, coordinateSpace: UICoordinateSpace) {
        component.didFocus(frame, coordinateSpace: coordinateSpace, viewState: toViewState)
    }
}

extension UICollectionView: ReusableViewContainer {
    public func registerReusableView<T: UIView where T: Reusable>(viewType: T.Type) {
        registerWrappedReusable(viewType)
    }

    public func registerReusableView<T: UIView where T: Reusable>(viewType: T.Type, reuseIdentifier: String) {
        registerWrappedReusable(viewType, reuseIdentifier: reuseIdentifier)
    }
}

extension CollectionViewAdapter: UICollectionViewDataSource {
    public func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return viewState.sections.count
    }

    public func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewState.sections[section].numberOfItems
    }

    public func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        return itemInfoForIndexPath(indexPath).cell
    }
}

extension CollectionViewAdapter: UICollectionViewDelegate {
    public func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        itemInfoForIndexPath(indexPath).selectView()
    }

    public func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return itemInfoForIndexPath(indexPath).shouldHighlightView()
    }

    public func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return itemInfoForIndexPath(indexPath).shouldSelectView()
    }
}

extension CollectionViewAdapter: UIScrollViewDelegate {
    public func scrollViewDidScroll(scrollView: UIScrollView) {
        scrollViewDelegate?.scrollViewDidScroll?(scrollView)
    }

    public func scrollViewDidZoom(scrollView: UIScrollView) {
        scrollViewDelegate?.scrollViewDidZoom?(scrollView)
    }

    public func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        scrollViewDelegate?.scrollViewWillBeginDragging?(scrollView)
    }

    public func scrollViewWillEndDragging(scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        scrollViewDelegate?.scrollViewWillEndDragging?(scrollView, withVelocity: velocity, targetContentOffset: targetContentOffset)
    }

    public func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        scrollViewDelegate?.scrollViewDidEndDragging?(scrollView, willDecelerate: decelerate)
    }

    public func scrollViewWillBeginDecelerating(scrollView: UIScrollView) {
        scrollViewDelegate?.scrollViewWillBeginDecelerating?(scrollView)
    }

    public func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        scrollViewDelegate?.scrollViewDidEndDecelerating?(scrollView)
    }

    public func scrollViewDidEndScrollingAnimation(scrollView: UIScrollView) {
        if let indexPath = focusingIndexPath {
            focusingIndexPath = nil

            if let attributes = collectionView.layoutAttributesForItemAtIndexPath(indexPath) {
                didFocus(indexPath, attributes: attributes)
            }
        }

        scrollViewDelegate?.scrollViewDidEndScrollingAnimation?(scrollView)
    }

    public func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return scrollViewDelegate?.viewForZoomingInScrollView?(scrollView)
    }

    public func scrollViewWillBeginZooming(scrollView: UIScrollView, withView view: UIView?) {
        scrollViewDelegate?.scrollViewWillBeginZooming?(scrollView, withView: view)
    }

    public func scrollViewDidEndZooming(scrollView: UIScrollView, withView view: UIView?, atScale scale: CGFloat) {
        scrollViewDelegate?.scrollViewDidEndZooming?(scrollView, withView: view, atScale: scale)
    }

    public func scrollViewShouldScrollToTop(scrollView: UIScrollView) -> Bool {
        return scrollViewDelegate?.scrollViewShouldScrollToTop?(scrollView) ?? true
    }

    public func scrollViewDidScrollToTop(scrollView: UIScrollView) {
        scrollViewDelegate?.scrollViewDidScrollToTop?(scrollView)
    }
}
