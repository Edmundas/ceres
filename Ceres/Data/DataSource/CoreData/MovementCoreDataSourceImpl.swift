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

        let movementEntityMetrics = movementEntity.metrics?.map {
            Metric(metricEntity: $0)
        }.sorted {
            $0.createDate < $1.createDate
        }
        metrics = movementEntityMetrics ?? []
    }

    func movementEntity(context: NSManagedObjectContext) -> MovementEntity {
        let movementEntity = MovementEntity(context: context)
        movementEntity.id = self.id
        movementEntity.orderNumber = Int16(self.orderNumber)

        let movementEntityMetrics: [MetricEntity] = self.metrics.map {
            $0.metricEntity(context: context)
        }
        movementEntity.metrics = !movementEntityMetrics.isEmpty ? Set(movementEntityMetrics) : nil

        return movementEntity
    }

    func updateMovementEntity(_ movementEntity: MovementEntity) {
        updateMetrics(for: movementEntity)
    }

    private func updateMetrics(for movementEntity: MovementEntity) {
        guard let context = movementEntity.managedObjectContext else { return }

        var movementEntityMetrics = movementEntity.metrics
        var updatedMovementEntityMetrics: Set<MetricEntity> = []

        metrics.forEach { metric in
            // update metric
            if let movementEntityMetric = movementEntityMetrics?.first(where: { $0.id == metric.id }) {
                metric.updateMetricEntity(movementEntityMetric)

                updatedMovementEntityMetrics.insert(movementEntityMetric)
                movementEntityMetrics?.remove(movementEntityMetric)
            }
            // create metric
            else {
                let movementEntityMetric = metric.metricEntity(context: context)

                updatedMovementEntityMetrics.insert(movementEntityMetric)
            }
        }
        // delete metric
        movementEntityMetrics?.forEach {
            context.delete($0)
        }
        movementEntity.metrics = updatedMovementEntityMetrics
    }
}
