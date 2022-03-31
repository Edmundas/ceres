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
        orderNumber = Int(roundEntity.orderNumber)

        let roundEntityMovements = roundEntity.movements?.map {
            Movement(movementEntity: $0)
        }.sorted {
            $0.orderNumber < $1.orderNumber
        }
        movements = roundEntityMovements ?? []
    }

    func roundEntity(context: NSManagedObjectContext) -> RoundEntity {
        let roundEntity = RoundEntity(context: context)
        roundEntity.id = self.id
        roundEntity.orderNumber = Int16(self.orderNumber)

        let roundEntityMovements: [MovementEntity] = self.movements.enumerated().map {
            let entity = $0.element.movementEntity(context: context)
            entity.orderNumber = Int16($0.offset)
            return entity
        }
        roundEntity.movements = !roundEntityMovements.isEmpty ? Set(roundEntityMovements) : nil

        return roundEntity
    }

    func updateMovements(for roundEntity: RoundEntity) {
        guard let context = roundEntity.managedObjectContext else { return }

        var roundEntityMovements = roundEntity.movements
        var updatedRoundEntityMovements: Set<MovementEntity> = []

        for (index, movement) in movements.enumerated() {
            // update movement
            if let roundEntityMovement = roundEntityMovements?.first(where: { $0.id == movement.id }) {
                roundEntityMovement.orderNumber = Int16(index)

                updatedRoundEntityMovements.insert(roundEntityMovement)
                roundEntityMovements?.remove(roundEntityMovement)
            }
            // create movement
            else {
                let roundEntityMovement = movement.movementEntity(context: context)
                roundEntityMovement.orderNumber = Int16(index)

                updatedRoundEntityMovements.insert(roundEntityMovement)
            }
        }
        // delete movement
        roundEntityMovements?.forEach {
            context.delete($0)
        }
        roundEntity.movements = updatedRoundEntityMovements
    }
}
