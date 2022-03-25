//
//  DataManager+Workout.swift
//  Ceres
//
//  Created by Edmundas Matusevicius on 2021-11-24.
//

import Foundation
import CoreData

protocol WorkoutDataManagerProtocol {
    func saveWorkout(title: String?, type: DMWorkoutType, category: DMWorkoutCategory, metrics: [DMMetric]?)
    func updateWorkout(_ workout: DMWorkout)
    func deleteWorkout(_ workout: DMWorkout)
}

// MARK: - WorkoutDataManagerProtocol
extension DataManager: WorkoutDataManagerProtocol {
    func saveWorkout(title: String?, type: DMWorkoutType, category: DMWorkoutCategory, metrics: [DMMetric]?) {
        context.performAndWait {
            do {
                let workout = DMWorkout(context: context)
                workout.title = title
                workout.type = type.rawValue
                workout.category = category.rawValue
                
                if let workoutMetrics = metrics, workoutMetrics.count > 0 {
                    workout.metrics = Set(workoutMetrics)
                }
                
                try context.save()
            } catch {
                // TODO: CoreData - Handle error
                fatalError("Unresolved error: \(error)")
            }
        }
    }
    
    func updateWorkout(_ workout: DMWorkout) {
        context.performAndWait {
            do {
                try context.save()
            } catch {
                // TODO: CoreData - Handle error
                fatalError("Unresolved error: \(error)")
            }
        }
    }
    
    func deleteWorkout(_ workout: DMWorkout) {
        context.performAndWait {
            do {
                context.delete(workout)
                
                try context.save()
            } catch {
                // TODO: CoreData - Handle error
                fatalError("Unresolved error: \(error)")
            }
        }
    }
}
