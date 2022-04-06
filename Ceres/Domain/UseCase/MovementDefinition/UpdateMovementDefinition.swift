//
//  UpdateMovementDefinition.swift
//  Ceres
//
//  Created by Edmundas Matusevičius on 2022-04-01.
//

import Foundation

protocol UpdateMovementDefinition {
    func execute(movementDefinition: MovementDefinition) async -> Result<Bool, MovementDefinitionError>
}

struct UpdateMovementDefinitionUseCase: UpdateMovementDefinition {
    var repo: MovementDefinitionRepository

    func execute(movementDefinition: MovementDefinition) async -> Result<Bool, MovementDefinitionError> {
        let result = await repo.updateMovementDefinition(movementDefinition)
        return result
    }
}
