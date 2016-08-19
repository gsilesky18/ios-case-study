//
//  HarmonyCellBase.swift
//  Harmony
//
//  Created by Samuel Kirchmeier on 4/9/15.
//  Copyright (c) 2015 Target. All rights reserved.
//

import UIKit

/**
 *  Harmony styled cell for use in HarmonyLayout collection views. The cell supports multiple styles
 *  as defined in the designs.
 */
public class HarmonyCellBase: UICollectionViewCell {
    // MARK: - Private Class Properties
    
    
    private static var backgroundImageSolo: UIImage? = {
        let image = UIImage(namedFromBundle: "HarmonyCellBackgroundSolo")
        let capInsets = UIEdgeInsets(top: 5.0, left: 5.0, bottom: 5.0, right: 5.0)
        return image?.resizableImageWithCapInsets(capInsets)
    }()
    
    private static var backgroundImageTop: UIImage? = {
        let image = UIImage(namedFromBundle: "HarmonyCellBackgroundTop")
        let capInsets = UIEdgeInsets(top: 5.0, left: 5.0, bottom: 1.0, right: 5.0)
        return image?.resizableImageWithCapInsets(capInsets)
    }()
    
    private static var backgroundImageMiddle: UIImage? = {
        let image = UIImage(namedFromBundle: "HarmonyCellBackgroundMiddle")
        let capInsets = UIEdgeInsets(top: 0.0, left: 1.0, bottom: 1.0, right: 1.0)
        return image?.resizableImageWithCapInsets(capInsets)
    }()
    
    private static var backgroundImageBottom: UIImage? = {
        let image = UIImage(namedFromBundle: "HarmonyCellBackgroundBottom")
        let capInsets = UIEdgeInsets(top: 0.0, left: 5.0, bottom: 5.0, right: 5.0)
        return image?.resizableImageWithCapInsets(capInsets)
    }()
    
