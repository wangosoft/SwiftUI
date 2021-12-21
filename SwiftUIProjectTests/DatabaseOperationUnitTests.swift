//
//  DatabaseOperationUnitTests.swift
//  SwiftUIProjectTests
//
//  Created by Onur GÜLER on 19.12.2021.
//

import XCTest
import CoreData
@testable import SwiftUIProject

class DatabaseOperationUnitTests: XCTestCase {

    func test_StoreObjects_ToDatabase() {
        // Arrange
        let databaseManager = DatabaseUtility.getSharedInstance(persistentStoreType: NSInMemoryStoreType)
        expectation(forNotification: .NSManagedObjectContextDidSave, object: databaseManager.managedObjectContext) { _ in
            return true
        }
      
        // Act
        databaseManager.storeObjects(entity: .fruits, objects: XCUnitTest.MockData.fruit)
             
        // Assert
        waitForExpectations(timeout: ServiceConstants.Config.timeout) { error in
            XCTAssertNil(error, "Save context changes did not occur")
        }
    }
        
    func test_FetchObjects_FromDatabase() {
        // Arrange
        let databaseManager = DatabaseUtility.getSharedInstance(persistentStoreType: NSInMemoryStoreType)
        expectation(forNotification: .NSManagedObjectContextDidSave, object: databaseManager.managedObjectContext) { _ in
            return true
        }
        databaseManager.storeObjects(entity: .fruits, objects: XCUnitTest.MockData.fruit)

        waitForExpectations(timeout: ServiceConstants.Config.timeout) { error in
            // Act
            let fruit: [FruitModel]? = databaseManager.fetchObjects(entity: .fruits)
            
            // Assert
            XCTAssertNotNil(fruit)
            XCTAssertEqual(fruit?.first?.id, XCUnitTest.MockData.fruit.first?.id)
        }
    }
    
    func test_FetchObjectsWithId_FromDatabase() {
        // Arrange
        let databaseManager = DatabaseUtility.getSharedInstance(persistentStoreType: NSInMemoryStoreType)
        expectation(forNotification: .NSManagedObjectContextDidSave, object: databaseManager.managedObjectContext) { _ in
            return true
        }
        databaseManager.storeObjects(entity: .fruits, objects: XCUnitTest.MockData.fruit)

        waitForExpectations(timeout: ServiceConstants.Config.timeout) { error in
            // Act
            let fruit: FruitModel? = databaseManager.fetchObjectsWithId(entity: .fruits, id: XCUnitTest.MockData.fruit.first!.id)
            
            // Assert
            XCTAssertNotNil(fruit)
            XCTAssertEqual(fruit?.id, XCUnitTest.MockData.fruit.first?.id)
        }
    }
    
    func test_Update_OnDatabase() {
        // Arrange
        let databaseManager = DatabaseUtility.getSharedInstance(persistentStoreType: NSInMemoryStoreType)

        // Act
        databaseManager.update(entity: .fruits, theObject: XCUnitTest.MockData.updateWithFruit, with: XCUnitTest.MockData.fruit_description, key: Storage.UpdateKeys.fruit_description)
        
        let fruit: FruitModel? = databaseManager.fetchObjectsWithId(entity: .fruits, id: XCUnitTest.MockData.fruit.first!.id)
        
        // Assert
        XCTAssertNotNil(fruit)
        XCTAssertEqual(fruit?.description, XCUnitTest.MockData.fruit.first?.description)
    }
    
}
