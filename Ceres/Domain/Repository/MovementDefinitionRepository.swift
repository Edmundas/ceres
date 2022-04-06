//
//  MovementDefinitionRepository.swift
//  Ceres
//
//  Created by Edmundas Matusevičius on 2022-04-01.
//

import Foundation

protocol MovementDefinitionRepository {
    func getMovementDefinitions() async -> Result<[MovementDefinition], MovementDefinitionError>
    func getMovementDefinition(id: UUID) async -> Result<MovementDefinition?, MovementDefinitionError>
    func deleteMovementDefinition(_ id: UUID) async -> Result<Bool, MovementDefinitionError>
    func createMovementDefinition(_ movementDefinition: MovementDefinition)
    async -> Result<Bool, MovementDefinitionError>
    func updateMovementDefinition(_ movementDefinition: MovementDefinition)
    async -> Result<Bool, MovementDefinitionError>
}
