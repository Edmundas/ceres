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

extension Movement {
    init(_ entity: MovementEntity) {
        id = entity.id
        orderNumber = Int(entity.orderNumber)

        if let movementDefinitionEntity = entity.movementDefinition {
            movementDefinition = MovementDefinition(movementDefinitionEntity)
        } else {
            movementDefinition = nil
        }

        let entityMetrics = entity.metrics?.map {
            Metric($0)
        }.sorted {
            $0.createDate < $1.createDate
        }
        metrics = entityMetrics ?? []
    }

    func movementEntity(context: NSManagedObjectContext) -> MovementEntity {
        let entity = MovementEntity(context: context)
        entity.id = self.id
        entity.orderNumber = Int16(self.orderNumber)

        if let movementDefinition = self.movementDefinition {
            let movementDefinitionDataSource = MovementDefinitionCoreDataSourceImpl()
            do {
                entity.movementDefinition = try movementDefinitionDataSource.getEntityById(movementDefinition.id)
            } catch {
                entity.movementDefinition = nil
            }
        } else {
            entity.movementDefinition = nil
        }

        let entityMetrics: [MetricEntity] = self.metrics.map {
            $0.metricEntity(context: context)
        }
        entity.metrics = !entityMetrics.isEmpty ? Set(entityMetrics) : nil

        return entity
    }

    func updateMovementEntity(_ entity: MovementEntity) {
        updateMovementDefinition(for: entity)
        updateMetrics(for: entity)
    }

    private func updateMovementDefinition(for entity: MovementEntity) {
        if let movementDefinition = self.movementDefinition {
            let movementDefinitionDataSource = MovementDefinitionCoreDataSourceImpl()
            do {
                entity.movementDefinition = try movementDefinitionDataSource.getEntityById(movementDefinition.id)
            } catch {
                entity.movementDefinition = nil
            }
        } else {
            entity.movementDefinition = nil
        }
    }

    private func updateMetrics(for entity: MovementEntity) {
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
}
