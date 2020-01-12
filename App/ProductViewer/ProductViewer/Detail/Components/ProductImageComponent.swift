//
//  ProductImageComponent.swift
//  ProductViewer
//
//  Created by Greg Silesky on 1/8/20.
//  Copyright © 2020 Target. All rights reserved.
//

import Tempo

struct ProductImageComponent: Component {
    var dispatcher: Dispatcher?
    
    func configureView(_ view: ProductImageView, item: ProductImageViewState) {
        view.productImage.kf.indicatorType = .activity
        view.productImage.kf.setImage(with: item.imageUrl)
    }
}

extension ProductImageComponent: HarmonyLayoutComponent {
    func heightForLayout(_ layout: HarmonyLayout, item: TempoViewStateItem, width: CGFloat) -> CGFloat {
        return width
    }
}
