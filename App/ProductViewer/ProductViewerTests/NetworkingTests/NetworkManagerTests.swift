//
//  NetworkManagerTests.swift
//  ProductViewerTests
//
//  Created by Greg Silesky on 1/11/20.
//  Copyright © 2020 Target. All rights reserved.
//

import XCTest
@testable import ProductViewer

class NetworkManagerTests: XCTestCase {

    var session: NetworkSessionMock!
    var manager: NetworkManager!
    let url: URL = URL(fileURLWithPath: "url") // Create a URL (using the file path API to avoid optionals)
    
    override func setUp() {
        // Setup objects
        session = NetworkSessionMock()
        manager = NetworkManager(session: session)
    }

    override func tearDown() {
        session = nil
        manager = nil
    }

    func testSuccessfulResponse() {
        //Arrange
        let data = Data([0, 1, 0, 1]) // Create data for session to return
        session.data = data
        //Act
        var result: Result<Data, RequestError>?
        manager.request(from: url) { result = $0 } // Perform the request
        //Assert
        switch result {
        case .success(let data)?:
            XCTAssertEqual(data, data) //Verify that data matches
        case .failure(let error)?:
            XCTFail("Error: \(error.localizedDescription)")
        default:
            XCTFail("No result loaded")
        }
    }
    
    func testNoInternetError() {
        //Arrange
        let error = URLError(URLError.notConnectedToInternet) // Create no internet error for session to return
        session.error = error
        //Act
        var result: Result<Data, RequestError>?
        manager.request(from: url) { result = $0 } // Perform the request

        switch result {
        case .success( _)?:
            XCTFail("Should not be successful.")
        case .failure(let err)?:
            XCTAssertEqual(err.cause?.localizedDescription, error.localizedDescription) //Verify the descriptions match
        default:
            XCTFail("No result loaded")
        }
    }
    
    func testResourceUnavailableError() {
        //Arrange
        let error = URLError(URLError.resourceUnavailable) // Create resource unavailable error for session to return
        let httpStatusCode = 500
        session.error = error
        session.response = HTTPURLResponse(url: url, statusCode: httpStatusCode, httpVersion: nil, headerFields: nil)
        //Act
        var result: Result<Data, RequestError>?
        manager.request(from: url) { result = $0 } // Perform the request
        //Assert
        switch result {
        case .success( _)?:
            XCTFail("Should not be successful.")
        case .failure(let err)?:
            XCTAssertEqual(err.cause?.localizedDescription, error.localizedDescription) //Verify the descriptions match
            XCTAssertEqual(err.httpStatusCode, httpStatusCode) //Verify the status codes match
        default:
            XCTFail("No result loaded")
        }
    }

}
