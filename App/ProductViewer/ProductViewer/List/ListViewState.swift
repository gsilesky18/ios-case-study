//
//  ListViewState.swift
//  ProductViewer
//
//  Copyright © 2016 Target. All rights reserved.
//

import Tempo

/// List view state
struct ListViewState: TempoViewState, TempoSectionedViewState {
    var listItems: [TempoViewStateItem]
    
    var sections: [TempoViewStateItem] {
        return listItems
    }
}

/// View state for each list item.
struct ListItemViewState: TempoViewStateItem, Equatable {
    let title: String
    let price: String
    let image: UIImage?
}

func ==(lhs: ListItemViewState, rhs: ListItemViewState) -> Bool {
    return lhs.title == rhs.title
        && lhs.price == rhs.price
        && lhs.image == rhs.image
}