    private static var backgroundImageHorizontalRule: UIImage? = {
        let image = UIImage(namedFromBundle: "HarmonyCellBackgroundHorizontalRule")
        let capInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 1.0, right: 0.0)
        return image?.resizableImageWithCapInsets(capInsets)
    }()

    private static var backgroundImagePlainTop: UIImage? = {
        let image = UIImage(namedFromBundle: "HarmonyCellBackgroundPlainTop")
        let capInsets = UIEdgeInsets(top: 3.0, left: 0.0, bottom: 0.0, right: 0.0)
        return image?.resizableImageWithCapInsets(capInsets)
    }()

    private static var backgroundImagePlainMiddle: UIImage? = {
        let image = UIImage(namedFromBundle: "HarmonyCellBackgroundPlainMiddle")
        let capInsets = UIEdgeInsets(top: 2.0, left: 1.0, bottom: 0.0, right: 1.0)
        return image?.resizableImageWithCapInsets(capInsets)
    }()

    private static var backgroundImagePlainBottom: UIImage? = {
        let image = UIImage(namedFromBundle: "HarmonyCellBackgroundPlainBottom")
        let capInsets = UIEdgeInsets(top: 1.0, left: 1.0, bottom: 2.0, right: 0.0)
        return image?.resizableImageWithCapInsets(capInsets)
    }()

    private static var backgroundImagePlainSolo: UIImage? = {
        let image = UIImage(namedFromBundle: "HarmonyCellBackgroundPlainSolo")
        let capInsets = UIEdgeInsets(top: 2.0, left: 0.0, bottom: 1.0, right: 0.0)
        return image?.resizableImageWithCapInsets(capInsets)
    }()

    private static var highlightedBackgroundImageSolo: UIImage? = {
        let image = UIImage(namedFromBundle: "HarmonyCellHighlightedBackgroundSolo")
        let capInsets = UIEdgeInsets(top: 5.0, left: 5.0, bottom: 5.0, right: 5.0)
        return image?.resizableImageWithCapInsets(capInsets)
    }()
    
    private static var highlightedBackgroundImageTop: UIImage? = {
        let image = UIImage(namedFromBundle: "HarmonyCellHighlightedBackgroundTop")
        let capInsets = UIEdgeInsets(top: 5.0, left: 5.0, bottom: 1.0, right: 5.0)
        return image?.resizableImageWithCapInsets(capInsets)
    }()
    
    private static var highlightedBackgroundImageMiddle: UIImage? = {
        let image = UIImage(namedFromBundle: "HarmonyCellHighlightedBackgroundMiddle")
        let capInsets = UIEdgeInsets(top: 0.0, left: 1.0, bottom: 1.0, right: 1.0)
        return image?.resizableImageWithCapInsets(capInsets)
    }()
    
    private static var highlightedBackgroundImageBottom: UIImage? = {
        let image = UIImage(namedFromBundle: "HarmonyCellHighlightedBackgroundBottom")
        let capInsets = UIEdgeInsets(top: 0.0, left: 5.0, bottom: 5.0, right: 5.0)
        return image?.resizableImageWithCapInsets(capInsets)
    }()
    
    private static var highlightedBackgroundImageHorizontalRule: UIImage? = {
        let image = UIImage(namedFromBundle: "HarmonyCellHighlightedBackgroundHorizontalRule")
        let capInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 1.0, right: 0.0)
        return image?.resizableImageWithCapInsets(capInsets)
    }()

    private static var highlightedBackgroundImagePlainTop: UIImage? = {
        let image = UIImage(namedFromBundle: "HarmonyCellHighlightedBackgroundPlainTop")
        let capInsets = UIEdgeInsets(top: 3.0, left: 0.0, bottom: 0.0, right: 0.0)
        return image?.resizableImageWithCapInsets(capInsets)
    }()

    private static var highlightedBackgroundImagePlainMiddle: UIImage? = {
        let image = UIImage(namedFromBundle: "HarmonyCellHighlightedBackgroundPlainMiddle")
        let capInsets = UIEdgeInsets(top: 3.0, left: 1.0, bottom: 0.0, right: 0.0)
        return image?.resizableImageWithCapInsets(capInsets)
    }()

    private static var highlightedBackgroundImagePlainBottom: UIImage? = {
        let image = UIImage(namedFromBundle: "HarmonyCellHighlightedBackgroundPlainBottom")
        let capInsets = UIEdgeInsets(top: 1.0, left: 1.0, bottom: 2.0, right: 0.0)
        return image?.resizableImageWithCapInsets(capInsets)
    }()

    private static var highlightedBackgroundImagePlainSolo: UIImage? = {
        let image = UIImage(namedFromBundle: "HarmonyCellHighlightedBackgroundPlainSolo")
        let capInsets = UIEdgeInsets(top: 2.0, left: 1.0, bottom: 1.0, right: 0.0)
        return image?.resizableImageWithCapInsets(capInsets)
    }()

    // MARK: - Private Properties
    
    private var backgroundImageView: UIImageView?
    private var highlightedBackgroundImageView: UIImageView?
    private var singlePixelLine: SinglePixelLine?
    private let highlightedForegroundImageView: UIImageView = UIImageView()
    private var highlightStyle: HarmonyHighlightStyle = .background
    
    // MARK: - Internal Functions
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup(frame: frame)
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        setup(frame: frame)
    }
    
    // MARK: - Private Functions
    
    private func setup(frame frame: CGRect) {
        contentView.layoutMargins = UIEdgeInsetsZero

        backgroundView = UIView(frame: frame)
        backgroundView?.backgroundColor = .clearColor()

        backgroundImageView = UIImageView(image: HarmonyCellBase.backgroundImageSolo)
        backgroundImageView?.backgroundColor = .clearColor()
        backgroundView?.addSubview(backgroundImageView!)
        
        highlightedBackgroundImageView = UIImageView(image: HarmonyCellBase.highlightedBackgroundImageSolo)
        highlightedBackgroundImageView?.backgroundColor = .clearColor()
        highlightedBackgroundImageView?.hidden = true
        backgroundView?.addSubview(highlightedBackgroundImageView!)

        singlePixelLine = SinglePixelLine(frame: frame)
        singlePixelLine?.edges = .None
        backgroundView?.addSubview(singlePixelLine!)

        highlightedForegroundImageView.backgroundColor = UIColor.targetJetBlackColor.colorWithAlphaComponent(0.03)
        highlightedForegroundImageView.hidden = true
        contentView.addSubview(highlightedForegroundImageView)
    }
}

