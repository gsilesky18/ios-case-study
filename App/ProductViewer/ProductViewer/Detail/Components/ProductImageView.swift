//
//  ProductImageView.swift
//  ProductViewer
//
//  Created by Greg Silesky on 1/8/20.
//  Copyright © 2020 Target. All rights reserved.
//

import UIKit
import Tempo

class ProductImageView: UIView {
    @IBOutlet weak var productImage: UIImageView!
}

extension ProductImageView: ReusableNib {
    @nonobjc static let nibName = "ProductImageView"
    @nonobjc static let reuseID = "ProductImageViewIdentifier"

    @nonobjc func prepareForReuse() {
        
    }
}
