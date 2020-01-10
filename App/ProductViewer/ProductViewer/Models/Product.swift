//
//  Product.swift
//  ProductViewer
//
//  Created by Greg Silesky on 1/9/20.
//  Copyright © 2020 Target. All rights reserved.
//

import Foundation

struct Product: Codable {
    let _id: String
    let aisle: String
    let description: String
    let guid: String
    let image: String
    let index: Int
    let price: Double
    let salePrice: Double?
    let title: String
}
