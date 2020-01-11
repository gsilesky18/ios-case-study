//
//  NetworkManager.swift
//  ProductViewer
//
//  Created by Greg Silesky on 1/10/20.
//  Copyright © 2020 Target. All rights reserved.
//

import Foundation

// MARK: - NetworkManager

class NetworkManager {
    
    private let session: NetworkSession

    /// Creates a `NetworkManager` instance.
    ///
    ///  By using the NetworkSession protocol it allows us to easily add dependency injection for testing.
    ///
    /// - parameter session: An object used to create the network session task. The default is URL shared session.
    init(session: NetworkSession = URLSession.shared) {
        self.session = session
    }

    /// Responsible for determining the success or failure of the request.
    ///
    /// - parameter url:    The URL to be retrieved.
    /// - parameter completionHandler:  The completion handler returns either success or failure.
    func request(from url: URL,
                  completionHandler: @escaping (Result<Data, RequestError>) -> Void) {
        session.request(from: url) { [weak self] data, response, error in
            if self?.isError(httpStatusCode: response?.statusCode) ?? false || error != nil {
                return completionHandler(.failure(RequestError(response: response, cause: error)))
            }

            return completionHandler(.success(data ?? Data()))
        }
    }
    
    /// Validate that the response has a status code less than 400
    ///
    /// - parameter httpStatusCode: The HTTP status code 
    ///
    /// - returns: Boolean value indicating if the status code was an error
    func isError(httpStatusCode: Int?) -> Bool {
        guard let httpStatusCode = httpStatusCode else {
            return false
        }
        return httpStatusCode >= 400
    }
}