// MARK: - UICollectionViewCell

public extension HarmonyCellBase {
    public override func preferredLayoutAttributesFittingAttributes(layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        // This override prevents self-sizing operations from taking place, which slow down complex layouts.
        return layoutAttributes
    }

    override func applyLayoutAttributes(layoutAttributes: UICollectionViewLayoutAttributes) {
        super.applyLayoutAttributes(layoutAttributes)

        if let attributes = layoutAttributes as? HarmonyCellAttributes {
            contentView.layoutMargins = attributes.margins
            highlightStyle = attributes.highlightStyle

            switch attributes.style {
            case .None:
                backgroundColor = .clearColor()
                backgroundImageView?.hidden = true
                highlightedBackgroundImageView?.image = nil
                singlePixelLine?.edges = .None
            case .Grouped:
                backgroundColor = .clearColor()
                backgroundImageView?.hidden = false
                
                switch attributes.position {
                case .Solo:
                    backgroundImageView?.image = HarmonyCellBase.backgroundImageSolo
                    highlightedBackgroundImageView?.image = HarmonyCellBase.highlightedBackgroundImageSolo

                    singlePixelLine?.edges = .None
                case .Top:
                    backgroundImageView?.image = HarmonyCellBase.backgroundImageTop
                    highlightedBackgroundImageView?.image = HarmonyCellBase.highlightedBackgroundImageTop
                    
                    singlePixelLine?.edges = .Bottom
                    singlePixelLine?.insets = attributes.separatorInsets
                    
                case .Middle:
                    backgroundImageView?.image = HarmonyCellBase.backgroundImageMiddle
                    highlightedBackgroundImageView?.image = HarmonyCellBase.highlightedBackgroundImageMiddle
                    
                    singlePixelLine?.edges = .Bottom
                    singlePixelLine?.insets = attributes.separatorInsets
                    
                case .Bottom:
                    backgroundImageView?.image = HarmonyCellBase.backgroundImageBottom
                    highlightedBackgroundImageView?.image = HarmonyCellBase.highlightedBackgroundImageBottom

                    singlePixelLine?.edges = .None
                }
                
            case .Detached:
                backgroundColor = .clearColor()
                backgroundImageView?.hidden = false
                backgroundImageView?.image = HarmonyCellBase.backgroundImageSolo
                highlightedBackgroundImageView?.image = HarmonyCellBase.highlightedBackgroundImageSolo
                singlePixelLine?.edges = .None
            case .HorizontalRule:
                backgroundColor = .clearColor()
                backgroundImageView?.hidden = false
                backgroundImageView?.image = HarmonyCellBase.backgroundImageHorizontalRule
                highlightedBackgroundImageView?.image = HarmonyCellBase.highlightedBackgroundImageHorizontalRule
                singlePixelLine?.edges = .None
            case .Plain:
                backgroundColor = .whiteColor()
                backgroundImageView?.hidden = false
                singlePixelLine?.insets = attributes.separatorInsets

                switch attributes.position {
                case .Solo:
                    backgroundImageView?.image = HarmonyCellBase.backgroundImagePlainSolo
                    highlightedBackgroundImageView?.image = HarmonyCellBase.highlightedBackgroundImagePlainSolo
                    singlePixelLine?.edges = .None
                case .Top:
                    backgroundImageView?.image = HarmonyCellBase.backgroundImagePlainTop
                    highlightedBackgroundImageView?.image = HarmonyCellBase.highlightedBackgroundImagePlainTop
                    singlePixelLine?.edges = .Bottom
                case .Middle:
                    backgroundImageView?.image = HarmonyCellBase.backgroundImagePlainMiddle
                    highlightedBackgroundImageView?.image = HarmonyCellBase.highlightedBackgroundImagePlainMiddle
                    singlePixelLine?.edges = .Bottom
                case .Bottom:
                    backgroundImageView?.image = HarmonyCellBase.backgroundImagePlainBottom
                    highlightedBackgroundImageView?.image = HarmonyCellBase.highlightedBackgroundImagePlainBottom
                    singlePixelLine?.edges = .None
                }

            }
        } else {
            layoutMargins = UIEdgeInsetsZero
            backgroundColor = .clearColor()
            backgroundImageView?.hidden = true
            highlightedBackgroundImageView?.image = nil
        }

        // Allows cells to animate changes in frame
        layoutIfNeeded()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        backgroundImageView?.frame = contentView.frame
        highlightedBackgroundImageView?.frame = contentView.frame
        singlePixelLine?.frame = contentView.frame
        highlightedForegroundImageView.frame = contentView.bounds
    }
    
