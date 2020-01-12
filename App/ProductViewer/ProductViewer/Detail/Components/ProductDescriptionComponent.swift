//
//  ProductDescriptionComponent.swift
//  ProductViewer
//
//  Created by Greg Silesky on 1/12/20.
//  Copyright © 2020 Target. All rights reserved.
//

import Tempo

struct ProductDescriptionComponent: Component {
    var dispatcher: Dispatcher?
    var descriptionFont: UIFont = UIFont.systemFont(ofSize: 15)
    
    func configureView(_ view: ProductDescriptionView, item: ProductDescriptionViewState) {
        view.descriptionLabel.text = item.description
    }
}

extension ProductDescriptionComponent: HarmonyLayoutComponent {
    func heightForLayout(_ layout: HarmonyLayout, item: TempoViewStateItem, width: CGFloat) -> CGFloat {
        if let descriptionItem = item as? ProductDescriptionViewState {
            return descriptionItem.description.calculateHeight(font: descriptionFont, width: width - 8)
        }
        return 214
    }
}
