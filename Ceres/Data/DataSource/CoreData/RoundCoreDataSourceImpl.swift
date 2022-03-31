//
//  RoundCoreDataSourceImpl.swift
//  Ceres
//
//  Created by Edmundas Matusevičius on 2022-03-31.
//

import Foundation
import CoreData

struct RoundCoreDataSourceImpl: RoundDataSource {
    let persistenceController: PersistenceController
    let container: NSPersistentContainer

    init() {
        persistenceController = PersistenceController.shared
        container = persistenceController.container
    }

    private func getEntityById(_ id: UUID) throws -> RoundEntity? {
        let request = RoundEntity.fetchRequest()
        request.fetchLimit = 1
        request.predicate = NSPredicate(
            format: "id = %@", id.uuidString)
        let context = container.viewContext
        let roundEntity = try context.fetch(request)[0]
        return roundEntity
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

extension Round {
    init(roundEntity: RoundEntity) {
        id = roundEntity.id
        createDate = roundEntity.createDate
        orderNumber = Int(roundEntity.orderNumber)
    }

    func roundEntity(context: NSManagedObjectContext) -> RoundEntity {
        let roundEntity = RoundEntity(context: context)
        roundEntity.id = self.id
        roundEntity.createDate = self.createDate
        roundEntity.orderNumber = Int16(self.orderNumber)

        return roundEntity
    }
}
