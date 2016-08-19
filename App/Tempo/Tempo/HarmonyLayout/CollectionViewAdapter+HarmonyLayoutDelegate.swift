//
//  CollectionViewAdapter+HarmonyLayoutDelegate.swift
//  HarmonyKit
//
//  Created by Samuel Kirchmeier on 2/24/16.
//  Copyright © 2016 Target. All rights reserved.
//

import UIKit

extension CollectionViewAdapter: HarmonyLayoutDelegate {
    public func harmonyLayout(harmonyLayout: HarmonyLayout, heightForItemAtIndexPath indexPath: NSIndexPath, forWidth: CGFloat) -> CGFloat {
        return harmonyLayoutComponentFor(indexPath)?
            .heightForLayout(harmonyLayout, item: itemFor(indexPath), width: forWidth) ?? harmonyLayout.defaultItemHeight
    }

    public func harmonyLayout(harmonyLayout: HarmonyLayout, marginsForSection section: Int) -> HarmonyLayoutMargins {
        let indexPath = NSIndexPath(forItem: 0, inSection: section)
        return harmonyLayoutComponentFor(indexPath)?
            .sectionMarginsForLayout(harmonyLayout) ?? harmonyLayout.defaultSectionMargins
    }

    public func harmonyLayout(harmonyLayout: HarmonyLayout, marginsForItemAtIndexPath indexPath: NSIndexPath) -> HarmonyLayoutMargins {
        return harmonyLayoutComponentFor(indexPath)?
            .itemMarginsForLayout(harmonyLayout, item: itemFor(indexPath)) ?? harmonyLayout.defaultItemMargins
    }

    public func harmonyLayout(harmonyLayout: HarmonyLayout, styleForItemAtIndexPath indexPath: NSIndexPath) -> HarmonyCellStyle {
        return harmonyLayoutComponentFor(indexPath)?
            .styleForLayout(harmonyLayout, item: itemFor(indexPath)) ?? .Grouped
    }
    
    public func harmonyLayout(harmonyLayout: HarmonyLayout, separatorInsetsForItemAtIndexPath indexPath: NSIndexPath) -> UIEdgeInsets {
        return harmonyLayoutComponentFor(indexPath)?
            .separatorInsetsForLayout(harmonyLayout, item: itemFor(indexPath)) ?? UIEdgeInsetsZero
    }

    public func harmonyLayout(harmonyLayout: HarmonyLayout, tileSizeForItemAtIndexPath indexPath: NSIndexPath) -> HarmonyTileSize {
        return harmonyLayoutComponentFor(indexPath)?.tileSizeForLayout(harmonyLayout, item: itemFor(indexPath)) ?? harmonyLayout.defaultTileSize
    }

    public func harmonyLayout(harmonyLayout: HarmonyLayout, tileSpacingForItemAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return harmonyLayoutComponentFor(indexPath)?.tileSpacingForLayout(harmonyLayout, item: itemFor(indexPath)) ?? harmonyLayout.defaultTileSpacing
    }

    public func harmonyLayout(harmonyLayout: HarmonyLayout, tileInsetsForItemAtIndexPath indexPath: NSIndexPath) -> UIEdgeInsets {
        return harmonyLayoutComponentFor(indexPath)?.tileInsetsForLayout(harmonyLayout, item: itemFor(indexPath)) ?? harmonyLayout.defaultTileInsets
    }

    public func harmonyLayout(harmonyLayout: HarmonyLayout, tileMarginsForItemAtIndexPath indexPath: NSIndexPath) -> UIEdgeInsets {
        return harmonyLayoutComponentFor(indexPath)?.tileMarginsForLayout(harmonyLayout, item: itemFor(indexPath)) ?? harmonyLayout.defaultTileMargins
    }

    public func harmonyLayout(harmonyLayout: HarmonyLayout, styleForSection section: Int) -> HarmonySectionStyle {
        let indexPath = NSIndexPath(forItem: 0, inSection: section)
        return harmonyLayoutComponentFor(indexPath)?.sectionStyleForLayout(harmonyLayout) ?? harmonyLayout.defaultSectionStyle
    }

    private func harmonyLayoutComponentFor(indexPath: NSIndexPath) -> HarmonyLayoutComponent? {
        return componentFor(indexPath) as? HarmonyLayoutComponent
    }
}
