//
//  CreateWorkout.swift
//  Ceres
//
//  Created by Edmundas Matusevičius on 2022-03-28.
//

import Foundation

protocol CreateWorkout {
    func execute(workout: Workout) async -> Result<Bool, WorkoutError>
}

struct CreateWorkoutUseCase: CreateWorkout {
    var repo: WorkoutRepository

    func execute(workout: Workout) async -> Result<Bool, WorkoutError> {
        let result = await repo.createWorkout(workout)
        return result
    }
}
