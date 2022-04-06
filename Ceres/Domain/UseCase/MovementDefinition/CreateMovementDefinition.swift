//
//  CreateMovementDefinition.swift
//  Ceres
//
//  Created by Edmundas Matusevičius on 2022-04-01.
//

import Foundation

protocol CreateMovementDefinition {
    func execute(movementDefinition: MovementDefinition) async -> Result<Bool, MovementDefinitionError>
}

struct CreateMovementDefinitionUseCase: CreateMovementDefinition {
    var repo: MovementDefinitionRepository

    func execute(movementDefinition: MovementDefinition) async -> Result<Bool, MovementDefinitionError> {
        let result = await repo.createMovementDefinition(movementDefinition)
        return result
    }
}
