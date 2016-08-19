//
//  HarmonyLayout.swift
//  Harmony
//
//  Created by Samuel Kirchmeier on 4/10/15.
//  Copyright (c) 2015 Target. All rights reserved.
//

import UIKit

/**
 *  Harmony-styled collection view layout. Designed to handle all of the cell styles defined for the
 *  Target app.
 */
public class HarmonyLayout: UICollectionViewLayout {

    static let backdropViewKind = "backdrop"

    // MARK: - Internal Properties

    /// Indicates whether or not to collapse the first section's top margin. Default is true.
    public var collapseFirstSectionTopMargin = true
    
    /// Indicates whether or not to collapse the last section's bottom margin. Default is true.
    public var collapseLastSectionBottomMargin = true
    
    /// Margins that surround the entire collection view.
    public var collectionViewMargins = HarmonyLayoutMargins(top: .Narrow, right: .None, bottom: .Narrow, left: .None)
    
    /// Default section margins.
    public var defaultSectionMargins = HarmonyLayoutMargins(top: .None, right: .None, bottom: .Wide, left: .None)
    
    /// Default item margins.
    public var defaultItemMargins = HarmonyLayoutMargins(top: .None, right: .Narrow, bottom: .None, left: .Narrow)
    
    /// Default item height.
    public var defaultItemHeight = CGFloat(44.0)

    /// Default sections style. Used when the delegate does not specify section style.
    public var defaultSectionStyle: HarmonySectionStyle = .list

    /// Default tile size. Used when the delegate does not specify tile size.
    public var defaultTileSize: HarmonyTileSize = .wide

    /// Default tile insets. Used when the delegate does not specify tile insets.
    public var defaultTileInsets: UIEdgeInsets = UIEdgeInsets(top: 0, left: 2, bottom: 0, right: 2)

    // Default tile margins. Used when the delegate does not specify tile margins.
    public var defaultTileMargins: UIEdgeInsets = UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2)

    // Default tile spacing. Used when the delegate does not specify tile spacing.
    public var defaultTileSpacing: CGFloat = 0

    // A Boolean value indicating whether a backdrop appears behind the collection view's content.
    public var displaysBackdrop = false
    
    // MARK: - Private Properties
    
    private var cachedContentSize = CGSizeZero
    private var currentAttributes: [NSIndexPath: HarmonyCellAttributes] = [:]

    // The backdrop appears behind all the views displayed for the collection view's items.
    private var backdropAttributes: UICollectionViewLayoutAttributes?

    // MARK: - Lifecycle methods

    public override init() {
        super.init()
        setup()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    func setup() {
        registerClass(HarmonyBackdropView.self, forDecorationViewOfKind: HarmonyLayout.backdropViewKind)
    }
}

class HarmonyBackdropView: UICollectionReusableView {
    override func applyLayoutAttributes(layoutAttributes: UICollectionViewLayoutAttributes) {
        super.applyLayoutAttributes(layoutAttributes)
        
        backgroundColor = .targetFadeAwayGrayColor
    }
}

// MARK: - UICollectionViewLayout

public extension HarmonyLayout {

    var contentSizeWidth: CGFloat {
        return collectionView?.bounds.size.width ?? 0.0
    }

    var harmonyLayoutDelegate: HarmonyLayoutDelegate? {
        return collectionView?.delegate as? HarmonyLayoutDelegate
    }

    func tileSize(forIndexPath indexPath: NSIndexPath) -> HarmonyTileSize {
        return harmonyLayoutDelegate?.harmonyLayout?(self, tileSizeForItemAtIndexPath: indexPath) ?? defaultTileSize
    }

    func tileInsets(forIndexPath indexPath: NSIndexPath) -> UIEdgeInsets {
        return harmonyLayoutDelegate?.harmonyLayout?(self, tileInsetsForItemAtIndexPath: indexPath) ?? defaultTileInsets
    }

    func tileSpacing(forIndexPath indexPath: NSIndexPath) -> CGFloat {
        return harmonyLayoutDelegate?.harmonyLayout?(self, tileSpacingForItemAtIndexPath: indexPath) ?? defaultTileSpacing
    }

    func tileMargins(forIndexPath indexPath: NSIndexPath) -> UIEdgeInsets {
        return harmonyLayoutDelegate?.harmonyLayout?(self, tileMarginsForItemAtIndexPath: indexPath) ?? defaultTileMargins
    }

    func style(forSection section: Int) -> HarmonySectionStyle {
        return harmonyLayoutDelegate?.harmonyLayout?(self, styleForSection: section) ?? defaultSectionStyle
    }

    func hasBreak(atIndexPath indexPath: NSIndexPath) -> Bool {
        return harmonyLayoutDelegate?.harmonyLayout?(self, breakAtIndexPath: indexPath) ?? false
    }

    func margins(forSection section: Int) -> HarmonyLayoutMargins {
        return harmonyLayoutDelegate?.harmonyLayout?(self, marginsForSection: section) ?? defaultSectionMargins
    }

    func margins(forItemAtIndexPath indexPath: NSIndexPath) -> HarmonyLayoutMargins {
        return harmonyLayoutDelegate?.harmonyLayout?(self, marginsForItemAtIndexPath: indexPath) ?? defaultItemMargins
    }

    func style(forItemAtIndexPath indexPath: NSIndexPath) -> HarmonyCellStyle {
        return harmonyLayoutDelegate?.harmonyLayout?(self, styleForItemAtIndexPath: indexPath) ?? .Grouped
    }

