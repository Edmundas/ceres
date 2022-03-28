//
//  WorkoutCoreDataSourceImpl.swift
//  Ceres
//
//  Created by Edmundas Matusevičius on 2022-03-25.
//

import Foundation
import CoreData

struct WorkoutCoreDataSourceImpl: WorkoutDataSource {
    let container: NSPersistentContainer
    
    init() {
        container = NSPersistentContainer(name: "Ceres")
        container.loadPersistentStores { description, error in
            if error != nil {
                fatalError("Cannot Load Core Data Model")
            }
        }
    }
    
    func getAll() throws -> [Workout] {
        let request = DMWorkout.fetchRequest()
        return try container.viewContext.fetch(request).map({ workoutEntity in
            Workout(
                id: workoutEntity.id,
                type: WorkoutType(rawValue: workoutEntity.type) ?? .none,
                category: WorkoutCategory(rawValue: workoutEntity.category) ?? .none,
                title: workoutEntity.title
            )
        })
    }
    
    func getById(_ id: UUID) throws -> Workout? {
        let workoutEntity = try getEntityById(id)!
        return Workout(
            id: workoutEntity.id,
            type: WorkoutType(rawValue: workoutEntity.type) ?? .none,
            category: WorkoutCategory(rawValue: workoutEntity.category) ?? .none,
            title: workoutEntity.title
        )
    }
    
    func delete(_ id: UUID) throws -> () {
        let workoutEntity = try getEntityById(id)!
        let context = container.viewContext;
        context.delete(workoutEntity)
        do {
            try context.save()
        } catch {
            context.rollback()
            fatalError("Error: \(error.localizedDescription)")
        }
    }
    
    func update(id: UUID, workout: Workout) throws -> () {
        let workoutEntity = try getEntityById(id)!
        workoutEntity.title = workout.title
        workoutEntity.category = workout.category.rawValue
        workoutEntity.type = workout.type.rawValue
        saveContext()
    }
    
    func create(workout: Workout) throws -> () {
        let workoutEntity = DMWorkout(context: container.viewContext)
        workoutEntity.title = workout.title
        workoutEntity.category = workout.category.rawValue
        workoutEntity.type = workout.type.rawValue
        workoutEntity.id = workout.id
        saveContext()
    }
    
    private func getEntityById(_ id: UUID) throws -> DMWorkout? {
        let request = DMWorkout.fetchRequest()
        request.fetchLimit = 1
        request.predicate = NSPredicate(
            format: "id = %@", id.uuidString)
        let context =  container.viewContext
        let workoutEntity = try context.fetch(request)[0]
        return workoutEntity
    }
    
    private func saveContext() {
        let context = container.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                fatalError("Error: \(error.localizedDescription)")
            }
        }
    }
}
