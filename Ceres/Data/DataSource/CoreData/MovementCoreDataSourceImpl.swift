//
//  MovementCoreDataSourceImpl.swift
//  Ceres
//
//  Created by Edmundas Matusevičius on 2022-03-31.
//

import Foundation
import CoreData

struct MovementCoreDataSourceImpl: MovementDataSource {
    let persistenceController: PersistenceController
    let container: NSPersistentContainer

    init() {
        persistenceController = PersistenceController.shared
        container = persistenceController.container
    }

    private func getEntityById(_ id: UUID) throws -> MovementEntity? {
        let request = MovementEntity.fetchRequest()
        request.fetchLimit = 1
        request.predicate = NSPredicate(
            format: "id = %@", id.uuidString)
        let context = container.viewContext
        let movementEntity = try context.fetch(request)[0]
        return movementEntity
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

extension Movement {
    init(movementEntity: MovementEntity) {
        id = movementEntity.id
        orderNumber = Int(movementEntity.orderNumber)
    }

    func movementEntity(context: NSManagedObjectContext) -> MovementEntity {
        let movementEntity = MovementEntity(context: context)
        movementEntity.id = self.id
        movementEntity.orderNumber = Int16(self.orderNumber)

        return movementEntity
    }
}
