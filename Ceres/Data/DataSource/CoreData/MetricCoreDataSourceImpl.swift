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
        let workoutEntity = try context.fetch(request)[0]
        return workoutEntity
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
    init(metricEntity: MetricEntity) {
        id = metricEntity.id
        type = MetricType(rawValue: metricEntity.type) ?? .none
        subtype = MetricSubtype(rawValue: metricEntity.subtype) ?? .none
        unit = MetricUnit(rawValue: metricEntity.unit) ?? .none
        value = metricEntity.value
    }
    
    func metricEntity(context: NSManagedObjectContext) -> MetricEntity {
        let metricEntity = MetricEntity(context: context)
        metricEntity.id = self.id
        metricEntity.type = self.type.rawValue
        metricEntity.subtype = self.subtype.rawValue
        metricEntity.unit = self.unit.rawValue
        metricEntity.value = self.value
        
        return metricEntity
    }
}
