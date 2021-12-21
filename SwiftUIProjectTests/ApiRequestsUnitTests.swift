//
//  ApiRequestsUnitTests.swift
//  SwiftUIProjectTests
//
//  Created by Onur GÜLER on 19.12.2021.
//

import XCTest
@testable import SwiftUIProject

class ApiRequestsUnitTests: XCTestCase {
    
    func test_RequestList_ReturnResult()  {
        // Arrange
        let expectation = self.expectation(description: XCUnitTest.Expectation.waitAsyncListApiRequest)
        expectation.fulfill()

        // Act
        Service.shared.getFruits { response, error in
            // Assert
            XCTAssertNotNil(response)
            XCTAssertNil(error)
            XCTAssertNotNil(response?.products)
            XCTAssertGreaterThan(response?.products.count ?? .zero, .zero)
        }
        self.waitForExpectations(timeout: ServiceConstants.Config.timeout, handler: nil)
    }
        
    func test_RequestDetail_ReturnResult()  {
        // Arrange
        let expectation = self.expectation(description: XCUnitTest.Expectation.waitAsyncDetailApiRequest)
        expectation.fulfill()

        // Act
        Service.shared.getFruitDetail(productId: XCUnitTest.MockData.productId) { response, error in
            // Assert
            XCTAssertNotNil(response)
            XCTAssertNil(error)
        }
        self.waitForExpectations(timeout: ServiceConstants.Config.timeout, handler: nil)
    }
        
    func test_LoadImageRequest_ReturnImage()  {
        // Arrange
        let expectation = self.expectation(description: XCUnitTest.Expectation.waitAsyncLoadImageApiRequest)
        expectation.fulfill()

        // Act
        Service.shared.loadImage(urlString: XCUnitTest.MockData.imageUrl) { image in
            // Assert
            XCTAssertNotNil(image)
        }
        self.waitForExpectations(timeout: ServiceConstants.Config.timeout, handler: nil)
    }

}
