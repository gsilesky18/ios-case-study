//
//  Products.swift
//  ProductViewer
//
//  Created by Greg Silesky on 1/9/20.
//  Copyright © 2020 Target. All rights reserved.
//

import Foundation

struct Products: Codable {
    let _id: String
    let data: [Product]
}
