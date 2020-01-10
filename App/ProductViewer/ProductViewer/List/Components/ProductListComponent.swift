//
//  ProductListComponent.swift
//  ProductViewer
//
//  Copyright © 2016 Target. All rights reserved.
//

import Tempo

struct ProductListComponent: Component {
    var dispatcher: Dispatcher?

    func prepareView(_ view: ProductListView, item: ListItemViewState) {
        // Called on first view or ProductListView
        view.aisleView.layer.cornerRadius = 20.0
        view.aisleView.layer.borderColor = HarmonyColor.targetStrokeGrayColor.cgColor
        view.aisleView.layer.borderWidth = 1.0
        view.spacerView.color = HarmonyColor.targetStrokeGrayColor
        view.layer.cornerRadius = 8.0
        view.layer.borderColor = HarmonyColor.targetStrokeGrayColor.cgColor
        view.layer.borderWidth = 0.75
        view.productImage.layer.cornerRadius = 8.0
        view.productImage.clipsToBounds = true
        //view.aisleLabel.textColor = .targetBullseyeRedColor
    }
    
    func configureView(_ view: ProductListView, item: ListItemViewState) {
        view.titleLabel.text = item.title
        view.priceLabel.text = item.price
        view.productImage.image = item.image
        view.aisleLabel.text = item.aisle
    }
    
    func selectView(_ view: ProductListView, item: ListItemViewState) {
        dispatcher?.triggerEvent(ListItemPressed())
    }
}

extension ProductListComponent: HarmonyLayoutComponent {
    func heightForLayout(_ layout: HarmonyLayout, item: TempoViewStateItem, width: CGFloat) -> CGFloat {
        return 150.0
    }
    
    func sectionMarginsForLayout(_ layout: HarmonyLayout) -> HarmonyLayoutMargins {
        return HarmonyLayoutMargins(top: .half, right: .quarter, bottom: .half, left: .none)
    }
}
