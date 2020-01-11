//
//  ProductLoader.swift
//  ProductViewer
//
//  Created by Greg Silesky on 1/11/20.
//  Copyright © 2020 Target. All rights reserved.
//

import Foundation

class ProductLoader {
    
    ///The manager used to make the  request.
    private let manager: NetworkManager
    ///The URL to be retrieved.
    private let url: URL
    
    /// Creates a `ProductLoader` instance.
    ///
    /// By passing a manger to the initializer, we can easily test the fetch method.
    ///
    /// - parameter manager: The networking class used to make a request to the server.
    init(manager: NetworkManager) {
        self.manager = manager
        self.url = URL(string: "https://target-deals.herokuapp.com/api/deals")!
    }
    
    /// Responsible for decoding the JSON into a list of products.
    ///
    /// This operation is fully asynchronous.
    ///
    /// - parameter completionHandler:  The completion handler returns either a list of products or the underlying error.
    func fetchProducts(completionHandler: @escaping (Result<[Product], RequestError>) -> Void) {
        manager.request(from: url) { (result) in
            do {
                switch result {
                case .success(_):
                    let response = try result.decoded() as Products
                    return completionHandler(.success(response.data))
                case .failure(let error):
                    return completionHandler(.failure(error as RequestError))
                }
            } catch let error {
                return completionHandler(.failure(RequestError(response: nil, cause: error)))
            }
        }
    }
}
