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
        let newWorkout = dataManager.createWorkout(title: "Test workout #1", type: .ft, category: .hero)
        XCTAssertNotNil(newWorkout, "Did not create a workout")
        
        let request: NSFetchRequest<DMWorkout> = DMWorkout.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", newWorkout!.id as CVarArg)
        do {
            let workoutsCount = try dataManager.context.count(for: request)
            XCTAssertEqual(workoutsCount, 1, "Did not create a workout")
        } catch {
            fatalError("Unresolved error: \(error)")
        }
    }
    
    func testDeleteWorkout() throws {
        var initialWorkoutsCount = 0
        let request: NSFetchRequest<DMWorkout> = DMWorkout.fetchRequest()
        do {
            initialWorkoutsCount = try dataManager.context.count(for: request)
        } catch {
            fatalError("Unresolved error: \(error)")
        }
        
        let workout = DMWorkout(context: dataManager.context)
        workout.title = "Test workout #1"
        workout.type = DMWorkoutType.none.rawValue
        workout.category = DMWorkoutCategory.none.rawValue
        
        do {
            try dataManager.context.save()
        } catch {
            fatalError("Unresolved error: \(error)")
        }
        
        dataManager.deleteWorkout(workout)
        
        do {
            let finalWorkoutsCount = try dataManager.context.count(for: request)
            XCTAssertEqual(initialWorkoutsCount, finalWorkoutsCount, "Did not delete a workout")
        } catch {
            fatalError("Unresolved error: \(error)")
        }
    }
    
}
