//
//  MovementDefinitionCoreDataSourceImpl.swift
//  Ceres
//
//  Created by Edmundas Matusevičius on 2022-04-01.
//

import Foundation
import CoreData

struct MovementDefinitionCoreDataSourceImpl: MovementDefinitionDataSource {
    let persistenceController: PersistenceController
    let container: NSPersistentContainer

    init() {
        persistenceController = PersistenceController.shared
        container = persistenceController.container
    }

    func getAll() throws -> [MovementDefinition] {
        let request = MovementDefinitionEntity.fetchRequest()
        let context = container.viewContext
        return try context.fetch(request).map {
            MovementDefinition($0)
        }
    }

    func getById(_ id: UUID) throws -> MovementDefinition? {
        let entity = try getEntityById(id)!
        return MovementDefinition(entity)
    }

    func delete(_ id: UUID) throws {
        let entity = try getEntityById(id)!
        let context = container.viewContext
        context.delete(entity)
        do {
            try context.save()
        } catch {
            context.rollback()
            fatalError("Error: \(error.localizedDescription)")
        }
    }

    func update(id: UUID, movementDefinition: MovementDefinition) throws {
        let entity = try getEntityById(id)!
        movementDefinition.updateMovementDefinitionEntity(entity)
        saveContext()
    }

    func create(movementDefinition: MovementDefinition) throws {
        let context = container.viewContext
        _ = movementDefinition.movementDefinitionEntity(context: context)
        saveContext()
    }

    func getEntityById(_ id: UUID) throws -> MovementDefinitionEntity? {
        let request = MovementDefinitionEntity.fetchRequest()
        request.fetchLimit = 1
        request.predicate = NSPredicate(
            format: "id = %@", id.uuidString)
        let context = container.viewContext
        let entity = try context.fetch(request)[0]
        return entity
    }

    private func saveContext() {
        let context = container.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                fatalError("Error: \(error.localizedDescription)")
            }
        }
    }
}

extension MovementDefinition {
    init(_ entity: MovementDefinitionEntity) {
        id = entity.id
        title = entity.title
    }

    func movementDefinitionEntity(context: NSManagedObjectContext) -> MovementDefinitionEntity {
        let entity = MovementDefinitionEntity(context: context)
        entity.id = self.id
        entity.title = self.title

        return entity
    }

    func updateMovementDefinitionEntity(_ entity: MovementDefinitionEntity) {
        entity.title = title
    }
}
