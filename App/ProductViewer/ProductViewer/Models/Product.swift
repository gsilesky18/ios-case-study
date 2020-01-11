//
//  Product.swift
//  ProductViewer
//
//  Created by Greg Silesky on 1/9/20.
//  Copyright © 2020 Target. All rights reserved.
//

import Foundation

struct Product: Codable, Equatable {
    let _id: String
    let aisle: String
    let description: String
    let guid: String
    let image: String
    let index: Int
    let price: String
    let salePrice: String?
    let title: String
}
