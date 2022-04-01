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

extension Round {
    init(_ entity: RoundEntity) {
        id = entity.id
        orderNumber = Int(entity.orderNumber)

        let entityMetrics = entity.metrics?.map {
            Metric($0)
        }.sorted {
            $0.createDate < $1.createDate
        }
        metrics = entityMetrics ?? []

        let entityMovements = entity.movements?.map {
            Movement($0)
        }.sorted {
            $0.orderNumber < $1.orderNumber
        }
        movements = entityMovements ?? []
    }

    func roundEntity(context: NSManagedObjectContext) -> RoundEntity {
        let entity = RoundEntity(context: context)
        entity.id = self.id
        entity.orderNumber = Int16(self.orderNumber)

        let entityMetrics: [MetricEntity] = self.metrics.map {
            $0.metricEntity(context: context)
        }
        entity.metrics = !entityMetrics.isEmpty ? Set(entityMetrics) : nil

        let entityMovements: [MovementEntity] = self.movements.enumerated().map {
            let entity = $0.element.movementEntity(context: context)
            entity.orderNumber = Int16($0.offset)
            return entity
        }
        entity.movements = !entityMovements.isEmpty ? Set(entityMovements) : nil

        return entity
    }

    func updateRoundEntity(_ entity: RoundEntity) {
        updateMetrics(for: entity)
        updateMovements(for: entity)
    }

    private func updateMetrics(for entity: RoundEntity) {
        guard let context = entity.managedObjectContext else { return }

        var entityMetrics = entity.metrics
        var updatedEntityMetrics: Set<MetricEntity> = []

        metrics.forEach { metric in
            // update metric
            if let entityMetric = entityMetrics?.first(where: { $0.id == metric.id }) {
                metric.updateMetricEntity(entityMetric)

                updatedEntityMetrics.insert(entityMetric)
                entityMetrics?.remove(entityMetric)
            }
            // create metric
            else {
                let entityMetric = metric.metricEntity(context: context)

                updatedEntityMetrics.insert(entityMetric)
            }
        }
        // delete metric
        entityMetrics?.forEach {
            context.delete($0)
        }
        entity.metrics = updatedEntityMetrics
    }

    private func updateMovements(for entity: RoundEntity) {
        guard let context = entity.managedObjectContext else { return }

        var entityMovements = entity.movements
        var updatedEntityMovements: Set<MovementEntity> = []

        movements.enumerated().map {
            Movement(id: $0.element.id,
                     orderNumber: $0.offset,
                     movementDefinition: $0.element.movementDefinition,
                     metrics: $0.element.metrics)
        }.forEach { movement in
            // update movement
            if let entityMovement = entityMovements?.first(where: { $0.id == movement.id }) {
                movement.updateMovementEntity(entityMovement)

                updatedEntityMovements.insert(entityMovement)
                entityMovements?.remove(entityMovement)
            }
            // create movement
            else {
                let entityMovement = movement.movementEntity(context: context)

                updatedEntityMovements.insert(entityMovement)
            }
        }
        // delete movement
        entityMovements?.forEach {
            context.delete($0)
        }
        entity.movements = updatedEntityMovements
    }
}
