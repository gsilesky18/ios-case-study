//
//  ProductAddToComponent.swift
//  ProductViewer
//
//  Created by Greg Silesky on 1/12/20.
//  Copyright © 2020 Target. All rights reserved.
//

import Tempo

class ProductAddToComponent: Component {
    var dispatcher: Dispatcher?

    func prepareView(_ view: ProductAddToView, item: ProductAddToViewState) {
        view.addToCartButton.addTarget(self, action: #selector(AddToCart), for: .touchUpInside)
        view.addToListButton.addTarget(self, action: #selector(AddToList), for: .touchUpInside)
    }
    
    func configureView(_ view: ProductAddToView, item: ProductAddToViewState) {

    }
    
    @objc func AddToCart(){
        dispatcher?.triggerEvent(AddToCartPressed())
    }
    
    @objc func AddToList(){
        dispatcher?.triggerEvent(AddToListPressed())
    }
}

extension ProductAddToComponent: HarmonyLayoutComponent {
    func heightForLayout(_ layout: HarmonyLayout, item: TempoViewStateItem, width: CGFloat) -> CGFloat {
        return 130
    }
}

