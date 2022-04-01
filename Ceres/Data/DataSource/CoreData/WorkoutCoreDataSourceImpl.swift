//
//  WorkoutCoreDataSourceImpl.swift
//  Ceres
//
//  Created by Edmundas Matusevičius on 2022-03-25.
//

import Foundation
import CoreData

struct WorkoutCoreDataSourceImpl: WorkoutDataSource {
    let persistenceController: PersistenceController
    let container: NSPersistentContainer

    init() {
        persistenceController = PersistenceController.shared
        container = persistenceController.container
    }

    func getAll() throws -> [Workout] {
        let request = WorkoutEntity.fetchRequest()
        let context = container.viewContext
        return try context.fetch(request).map {
            Workout($0)
        }
    }

    func getById(_ id: UUID) throws -> Workout? {
        let entity = try getEntityById(id)!
        return Workout(entity)
    }

    func delete(_ id: UUID) throws {
        let entity = try getEntityById(id)!
        let context = container.viewContext
        context.delete(entity)
        do {
            try context.save()
        } catch {
            context.rollback()
            fatalError("Error: \(error.localizedDescription)")
        }
    }

    func update(id: UUID, workout: Workout) throws {
        let entity = try getEntityById(id)!
        workout.updateWorkoutEntity(entity)
        saveContext()
    }

    func create(workout: Workout) throws {
        let context = container.viewContext
        _ = workout.workoutEntity(context: context)
        saveContext()
    }

    private func getEntityById(_ id: UUID) throws -> WorkoutEntity? {
        let request = WorkoutEntity.fetchRequest()
        request.fetchLimit = 1
        request.predicate = NSPredicate(format: "id = %@", id.uuidString)
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

extension Workout {
    init(_ entity: WorkoutEntity) {
        id = entity.id
        createDate = entity.createDate
        type = WorkoutType(rawValue: entity.type) ?? .none
        category = WorkoutCategory(rawValue: entity.category) ?? .none
        title = entity.title

        let entityMetrics = entity.metrics?.map {
            Metric($0)
        }.sorted {
            $0.createDate < $1.createDate
        }
        metrics = entityMetrics ?? []

        let entityRounds = entity.rounds?.map {
            Round($0)
        }.sorted {
            $0.orderNumber < $1.orderNumber
        }
        rounds = entityRounds ?? []
    }

    func workoutEntity(context: NSManagedObjectContext) -> WorkoutEntity {
        let entity = WorkoutEntity(context: context)
        entity.id = self.id
        entity.createDate = self.createDate
        entity.type = self.type.rawValue
        entity.category = self.category.rawValue
        entity.title = self.title

        let entityMetrics: [MetricEntity] = self.metrics.map {
            $0.metricEntity(context: context)
        }
        entity.metrics = !entityMetrics.isEmpty ? Set(entityMetrics) : nil

        let entityRounds: [RoundEntity] = self.rounds.enumerated().map {
            let entity = $0.element.roundEntity(context: context)
            entity.orderNumber = Int16($0.offset)
            return entity
        }
        entity.rounds = !entityRounds.isEmpty ? Set(entityRounds) : nil

        return entity
    }

    func updateWorkoutEntity(_ entity: WorkoutEntity) {
        entity.type = type.rawValue
        entity.category = category.rawValue
        entity.title = title

        updateMetrics(for: entity)
        updateRounds(for: entity)
    }

    private func updateMetrics(for entity: WorkoutEntity) {
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

    private func updateRounds(for entity: WorkoutEntity) {
        guard let context = entity.managedObjectContext else { return }

        var entityRounds = entity.rounds
        var updatedEntityRounds: Set<RoundEntity> = []

        rounds.enumerated().map {
            Round(id: $0.element.id,
                  orderNumber: $0.offset,
                  metrics: $0.element.metrics,
                  movements: $0.element.movements)
        }.forEach { round in
            // update round
            if let entityRound = entityRounds?.first(where: { $0.id == round.id }) {
                round.updateRoundEntity(entityRound)

                updatedEntityRounds.insert(entityRound)
                entityRounds?.remove(entityRound)
            }
            // create round
            else {
                let entityRound = round.roundEntity(context: context)

                updatedEntityRounds.insert(entityRound)
            }
        }
        // delete round
        entityRounds?.forEach {
            context.delete($0)
        }
        entity.rounds = updatedEntityRounds
    }
}
