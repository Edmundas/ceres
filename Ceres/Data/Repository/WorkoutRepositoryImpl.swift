//
//  WorkoutRepositoryImpl.swift
//  Ceres
//
//  Created by Edmundas Matusevičius on 2022-03-25.
//

import Foundation

struct WorkoutRepositoryImpl: WorkoutRepository {
    var dataSource: WorkoutDataSource
    
    func getWorkout(id: UUID) async -> Result<Workout?, WorkoutError> {
        do {
            let _workout = try await dataSource.getById(id)
            return .success(_workout)
        } catch {
            return .failure(.FetchError)
        }
    }
    
    func deleteWorkout(_ id: UUID) async -> Result<Bool, WorkoutError> {
        do {
            try await dataSource.delete(id)
            return .success(true)
        } catch {
            return .failure(.DeleteError)
        }
    }
    
    func createWorkout(_ workout: Workout) async -> Result<Bool, WorkoutError> {
        do {
            try await dataSource.create(workout: workout)
            return .success(true)
        } catch {
            return .failure(.CreateError)
        }
    }
    
    func updateWorkout(_ workout: Workout) async -> Result<Bool, WorkoutError> {
        do {
            try await dataSource.update(id: workout.id, workout: workout)
            return .success(true)
        } catch {
            return .failure(.UpdateError)
        }
    }
    
    func getWorkouts() async -> Result<[Workout], WorkoutError> {
        do {
            let _workouts = try await dataSource.getAll()
            return .success(_workouts)
        } catch {
            return .failure(.FetchError)
        }
    }
}
