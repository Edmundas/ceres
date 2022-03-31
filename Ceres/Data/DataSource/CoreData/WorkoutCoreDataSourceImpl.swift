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
            Workout(workoutEntity: $0)
        }
    }

    func getById(_ id: UUID) throws -> Workout? {
        let workoutEntity = try getEntityById(id)!

        return Workout(workoutEntity: workoutEntity)
    }

    func delete(_ id: UUID) throws {
        let workoutEntity = try getEntityById(id)!
        let context = container.viewContext

        context.delete(workoutEntity)

        do {
            try context.save()
        } catch {
            context.rollback()
            fatalError("Error: \(error.localizedDescription)")
        }
    }

    func update(id: UUID, workout: Workout) throws {
        let workoutEntity = try getEntityById(id)!
        let context = container.viewContext

        workoutEntity.type = workout.type.rawValue
        workoutEntity.category = workout.category.rawValue
        workoutEntity.title = workout.title

        var workoutEntityMetrics = workoutEntity.metrics
        var updatedWorkoutEntityMetrics: Set<MetricEntity> = []

        for metric in workout.metrics {
            // update metric
            if let workoutEntityMetric = workoutEntityMetrics?.first(where: { $0.id == metric.id }) {
                workoutEntityMetric.type = metric.type.rawValue
                workoutEntityMetric.subtype = metric.subtype.rawValue
                workoutEntityMetric.unit = metric.unit.rawValue
                workoutEntityMetric.value = metric.value

                updatedWorkoutEntityMetrics.insert(workoutEntityMetric)
                workoutEntityMetrics?.remove(workoutEntityMetric)
            }
            // create metric
            else {
                let workoutEntityMetric = metric.metricEntity(context: context)

                updatedWorkoutEntityMetrics.insert(workoutEntityMetric)
            }
        }
        // delete metric
        workoutEntityMetrics?.forEach {
            context.delete($0)
        }
        workoutEntity.metrics = updatedWorkoutEntityMetrics

        var workoutEntityRounds = workoutEntity.rounds
        var updatedWorkoutEntityRounds: Set<RoundEntity> = []

        for (index, round) in workout.rounds.enumerated() {
            // update round
            if let workoutEntityRound = workoutEntityRounds?.first(where: { $0.id == round.id }) {
                workoutEntityRound.orderNumber = Int16(index)

                updatedWorkoutEntityRounds.insert(workoutEntityRound)
                workoutEntityRounds?.remove(workoutEntityRound)
            }
            // create round
            else {
                let workoutEntityRound = round.roundEntity(context: context)
                workoutEntityRound.orderNumber = Int16(index)

                updatedWorkoutEntityRounds.insert(workoutEntityRound)
            }
        }
        // delete round
        workoutEntityRounds?.forEach {
            context.delete($0)
        }
        workoutEntity.rounds = updatedWorkoutEntityRounds

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

extension Workout {
    init(workoutEntity: WorkoutEntity) {
        id = workoutEntity.id
        createDate = workoutEntity.createDate
        type = WorkoutType(rawValue: workoutEntity.type) ?? .none
        category = WorkoutCategory(rawValue: workoutEntity.category) ?? .none
        title = workoutEntity.title

        let workoutEntityMetrics = workoutEntity.metrics?.map {
            Metric(metricEntity: $0)
        }.sorted {
            $0.createDate < $1.createDate
        }
        metrics = workoutEntityMetrics ?? []

        let workoutEntityRounds = workoutEntity.rounds?.map {
            Round(roundEntity: $0)
        }.sorted {
            $0.orderNumber < $1.orderNumber
        }
        rounds = workoutEntityRounds ?? []
    }

    func workoutEntity(context: NSManagedObjectContext) -> WorkoutEntity {
        let workoutEntity = WorkoutEntity(context: context)
        workoutEntity.id = self.id
        workoutEntity.createDate = self.createDate
        workoutEntity.type = self.type.rawValue
        workoutEntity.category = self.category.rawValue
        workoutEntity.title = self.title

        let workoutEntityMetrics: [MetricEntity] = self.metrics.map {
            $0.metricEntity(context: context)
        }
        workoutEntity.metrics = !workoutEntityMetrics.isEmpty ? Set(workoutEntityMetrics) : nil

        let workoutEntityRounds: [RoundEntity] = self.rounds.enumerated().map {
            let entity = $0.element.roundEntity(context: context)
            entity.orderNumber = Int16($0.offset)
            return entity
        }
        workoutEntity.rounds = !workoutEntityRounds.isEmpty ? Set(workoutEntityRounds) : nil

        return workoutEntity
    }
}
