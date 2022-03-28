//
//  WorkoutRepository.swift
//  Ceres
//
//  Created by Edmundas Matusevičius on 2022-03-25.
//

import Foundation

protocol WorkoutRepository {
    func getWorkouts() async -> Result<[Workout], WorkoutError>
    func getWorkout(id: UUID) async -> Result<Workout?, WorkoutError>
    func deleteWorkout(_ id: UUID) async -> Result<Bool, WorkoutError>
    func createWorkout(_ workout: Workout) async -> Result<Bool, WorkoutError>
    func updateWorkout(_ workout: Workout) async -> Result<Bool, WorkoutError>
}
