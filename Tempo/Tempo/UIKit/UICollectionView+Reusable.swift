//
//  UICollectionView+HarmonyKit.swift
//  HarmonyKit
//
//  Created by Erik.Kerber on 11/17/15.
//  Copyright © 2015 Target. All rights reserved.
//

import Foundation

public enum DifferenceType {
    case Insert
    case Delete
}

public protocol SectionIndexDifferenceType {
    var differenceType: DifferenceType { get }
    var sectionsForDifference: NSIndexSet { get }
    var sectionsForReload: NSIndexSet { get }
}

public protocol SectionAndRowIndexDifferenceType {
    var freshLoad: Bool { get }
    
    var deletedSections: NSIndexSet { get }
    var addedSections: NSIndexSet { get }
    var reloadSections: NSIndexSet { get }
    
    var deletedRows: [NSIndexPath] { get }
    var addedRows: [NSIndexPath] { get }
    var reloadRows: [NSIndexPath] { get }
}

public protocol SelectionDifferenceType {
    var itemsToSelect: [NSIndexPath] { get }
    var itemsToDeselect: [NSIndexPath] { get }
}

extension UICollectionView {
    func update(difference: SectionIndexDifferenceType, completion: ((Bool) -> Void)? = nil) {
        performBatchUpdates({
            switch difference.differenceType {
            case .Insert:
                self.insertSections(difference.sectionsForDifference)
            case .Delete:
                self.deleteSections(difference.sectionsForDifference)
            }
            UIView.performWithoutAnimation {
                self.performBatchUpdates({
                    self.reloadSections(difference.sectionsForReload)
                    }) {success in }
            }
        }) {success in

            completion?(success)
        }
        
    }
    
    func update(difference: SectionAndRowIndexDifferenceType, completion: ((Bool) -> Void)? = nil) {
        
        #if DEBUG
        print("SECTION ADD: \(difference.addedSections)")
        print("SECTION DELETE: \(difference.deletedSections)")
        print("SECTION RELOAD: \(difference.reloadSections)")
        
        print("ROW ADD: \(difference.addedRows)")
        print("ROW DELETE: \(difference.deletedRows)")
        print("ROW RELOAD: \(difference.reloadRows)")
        #endif
        
        performBatchUpdates({

            // Sections
            self.insertSections(difference.addedSections)
            self.deleteSections(difference.deletedSections)
            self.reloadSections(difference.reloadSections)

            // Rows
            self.insertItemsAtIndexPaths(difference.addedRows)
            self.deleteItemsAtIndexPaths(difference.deletedRows)

        }) { success in

            // Just reload individual items after the batch.
            // The animations are... really bad otherwise ¯\_(ツ)_/¯.
            self.reloadItemsAtIndexPaths(difference.reloadRows)

            // Did they add a section or a row? Scroll to it.
            if difference.freshLoad {
                // Do nothing if this is the first load -lest we always scroll of the top on first run!
            } else if difference.addedSections.count > 0 {
                self.scrollToItemAtIndexPath(NSIndexPath(forItem: 0, inSection: difference.addedSections.firstIndex), atScrollPosition: .Top, animated: true)
            } else if let firstItem = difference.addedRows.first {
                self.scrollToItemAtIndexPath(firstItem, atScrollPosition: .Top, animated: true)
            }
            completion?(success)
        }
        
    }
    
    func update(selectionData: SelectionDifferenceType) {
        #if DEBUG
        print("SELECTION ADD: \(selectionData.itemsToSelect)")
        print("SELECTION REMOVE: \(selectionData.itemsToDeselect)")
        #endif

        UIView.performWithoutAnimation {
            selectionData.itemsToSelect.forEach {
                self.selectItemAtIndexPath($0, animated: false, scrollPosition: .None)
            }
            
            selectionData.itemsToDeselect.forEach {
                self.deselectItemAtIndexPath($0, animated: false)
            }
        }
    }
}

/// Strongly typed collection view cell dequeueing
public extension UICollectionView {
    
    /// Register a class based cell
    public func registerReusable(cellClass: Reusable.Type) {
        registerClass(cellClass, forCellWithReuseIdentifier: cellClass.reuseIdentifier)
    }
    
    /// Register a nib based cell
    public func registerReusable(cellClass: ReusableNib.Type) {
        registerNib(UINib(nibName: cellClass.nibName, bundle: NSBundle(forClass: cellClass)), forCellWithReuseIdentifier: cellClass.reuseIdentifier)
    }

    /// Register wrapped nib based cell
    public func registerWrappedReusable<T: UIView where T: Reusable>(viewType: T.Type) {
        registerWrappedReusable(viewType, reuseIdentifier: viewType.reuseIdentifier)
    }

    /// Register wrapped nib based cell with a custom reuse identifier
    public func registerWrappedReusable<T: UIView where T: Reusable>(viewType: T.Type, reuseIdentifier: String) {
        registerClass(CollectionViewWrapperCell<T>.self, forCellWithReuseIdentifier: reuseIdentifier)
    }

    // Safely dequeue a `Reusable` item
    public func dequeueReusable<T where T: Reusable, T: UICollectionViewCell>(cellType: T.Type, indexPath: NSIndexPath) -> T {
        return dequeueReusable(cellType, reuseIdentifier: cellType.reuseIdentifier, indexPath: indexPath)
    }

    // Safely dequeue a `Reusable` item with a custom reuse identifier
    public func dequeueReusable<T: UICollectionViewCell where T: Reusable>(cellType: T.Type, reuseIdentifier: String, indexPath: NSIndexPath) -> T {
        guard let cell = dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as? T else {
            fatalError("Misconfigured cell type, \(cellType)!")
        }

        return cell
    }
}

/// Dequeuing mechanism for CollectionViewWrapperCell
public extension UICollectionView {

    public func dequeueWrappedReusable<T: UIView where T: Reusable, T: Creatable>(viewType: T.Type, indexPath: NSIndexPath) -> CollectionViewWrapperCell<T> {
        return dequeueWrappedReusable(viewType, reuseIdentifier: viewType.reuseIdentifier, indexPath: indexPath)
    }

    public func dequeueWrappedReusable<T: UIView where T: Reusable, T: Creatable>(viewType: T.Type, reuseIdentifier: String, indexPath: NSIndexPath) -> CollectionViewWrapperCell<T> {
        let cell = dequeueReusable(CollectionViewWrapperCell<T>.self, reuseIdentifier: reuseIdentifier, indexPath: indexPath)
        
        if cell.reusableView == nil {
            cell.reusableView = T.create()
        }
        
        return cell
    }
}

/// UICollectionViewCell designed to wrap an arbitrary view inside of it.
public class CollectionViewWrapperCell<T: UIView where T: Reusable>: HarmonyCellBase, Reusable {
    
    // Static stored properties "not yet supported in Swift" 💁🏼
    public static var reuseIdentifier: String {
        return T.reuseIdentifier
    }
    
    // The private setter makes the IUO easier to swallow.
    public private(set) var reusableView: T! {
        willSet {
            reusableView?.removeFromSuperview()
        }
        didSet {
            reusableView.translatesAutoresizingMaskIntoConstraints = false
            contentView.addAndPinSubviewToMargins(reusableView)
        }
    }
        
    override public func prepareForReuse() {
        super.prepareForReuse()
        reusableView.prepareForReuse()
        setNeedsLayout()
    }
}
