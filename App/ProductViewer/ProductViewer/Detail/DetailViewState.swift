//
//  DetailViewState.swift
//  ProductViewer
//
//  Created by Greg Silesky on 1/8/20.
//  Copyright © 2020 Target. All rights reserved.
//

import Tempo

/// List view state
struct DetailViewState: TempoViewState, TempoSectionedViewState {
    //var listItems: [TempoViewStateItem]
    var image: TempoViewStateItem
    var price: TempoViewStateItem
    var description: TempoViewStateItem
    var addTo: TempoViewStateItem
    var sections: [TempoViewStateItem] {
        return [image, price, description, addTo]
    }
}

struct ProductImageViewState: TempoViewStateItem, Equatable {
    let imageUrl: URL?
}

func ==(lhs: ProductImageViewState, rhs: ProductImageViewState) -> Bool {
    return lhs.imageUrl == rhs.imageUrl
}

struct ProductPriceViewState: TempoViewStateItem, Equatable {
    let price: String
}

func ==(lhs: ProductPriceViewState, rhs: ProductPriceViewState) -> Bool {
    return lhs.price == rhs.price
}

struct ProductDescriptionViewState: TempoViewStateItem, Equatable {
    let description: String
}

func ==(lhs: ProductDescriptionViewState, rhs: ProductDescriptionViewState) -> Bool {
    return lhs.description == rhs.description
}

struct ProductAddToViewState: TempoViewStateItem {
}
