//
//  DataManager+Workout.swift
//  Ceres
//
//  Created by Edmundas Matusevicius on 2021-11-24.
//

import Foundation
import CoreData

protocol WorkoutDataManagerProtocol {
    func createWorkout()
}

// MARK: - WorkoutDataManagerProtocol
extension DataManager: WorkoutDataManagerProtocol {
    func createWorkout() {
        // TODO: implement 'createWorkout'
    }
}
