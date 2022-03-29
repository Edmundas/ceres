//
//  WorkoutDataSource.swift
//  Ceres
//
//  Created by Edmundas Matusevičius on 2022-03-25.
//

import Foundation

protocol WorkoutDataSource {
    func getAll() async throws -> [Workout]
    func getById(_ id: UUID) async throws -> Workout?
    func delete(_ id: UUID) async throws -> ()
    func create(workout: Workout) async throws -> ()
    func update(id: UUID, workout: Workout) async throws -> ()
}
