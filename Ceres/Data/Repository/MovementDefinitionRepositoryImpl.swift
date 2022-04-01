//
//  MovementDefinitionRepositoryImpl.swift
//  Ceres
//
//  Created by Edmundas Matusevičius on 2022-04-01.
//

import Foundation

struct MovementDefinitionRepositoryImpl: MovementDefinitionRepository {
    var dataSource: MovementDefinitionDataSource

    func getMovementDefinition(id: UUID) async -> Result<MovementDefinition?, MovementDefinitionError> {
        do {
            let movementDefinition = try await dataSource.getById(id)
            return .success(movementDefinition)
        } catch {
            return .failure(.fetchError)
        }
    }

    func deleteMovementDefinition(_ id: UUID) async -> Result<Bool, MovementDefinitionError> {
        do {
            try await dataSource.delete(id)
            return .success(true)
        } catch {
            return .failure(.deleteError)
        }
    }

    func createMovementDefinition(_ movementDefinition: MovementDefinition)
    async -> Result<Bool, MovementDefinitionError> {
        do {
            try await dataSource.create(movementDefinition: movementDefinition)
            return .success(true)
        } catch {
            return .failure(.createError)
        }
    }

    func updateMovementDefinition(_ movementDefinition: MovementDefinition)
    async -> Result<Bool, MovementDefinitionError> {
        do {
            try await dataSource.update(id: movementDefinition.id, movementDefinition: movementDefinition)
            return .success(true)
        } catch {
            return .failure(.updateError)
        }
    }

    func getMovementDefinitions() async -> Result<[MovementDefinition], MovementDefinitionError> {
        do {
            let movementDefinitions = try await dataSource.getAll()
            return .success(movementDefinitions)
        } catch {
            return .failure(.fetchError)
        }
    }
}
