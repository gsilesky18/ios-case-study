//
//  String+Height.swift
//  ProductViewer
//
//  Created by Greg Silesky on 1/12/20.
//  Copyright © 2020 Target. All rights reserved.
//

import UIKit

extension String {
    /// Calculates the height of a given string based on the font and width
    ///
    /// - parameter font: The font of the text.
    /// - parameter width: The width of where the string will be displayed.
    func calculateHeight(font: UIFont, width:CGFloat) -> CGFloat {
        let attributes : [NSAttributedString.Key : Any] = [NSAttributedString.Key.font : font]
        let attributedString : NSAttributedString = NSAttributedString(string: self, attributes: attributes)
        let rect : CGRect = attributedString.boundingRect(with: CGSize(width: width, height: CGFloat.greatestFiniteMagnitude), options: .usesLineFragmentOrigin, context: nil)
        let requredSize:CGRect = rect
        return requredSize.height

    }
}
