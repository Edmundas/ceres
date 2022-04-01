//
//  GetMovementDefinitions.swift
//  Ceres
//
//  Created by Edmundas Matusevičius on 2022-04-01.
//

import Foundation

protocol GetMovementDefinitions {
    func execute() async -> Result<[MovementDefinition], MovementDefinitionError>
}

struct GetMovementDefinitionsUseCase: GetMovementDefinitions {
    var repo: MovementDefinitionRepository

    func execute() async -> Result<[MovementDefinition], MovementDefinitionError> {
        let result = await repo.getMovementDefinitions()
        return result
    }
}
