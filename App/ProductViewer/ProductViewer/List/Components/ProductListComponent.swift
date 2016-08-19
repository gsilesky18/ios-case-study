//
//  ProductListComponent.swift
//  ProductViewer
//
//  Created by Erik.Kerber on 8/18/16.
//  Copyright © 2016 Target. All rights reserved.
//

import Tempo

struct ProductListComponent: Component {
    var dispatcher: Dispatcher?

    func prepareView(view: ProductListView, item: ListItemViewState) {
        // Called on first view or ProductListView
    }
    
    func configureView(view: ProductListView, item: ListItemViewState) {
        view.titleLabel.text = item.title
        view.priceLabel.text = item.price
        view.productImage.image = item.image
    }
    
    func selectView(view: ProductListView, item: ListItemViewState) {
        dispatcher?.triggerEvent(ListItemPressed())
    }
}

extension ProductListComponent: HarmonyLayoutComponent {
    func heightForLayout(layout: HarmonyLayout, item: TempoViewStateItem, width: CGFloat) -> CGFloat {
        return 100.0
    }
}