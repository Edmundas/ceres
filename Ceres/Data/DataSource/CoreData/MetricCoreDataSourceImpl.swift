//
//  MetricCoreDataSourceImpl.swift
//  Ceres
//
//  Created by Edmundas Matusevičius on 2022-03-28.
//

import Foundation
import CoreData

struct MetricCoreDataSourceImpl: MetricDataSource {
    let persistenceController: PersistenceController
    let container: NSPersistentContainer

    init() {
        persistenceController = PersistenceController.shared
        container = persistenceController.container
    }

    private func getEntityById(_ id: UUID) throws -> MetricEntity? {
        let request = MetricEntity.fetchRequest()
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

extension Metric {
    init(_ entity: MetricEntity) {
        id = entity.id
        createDate = entity.createDate
        type = MetricType(rawValue: entity.type) ?? .none
        subtype = MetricSubtype(rawValue: entity.subtype) ?? .none
        unit = MetricUnit(rawValue: entity.unit) ?? .none
        value = entity.value
    }

    func metricEntity(context: NSManagedObjectContext) -> MetricEntity {
        let entity = MetricEntity(context: context)
        entity.id = self.id
        entity.createDate = self.createDate
        entity.type = self.type.rawValue
        entity.subtype = self.subtype.rawValue
        entity.unit = self.unit.rawValue
        entity.value = self.value

        return entity
    }

    func updateMetricEntity(_ entity: MetricEntity) {
        entity.type = type.rawValue
        entity.subtype = subtype.rawValue
        entity.unit = unit.rawValue
        entity.value = value
    }
}
