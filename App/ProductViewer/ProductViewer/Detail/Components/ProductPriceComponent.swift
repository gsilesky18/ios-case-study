//
//  ProductPriceComponent.swift
//  ProductViewer
//
//  Created by Greg Silesky on 1/8/20.
//  Copyright © 2020 Target. All rights reserved.
//

import Tempo

class ProductPriceComponent: Component {
    var dispatcher: Dispatcher?
    
    func configureView(_ view: ProductPriceView, item: ProductPriceViewState) {
        view.priceLabel.text = item.price
    }
}

extension ProductPriceComponent: HarmonyLayoutComponent {
    func heightForLayout(_ layout: HarmonyLayout, item: TempoViewStateItem, width: CGFloat) -> CGFloat {
        return 70
    }
}
