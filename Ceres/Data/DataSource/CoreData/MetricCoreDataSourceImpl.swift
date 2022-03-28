//
//  MetricCoreDataSourceImpl.swift
//  Ceres
//
//  Created by Edmundas Matusevičius on 2022-03-28.
//

import Foundation
import CoreData

struct MetricCoreDataSourceImpl: MetricDataSource {
    let container: NSPersistentContainer
    
    init() {
        container = NSPersistentContainer(name: "Ceres")
        container.loadPersistentStores { description, error in
            if error != nil {
                fatalError("Cannot Load Core Data Model")
            }
        }
    }
    
    func getById(_ id: UUID) throws -> Metric? {
        let metricEntity = try getEntityById(id)!
        return Metric(
            id: metricEntity.id,
            type: MetricType(rawValue: metricEntity.type) ?? .none,
            subtype: MetricSubtype(rawValue: metricEntity.subtype) ?? .none,
            unit: MetricUnit(rawValue: metricEntity.unit) ?? .none,
            value: metricEntity.value
        )
    }
    
    func delete(_ id: UUID) throws -> () {
        let metricEntity = try getEntityById(id)!
        let context = container.viewContext;
        context.delete(metricEntity)
        do {
            try context.save()
        } catch {
            context.rollback()
            fatalError("Error: \(error.localizedDescription)")
        }
    }
    
    func update(id: UUID, metric: Metric) throws -> () {
        let metricEntity = try getEntityById(id)!
        metricEntity.value = metric.value
        metricEntity.unit = metric.unit.rawValue
        metricEntity.subtype = metric.subtype.rawValue
        metricEntity.type = metric.type.rawValue
        saveContext()
    }
    
    func create(metric: Metric) throws -> () {
        let metricEntity = DMMetric(context: container.viewContext)
        metricEntity.value = metric.value
        metricEntity.unit = metric.unit.rawValue
        metricEntity.subtype = metric.subtype.rawValue
        metricEntity.type = metric.type.rawValue
        metricEntity.id = metric.id
        saveContext()
    }
    
    private func getEntityById(_ id: UUID) throws -> DMMetric? {
        let request = DMMetric.fetchRequest()
        request.fetchLimit = 1
        request.predicate = NSPredicate(
            format: "id = %@", id.uuidString)
        let context =  container.viewContext
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
