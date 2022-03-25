//
//  GetWorkouts.swift
//  Ceres
//
//  Created by Edmundas Matusevičius on 2022-03-25.
//

import Foundation

protocol GetWorkouts {
    
    func execute() async -> Result<[Workout], WorkoutError>
    
}

struct GetWorkoutsUseCase: GetWorkouts {
    
    var repo: WorkoutRepository
    
    func execute() async -> Result<[Workout], WorkoutError> {
        let workouts = await repo.getWorkouts()
        return workouts
    }
    
}
