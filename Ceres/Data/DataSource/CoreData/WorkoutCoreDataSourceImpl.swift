//
//  WorkoutCoreDataSourceImpl.swift
//  Ceres
//
//  Created by Edmundas Matusevičius on 2022-03-25.
//

import Foundation
import CoreData

struct WorkoutCoreDataSourceImpl: WorkoutDataSource {
    let container: NSPersistentContainer
    
    init() {
        container = NSPersistentContainer(name: "Ceres")
        container.loadPersistentStores { description, error in
            if error != nil {
                fatalError("Cannot Load Core Data Model")
            }
        }
    }
    
    func getAll() throws -> [Workout] {
        let request = DMWorkout.fetchRequest()
        return try container.viewContext.fetch(request).map({ workoutEntity in
            let workoutEntityMetrics = workoutEntity.metrics?.map {
                Metric(
                    id: $0.id,
                    type: MetricType(rawValue: $0.type) ?? .none,
                    subtype: MetricSubtype(rawValue: $0.subtype) ?? .none,
                    unit: MetricUnit(rawValue: $0.unit) ?? .none,
                    value: $0.value
                )
            }
            return Workout(
                id: workoutEntity.id,
                type: WorkoutType(rawValue: workoutEntity.type) ?? .none,
                category: WorkoutCategory(rawValue: workoutEntity.category) ?? .none,
                title: workoutEntity.title ?? "",
                metrics: workoutEntityMetrics ?? []
            )
        })
    }
    
    func getById(_ id: UUID) throws -> Workout? {
        let workoutEntity = try getEntityById(id)!
        let workoutEntityMetrics = workoutEntity.metrics?.map {
            Metric(
                id: $0.id,
                type: MetricType(rawValue: $0.type) ?? .none,
                subtype: MetricSubtype(rawValue: $0.subtype) ?? .none,
                unit: MetricUnit(rawValue: $0.unit) ?? .none,
                value: $0.value
            )
        }
        return Workout(
            id: workoutEntity.id,
            type: WorkoutType(rawValue: workoutEntity.type) ?? .none,
            category: WorkoutCategory(rawValue: workoutEntity.category) ?? .none,
            title: workoutEntity.title ?? "",
            metrics: workoutEntityMetrics ?? []
        )
    }
    
    func delete(_ id: UUID) throws -> () {
        let workoutEntity = try getEntityById(id)!
        let context = container.viewContext;
        context.delete(workoutEntity)
        do {
            try context.save()
        } catch {
            context.rollback()
            fatalError("Error: \(error.localizedDescription)")
        }
    }
    
    func update(id: UUID, workout: Workout) throws -> () {
        let workoutEntity = try getEntityById(id)!

        var workoutEntityMetrics = workoutEntity.metrics
        var updatedWorkoutEntityMetrics: Set<DMMetric> = []
        
        for metric in workout.metrics {
            if let workoutEntityMetric = workoutEntityMetrics?.first(where: { $0.id == metric.id }) {
                workoutEntityMetric.type = metric.type.rawValue
                workoutEntityMetric.subtype = metric.subtype.rawValue
                workoutEntityMetric.unit = metric.unit.rawValue
                workoutEntityMetric.value = metric.value
                
                updatedWorkoutEntityMetrics.insert(workoutEntityMetric)
                workoutEntityMetrics?.remove(workoutEntityMetric)
            } else {
                let workoutEntityMetric = DMMetric(context: container.viewContext)
                workoutEntityMetric.id = metric.id
                workoutEntityMetric.type = metric.type.rawValue
                workoutEntityMetric.subtype = metric.subtype.rawValue
                workoutEntityMetric.unit = metric.unit.rawValue
                workoutEntityMetric.value = metric.value
                workoutEntityMetric.workout = workoutEntity
                
                updatedWorkoutEntityMetrics.insert(workoutEntityMetric)
            }
        }
        
        workoutEntityMetrics?.forEach({
            container.viewContext.delete($0)
        })
        
        workoutEntity.metrics = updatedWorkoutEntityMetrics

        workoutEntity.title = workout.title
        workoutEntity.category = workout.category.rawValue
        workoutEntity.type = workout.type.rawValue
        saveContext()
    }
    
    func create(workout: Workout) throws -> () {
        let workoutEntity = DMWorkout(context: container.viewContext)
        let workoutEntityMetrics: [DMMetric] = workout.metrics.map {
            let metricEntity = DMMetric(context: container.viewContext)
            metricEntity.id = $0.id
            metricEntity.type = $0.type.rawValue
            metricEntity.subtype = $0.subtype.rawValue
            metricEntity.unit = $0.unit.rawValue
            metricEntity.value = $0.value
            return metricEntity
        }
        workoutEntity.metrics = !workoutEntityMetrics.isEmpty ? Set(workoutEntityMetrics) : nil
        workoutEntity.title = workout.title
        workoutEntity.category = workout.category.rawValue
        workoutEntity.type = workout.type.rawValue
        workoutEntity.id = workout.id
        saveContext()
    }
    
    private func getEntityById(_ id: UUID) throws -> DMWorkout? {
        let request = DMWorkout.fetchRequest()
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
