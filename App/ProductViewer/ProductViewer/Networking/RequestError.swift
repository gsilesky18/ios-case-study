//
//  RequestError.swift
//  ProductViewer
//
//  Created by Greg Silesky on 1/10/20.
//  Copyright © 2020 Target. All rights reserved.
//

import Foundation

// MARK: - RequestError

struct RequestError: Error
{
    /// The HTTP status code (e.g. 404) if this error came from an HTTP response.
    var httpStatusCode: Int?

    /// Details about the underlying error.
    var cause: Error?

    /// Creates a `RequestError` instance.
    ///
    /// - parameter response: Metadata about the underlying response.
    /// - parameter cause: This indicates why the request failed.
    init(response: HTTPURLResponse?, cause: Error?) {
        self.httpStatusCode = response?.statusCode
        self.cause = cause
    }
}
