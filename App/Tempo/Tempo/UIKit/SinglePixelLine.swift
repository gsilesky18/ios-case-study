//
//  SinglePixelLine.swift
//  HarmonyKit
//
//  Created by Logan.B.Johnson on 11/10/15.
//  Copyright © 2015 Target. All rights reserved.
//

import UIKit

public class SinglePixelLine: UIView {
    
    public var color: UIColor = UIColor.grayColor() {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    public var edges: UIRectEdge = .Bottom {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    public var insets: UIEdgeInsets = UIEdgeInsetsZero {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    public override func drawRect(rect: CGRect) {
        let lineWidth = HarmonyScreen.onePixel
        let lineInset = lineWidth / 2.0 // half the width of the line should be inside
        let insetRect = UIEdgeInsetsInsetRect(rect, insets)
        
        let context = UIGraphicsGetCurrentContext()
        CGContextSaveGState(context)
        CGContextSetLineWidth(context, lineWidth)
        CGContextSetStrokeColorWithColor(context, color.CGColor)
        
        if edges.contains(.Bottom)  {
            let bottomY = CGRectGetMaxY(insetRect) - lineInset
            CGContextMoveToPoint(context, insets.left, bottomY)
            CGContextAddLineToPoint(context, CGRectGetMaxX(insetRect), bottomY)
            CGContextStrokePath(context)
        }
        
        if edges.contains(.Left) {
            let leftX = insets.left + lineInset
            CGContextMoveToPoint(context, leftX, insets.top)
            CGContextAddLineToPoint(context, leftX, CGRectGetMaxY(insetRect))
            CGContextStrokePath(context)
        }
        
        if edges.contains(.Right) {
            let rightX = CGRectGetMaxX(insetRect) - lineInset
            CGContextMoveToPoint(context, rightX, insets.top)
            CGContextAddLineToPoint(context, rightX, CGRectGetMaxY(insetRect))
            CGContextStrokePath(context)
        }
        
        if edges.contains(.Top) {
            let topY = insets.top + lineInset
            CGContextMoveToPoint(context, insets.left, topY)
            CGContextAddLineToPoint(context, CGRectGetMaxX(insetRect), topY)
            CGContextStrokePath(context)
        }
        
        CGContextRestoreGState(context)
    }
    
    // MARK: - Private Methods
    
    private func setup() {
        backgroundColor = UIColor.clearColor()
        contentMode = .Redraw
    }
    
}
