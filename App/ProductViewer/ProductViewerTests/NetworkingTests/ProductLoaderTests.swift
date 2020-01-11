//
//  ProductLoaderTests.swift
//  ProductViewerTests
//
//  Created by Greg Silesky on 1/11/20.
//  Copyright © 2020 Target. All rights reserved.
//

import XCTest
@testable import ProductViewer

class ProductLoaderTests: XCTestCase {
    var session: NetworkSessionMock!
    var manager: NetworkManager!
    var loader: ProductLoader!
    
    override func setUp() {
        // Setup objects
        session = NetworkSessionMock()
        manager = NetworkManager(session: session)
        loader = ProductLoader(manager: manager)
    }

    override func tearDown() {
        session = nil
        manager = nil
        loader = nil
    }
    
    public func testSuccessfulResponse() {
        //Arrange
        let product = Product(_id: "548917fabeb9b0cadc529af3", aisle: "b2", description: "minim ad et minim ipsum duis irure pariatur deserunt eu cillum anim", guid: "f78e1c4d-93c5-4b92-ae47-7ea26be48c7c", image: "http://lorempixel.com/400/400/", index: 0, price: "$184.06", salePrice: nil, title: "non mollit veniam ex")
        let products = Products(_id: "548917fabac802c195b616b1", data: [product])
        let encoder = JSONEncoder()
        session.data = try! encoder.encode(products) //Create data for network response
        //Act
        var result: Result<[Product], RequestError>?
        loader.fetchProducts { result = $0 } // Perform the request
        //Assert
        switch result {
        case .success(let productList)?:
            XCTAssertEqual(productList, products.data)
        case .failure(let error)?:
            XCTFail("Error: \(error.localizedDescription)")
        default:
            XCTFail("No result loaded")
        }
    }
    
    func testDecoderFailure(){
        //Arrange
        session.data = """
        {
            "_id": "548917fabeb9b0cadc529af3",
            "products": []
        }
        """.data(using: .utf8)! //Setup invalided json object
        //Act
        var result: Result<[Product], RequestError>?
        loader.fetchProducts { result = $0 } // Perform the request
        //Assert
        switch result {
        case .success( _)?:
            XCTFail("Should not be successful.")
        case .failure(let err)?:
            XCTAssertEqual(err.cause?.localizedDescription, "The data couldn’t be read because it is missing.")
        default:
            XCTFail("No result loaded")
        }
    }
}
