//
//  Result+Decoder.swift
//  ProductViewer
//
//  Created by Greg Silesky on 1/11/20.
//  Copyright © 2020 Target. All rights reserved.
//

import Foundation


extension Result where Success == Data {
    ///Extension for easily decoding successful data response
    func decoded<T: Decodable>(
        using decoder: JSONDecoder = .init()
    ) throws -> T {
        let data = try get()
        return try decoder.decode(T.self, from: data)
    }
}
