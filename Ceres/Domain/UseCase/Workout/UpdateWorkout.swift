//
//  UpdateWorkout.swift
//  Ceres
//
//  Created by Edmundas Matusevičius on 2022-03-28.
//

import Foundation

protocol UpdateWorkout {
    func execute(workout: Workout) async -> Result<Bool, WorkoutError>
}

struct UpdateWorkoutUseCase: UpdateWorkout {
    var repo: WorkoutRepository
    
    func execute(workout: Workout) async -> Result<Bool, WorkoutError> {
        let result = await repo.updateWorkout(workout)
        return result
    }
}
