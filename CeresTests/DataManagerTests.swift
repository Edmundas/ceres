//
//  DataManagerTests.swift
//  DataManagerTests
//
//  Created by Edmundas Matusevicius on 2021-11-24.
//

import XCTest
@testable import Ceres
import CoreData

class DataManagerTests: XCTestCase {
    
    var dataManager: DataManager!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        dataManager = DataManager(persistenceController: PersistenceController.testing)
    }
    
    override func tearDownWithError() throws {
        dataManager = nil
        try super.tearDownWithError()
    }
    
    // MARK: Test
    
    func testCreateWorkout() throws {
        expectation(forNotification: .NSManagedObjectContextDidSave, object: dataManager.context) { _ in
            return true
        }
        
        dataManager.context.perform {
            self.dataManager.createWorkout(title: "Test workout #1", type: .ft, category: .hero)
        }
        
//        let request: NSFetchRequest<DMWorkout> = DMWorkout.fetchRequest()
//        do {
//            let workoutsCount = try dataManager.context.count(for: request)
//            XCTAssertEqual(workoutsCount, 1, "Save did not occur")
//        } catch {
//            fatalError("Unresolved error: \(error)")
//        }
        
        waitForExpectations(timeout: 2.0) { error in
            XCTAssertNil(error, "Save did not occur")
        }
    }
    
    func testDeleteWorkout() throws {
        // TODO: testDeleteWorkout
//        dataManager.deleteWorkout(<#T##workout: DMWorkout##DMWorkout#>)
    }
    
}
