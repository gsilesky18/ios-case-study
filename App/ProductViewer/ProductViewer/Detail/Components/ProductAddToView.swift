//
//  ProductAddToView.swift
//  ProductViewer
//
//  Created by Greg Silesky on 1/12/20.
//  Copyright © 2020 Target. All rights reserved.
//

import UIKit
import Tempo

class ProductAddToView: UIView {

    @IBOutlet weak var addToCartButton: UIButton!
    @IBOutlet weak var addToListButton: UIButton!
    
}

extension ProductAddToView: ReusableNib {
    @nonobjc static let nibName = "ProductAddToView"
    @nonobjc static let reuseID = "ProductAddToViewIdentifier"

    @nonobjc func prepareForReuse() {
        
    }
}
