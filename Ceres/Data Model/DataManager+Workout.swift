//
//  DataManager+Workout.swift
//  Ceres
//
//  Created by Edmundas Matusevicius on 2021-11-24.
//

import Foundation
import CoreData

protocol WorkoutDataManagerProtocol {
    func createWorkout(title: String?, type: DMWorkoutType, category: DMWorkoutCategory)
}

// MARK: - WorkoutDataManagerProtocol
extension DataManager: WorkoutDataManagerProtocol {
    func createWorkout(title: String?, type: DMWorkoutType, category: DMWorkoutCategory) {
        context.performAndWait {
            do {
                let workout = DMWorkout(context: context)
                workout.title = title
                workout.type = type.rawValue
                workout.category = category.rawValue
                
                try context.save()
            } catch {
                // TODO: CoreData - Handle error
                fatalError("Unresolved error: \(error)")
            }
        }
    }
}
