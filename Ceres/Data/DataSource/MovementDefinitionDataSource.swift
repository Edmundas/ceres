//
//  MovementDefinitionDataSource.swift
//  Ceres
//
//  Created by Edmundas Matusevičius on 2022-04-01.
//

import Foundation

protocol MovementDefinitionDataSource {
    func getAll() async throws -> [MovementDefinition]
    func getById(_ id: UUID) async throws -> MovementDefinition?
    func delete(_ id: UUID) async throws
    func create(movementDefinition: MovementDefinition) async throws
    func update(id: UUID, movementDefinition: MovementDefinition) async throws
}
