//
//  DeleteMovementDefinition.swift
//  Ceres
//
//  Created by Edmundas Matusevičius on 2022-04-01.
//

import Foundation

protocol DeleteMovementDefinition {
    func execute(id: UUID) async -> Result<Bool, MovementDefinitionError>
}

struct DeleteMovementDefinitionUseCase: DeleteMovementDefinition {
    var repo: MovementDefinitionRepository

    func execute(id: UUID) async -> Result<Bool, MovementDefinitionError> {
        let result = await repo.deleteMovementDefinition(id)
        return result
    }
}
