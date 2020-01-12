//
//  ProductDescriptionView.swift
//  ProductViewer
//
//  Created by Greg Silesky on 1/12/20.
//  Copyright © 2020 Target. All rights reserved.
//

import UIKit
import Tempo

class ProductDescriptionView: UIView{
    
    @IBOutlet weak var descriptionLabel: UILabel!
}

extension ProductDescriptionView: ReusableNib {
    @nonobjc static let nibName = "ProductDescriptionView"
    @nonobjc static let reuseID = "ProductDescriptionViewIdentifier"

    @nonobjc func prepareForReuse() {
        
    }
}