    override var highlighted: Bool {
        didSet {
            switch highlightStyle {
            case .foreground:
                contentView.bringSubviewToFront(highlightedForegroundImageView)
                highlightedForegroundImageView.hidden = !highlighted
            case .background:
                highlightedBackgroundImageView?.hidden = !highlighted
            }
        }
    }
}

// MARK: - Enums

/**
 The cell styles supported by HarmonyLayout.
 */
@objc
public enum HarmonyCellStyle: Int {
    /// No border, transparent background.
    case None
    /// Rounded corners, white background, looks like a grouped table view.
    case Grouped
    /// In a grouped table view, detached from neighboring cells by a narrow margin.
    case Detached
    /// 1-point bottom border, no rounded corners, white background.
    case HorizontalRule
    /// Plain rectangular white cells, with 1-point separators.
    case Plain
}

/**
 The highlight styles supported by HarmonyLayout.
 */
@objc
public enum HarmonyHighlightStyle: Int {
    /// Hides or shows the highlighted background view based on the cell's highlight state.
    case background
    /// Hides or shows the highlighted foreground view based on the cell's highlight state.
    case foreground
}

@objc
public enum HarmonyTileSize: Int {
    case carouselSmall
    case carouselTall
    case mini
    case small
    case wide
    case tall
    case big
    case giant

    public var dimensions: (columns: Int, rows: Int) {
        switch self {
        case carouselSmall: return (columns: 5, rows: 5)
        case carouselTall:  return (columns: 5, rows: 8)
        case mini:  return (columns: 4,  rows: 5)
        case small: return (columns: 6,  rows: 5)
        case wide:  return (columns: 12, rows: 5)
        case tall:  return (columns: 6,  rows: 10)
        case big:   return (columns: 12, rows: 10)
        case giant: return (columns: 12, rows: 15)
        }
    }
}

@objc
public enum HarmonySectionStyle: Int {
    /// A vertical list of Harmony-styled cells.
    case list
    /// A vertical grid of Harmony-sized tiles.
    case grid
}

/**
 Where this cell appears in a group. This property is set by the layout regardless of the cell's
 style. When the style is .Grouped, this determines which corners are rounded.
 
 - Solo:   Lone cell in a section.
 - Top:    Top cell in a section.
 - Middle: Somewhere not at the top or bottom.
 - Bottom: It's at the bottom.
 */
public enum HarmonyCellPosition {
    case Solo
    case Top
    case Middle
    case Bottom
}
