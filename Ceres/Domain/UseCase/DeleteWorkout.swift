//
//  DeleteWorkout.swift
//  Ceres
//
//  Created by Edmundas Matusevičius on 2022-03-25.
//

import Foundation

protocol DeleteWorkout {
    
    func execute(id: UUID) async -> Result<Bool, WorkoutError>
    
}

struct DeleteWorkoutUseCase: DeleteWorkout {
    
    var repo: WorkoutRepository
    
    func execute(id: UUID) async -> Result<Bool, WorkoutError> {
        let result = await repo.deleteWorkout(id)
        return result
    }
    
}