    func separatorInsets(forItemAtIndexPath indexPath: NSIndexPath) -> UIEdgeInsets {
        return harmonyLayoutDelegate?.harmonyLayout?(self, separatorInsetsForItemAtIndexPath: indexPath) ?? UIEdgeInsetsZero
    }

    func height(forItemAtIndexPath indexPath: NSIndexPath, width: CGFloat) -> CGFloat {
        return harmonyLayoutDelegate?.harmonyLayout?(self, heightForItemAtIndexPath: indexPath, forWidth:width) ?? defaultItemHeight
    }

    func width(forSection section: Int) -> CGFloat {
        let sectionMargins = margins(forSection: section)

        return contentSizeWidth - sectionMargins.left.points - sectionMargins.right.points
    }

    func width(forItemAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let itemMargins = margins(forItemAtIndexPath: indexPath)

        return width(forSection: indexPath.section) - itemMargins.left.points - itemMargins.right.points
    }
    
    func groupFramesForSection(section: Int) -> [CGRect]? {
        return currentAttributes.filter { $0.0.section == section } // Grab the attributes for the specified section
            .sort({left, right in left.0.item < right.0.item })
            .reduce([CGRect]()) { (groupFrames, currentFrame) in // Combine touching items into grouped frames.
                var mutableGroupFrames = groupFrames
                
                if let lastTest = mutableGroupFrames.last where CGRectGetMaxY(lastTest) == CGRectGetMinY(currentFrame.1.frame),
                       let last = mutableGroupFrames.popLast() {
                    mutableGroupFrames.append(CGRectUnion(last, currentFrame.1.frame))
                } else {
                    mutableGroupFrames.append(currentFrame.1.frame)
                }
                return mutableGroupFrames
            }
    }

    override func prepareLayout() {
        super.prepareLayout()

        currentAttributes.removeAll(keepCapacity: true)

        let contentSizeWidth = collectionView?.bounds.size.width ?? 0.0
        let contentSizeHeight = collectionView?.bounds.size.height ?? 0.0
        var y = collectionViewMargins.top.points

        if let collectionView = collectionView {
            let sectionCount = collectionView.dataSource?.numberOfSectionsInCollectionView?(collectionView) ?? 1
            
            for sectionIndex in 0..<sectionCount {
                if let itemCount = collectionView.dataSource?.collectionView(collectionView, numberOfItemsInSection: sectionIndex) where itemCount > 0 {
                    let sectionMargins = margins(forSection: sectionIndex)

                    let isFirstSection = sectionIndex == 0
                    if !isFirstSection || !collapseFirstSectionTopMargin {
                        let topMargin = sectionMargins.top.points
                        y += topMargin
                    }

                    var maxY: CGFloat = 0

                    let indexPaths = (0..<itemCount).map { NSIndexPath(forItem: $0, inSection: sectionIndex) }
                    let section = HarmonyLayoutSection(indexPaths: indexPaths, layout: self, style: style(forSection: sectionIndex)).offsetBy(y)

                    for attributes in section {
                        // Moves all item attributes in front of any decoration or supplementary 
                        // views, such as the backdrop.
                        attributes.zIndex = 100

                        currentAttributes[attributes.indexPath] = attributes
                        maxY = attributes.frame.maxY
                    }

                    y = maxY

                    let isLastSection = sectionIndex == sectionCount - 1
                    // Only execute this if at least one item was in the section. Otherwise, it shouldn't
                    // "count" against the next margin.
                    if itemCount > 0 && (!isLastSection || !collapseLastSectionBottomMargin) {
                        let bottomMargin = sectionMargins.bottom.points
                        y += bottomMargin
                    }
                }
            }
        }
        
        y += collectionViewMargins.bottom.points
        cachedContentSize = CGSize(width: contentSizeWidth, height: y)

        if displaysBackdrop && currentAttributes.count > 0 {
            backdropAttributes = UICollectionViewLayoutAttributes(forDecorationViewOfKind: HarmonyLayout.backdropViewKind, withIndexPath: NSIndexPath(forItem: 0, inSection: 0))
            backdropAttributes?.frame = CGRect(x: 0, y: 0, width: cachedContentSize.width, height: cachedContentSize.height + contentSizeHeight)
        }
    }
    
    override func collectionViewContentSize() -> CGSize {
        return cachedContentSize
    }

    override func layoutAttributesForElementsInRect(rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var intersection = [UICollectionViewLayoutAttributes]()
        
        for attributes in currentAttributes.values {
            if CGRectIntersectsRect(rect, attributes.frame) {
                intersection.append(attributes)
            }
        }

        if let backdropAttributes = backdropAttributes where backdropAttributes.frame.intersects(rect) {
            intersection.append(backdropAttributes)
        }
        
        return intersection
    }
    
    override func layoutAttributesForItemAtIndexPath(indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
        return currentAttributes[indexPath]
    }

    public override func layoutAttributesForDecorationViewOfKind(elementKind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
        return backdropAttributes
    }

    public override func finalLayoutAttributesForDisappearingDecorationElementOfKind(elementKind: String, atIndexPath decorationIndexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
        return backdropAttributes
    }

    override func shouldInvalidateLayoutForBoundsChange(newBounds: CGRect) -> Bool {
        let oldBounds = collectionView?.bounds ?? CGRectZero
        let sizeChanged = !CGSizeEqualToSize(oldBounds.size, newBounds.size)
        
        return sizeChanged
    }
}
