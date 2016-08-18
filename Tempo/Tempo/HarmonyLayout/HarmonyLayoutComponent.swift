//
//  HarmonyLayoutComponent.swift
//  HarmonyKit
//
//  Created by Adam May on 11/16/15.
//  Copyright © 2015 Target. All rights reserved.
//

import UIKit

public protocol HarmonyLayoutComponent {
    func heightForLayout(layout: HarmonyLayout, item: TempoViewStateItem, width: CGFloat) -> CGFloat
    func itemMarginsForLayout(layout: HarmonyLayout, item: TempoViewStateItem) -> HarmonyLayoutMargins
    func sectionMarginsForLayout(layout: HarmonyLayout) -> HarmonyLayoutMargins
    func styleForLayout(layout: HarmonyLayout, item: TempoViewStateItem) -> HarmonyCellStyle
    func separatorInsetsForLayout(layout: HarmonyLayout, item: TempoViewStateItem) -> UIEdgeInsets
    func sectionStyleForLayout(layout: HarmonyLayout) -> HarmonySectionStyle
    func tileSizeForLayout(layout: HarmonyLayout, item: TempoViewStateItem) -> HarmonyTileSize
    func tileInsetsForLayout(layout: HarmonyLayout, item: TempoViewStateItem) -> UIEdgeInsets
    func tileSpacingForLayout(layout: HarmonyLayout, item: TempoViewStateItem) -> CGFloat
    func tileMarginsForLayout(layout: HarmonyLayout, item: TempoViewStateItem) -> UIEdgeInsets
}

public extension HarmonyLayoutComponent {
    func heightForLayout(layout: HarmonyLayout, item: TempoViewStateItem, width: CGFloat) -> CGFloat {
        return layout.defaultItemHeight
    }

    func itemMarginsForLayout(layout: HarmonyLayout, item: TempoViewStateItem) -> HarmonyLayoutMargins {
        return layout.defaultItemMargins
    }

    func sectionMarginsForLayout(layout: HarmonyLayout) -> HarmonyLayoutMargins {
        return layout.defaultSectionMargins
    }

    func styleForLayout(layout: HarmonyLayout, item: TempoViewStateItem) -> HarmonyCellStyle {
        return .Grouped
    }
    
    func separatorInsetsForLayout(layout: HarmonyLayout, item: TempoViewStateItem) -> UIEdgeInsets {
        return UIEdgeInsetsZero
    }

    func tileSizeForLayout(layout: HarmonyLayout, item: TempoViewStateItem) -> HarmonyTileSize {
        return layout.defaultTileSize
    }

    func tileInsetsForLayout(layout: HarmonyLayout, item: TempoViewStateItem) -> UIEdgeInsets {
        return layout.defaultTileInsets
    }

    func tileSpacingForLayout(layout: HarmonyLayout, item: TempoViewStateItem) -> CGFloat {
        return layout.defaultTileSpacing
    }

    func tileMarginsForLayout(layout: HarmonyLayout, item: TempoViewStateItem) -> UIEdgeInsets {
        return layout.defaultTileMargins
    }

    func sectionStyleForLayout(layout: HarmonyLayout) -> HarmonySectionStyle {
        return layout.defaultSectionStyle
    }

    func fittingHeightForView(componentView: UIView, width: CGFloat) -> CGFloat {
        componentView.translatesAutoresizingMaskIntoConstraints = false

        let widthConstraint = NSLayoutConstraint(item: componentView, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: width)
        componentView.addConstraint(widthConstraint)

        componentView.setNeedsLayout()
        componentView.layoutIfNeeded()

        let fittingSize = componentView.systemLayoutSizeFittingSize(UILayoutFittingCompressedSize)
        componentView.removeConstraint(widthConstraint)

        return fittingSize.height
    }
}
