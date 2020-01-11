//
//  NetworkSession.swift
//  ProductViewer
//
//  Created by Greg Silesky on 1/10/20.
//  Copyright © 2020 Target. All rights reserved.
//

import Foundation

// MARK: - NetworkSession
protocol NetworkSession {
    
    func request(from url: URL,
                  completionHandler: @escaping (Data?, HTTPURLResponse?, Error?) -> Void)
}

// MARK: - URLSession
extension URLSession: NetworkSession {
    /// Responsible for sending a request and receiving the response and associated data from the server.
    ///
    /// This operation is fully asynchronous.
    ///
    /// - parameter url:    The URL to be retrieved.
    /// - parameter completionHandler:  The completion handler returns the results of the network request.
    func request(from url: URL,
                  completionHandler: @escaping (Data?, HTTPURLResponse?, Error?) -> Void) {
        let task = dataTask(with: url) { (data, response, error) in
            completionHandler(data, response as? HTTPURLResponse, error)
        }

        task.resume()
    }
}
