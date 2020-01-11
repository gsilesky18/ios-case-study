//
//  NetworkSessionMock.swift
//  ProductViewerTests
//
//  Created by Greg Silesky on 1/11/20.
//  Copyright © 2020 Target. All rights reserved.
//

import Foundation
@testable import ProductViewer

class NetworkSessionMock: NetworkSession {
    var data: Data?
    var response: HTTPURLResponse?
    var error: Error?

    func request(from url: URL,
                  completionHandler: @escaping (Data?, HTTPURLResponse?, Error?) -> Void) {
        completionHandler(data, response, error)
    }
}
