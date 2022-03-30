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
            let workout = try await dataSource.getById(id)
            return .success(workout)
        } catch {
            return .failure(.fetchError)
        }
    }

    func deleteWorkout(_ id: UUID) async -> Result<Bool, WorkoutError> {
        do {
            try await dataSource.delete(id)
            return .success(true)
        } catch {
            return .failure(.deleteError)
        }
    }

    func createWorkout(_ workout: Workout) async -> Result<Bool, WorkoutError> {
        do {
            try await dataSource.create(workout: workout)
            return .success(true)
        } catch {
            return .failure(.createError)
        }
    }

    func updateWorkout(_ workout: Workout) async -> Result<Bool, WorkoutError> {
        do {
            try await dataSource.update(id: workout.id, workout: workout)
            return .success(true)
        } catch {
            return .failure(.updateError)
        }
    }

    func getWorkouts() async -> Result<[Workout], WorkoutError> {
        do {
            let workouts = try await dataSource.getAll()
            return .success(workouts)
        } catch {
            return .failure(.fetchError)
        }
    }
}
