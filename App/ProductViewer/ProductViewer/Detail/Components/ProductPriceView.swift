//
//  ProductPriceView.swift
//  ProductViewer
//
//  Created by Greg Silesky on 1/8/20.
//  Copyright © 2020 Target. All rights reserved.
//

import UIKit
import Tempo

class ProductPriceView : UIView {
    @IBOutlet weak var priceLabel: UILabel!
}

extension ProductPriceView: ReusableNib {
    @nonobjc static let nibName = "ProductPriceView"
    @nonobjc static let reuseID = "ProductPriceViewIdentifier"

    @nonobjc func prepareForReuse() {
        
    }
}
