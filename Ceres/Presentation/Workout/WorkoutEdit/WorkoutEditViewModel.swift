//
//  WorkoutEditViewModel.swift
//  Ceres
//
//  Created by Edmundas Matusevičius on 2022-03-28.
//

import Foundation
import SwiftUI

@MainActor
class WorkoutEditViewModel: ObservableObject {
    private var createWorkoutUseCase = CreateWorkoutUseCase(
        repo: WorkoutRepositoryImpl(
            dataSource: WorkoutCoreDataSourceImpl()))
    private var updateWorkoutUseCase = UpdateWorkoutUseCase(
        repo: WorkoutRepositoryImpl(
            dataSource: WorkoutCoreDataSourceImpl()))

    @Binding var workout: Workout?

    @Published var title = ""
    @Published var type = WorkoutType.none
    @Published var category = WorkoutCategory.none

    @Published var metrics: [Metric] = []
    @Published var rounds: [Round] = []

    @Published var errorMessage = ""
    @Published var hasError = false

    init(workout: Binding<Workout?>) {
        _workout = workout

        if let currentWorkout = workout.wrappedValue {
            title = currentWorkout.title
            type = currentWorkout.type
            category = currentWorkout.category
            metrics = currentWorkout.metrics
            rounds = currentWorkout.rounds
        }
    }

    private func createWorkout() async {
        errorMessage = ""
        let workout = Workout(
            id: UUID(),
            createDate: Date(),
            type: type,
            category: category,
            title: title,
            metrics: metrics,
            rounds: rounds
        )
        let result = await createWorkoutUseCase.execute(workout: workout)
        switch result {
        case .success:
            break
        case .failure(let error):
            errorMessage = error.localizedDescription
            hasError = true
        }
    }

    private func updateWorkout() async {
        guard let currentWorkout = workout else { return }

        errorMessage = ""
        let workout = Workout(
            id: currentWorkout.id,
            createDate: currentWorkout.createDate,
            type: type,
            category: category,
            title: title,
            metrics: metrics,
            rounds: rounds
        )
        let result = await updateWorkoutUseCase.execute(workout: workout)
        switch result {
        case .success:
            break
        case .failure(let error):
            errorMessage = error.localizedDescription
            hasError = true
        }
    }

    func updateMetric(_ metric: Metric) async {
        updateItem(metric, in: &metrics)
    }

    func deleteMetric(at index: Int) async {
        metrics.remove(at: index)
    }

    func updateRound(_ round: Round) async {
        updateItem(round, in: &rounds)
    }

    func deleteRound(at index: Int) async {
        rounds.remove(at: index)
    }

    func save() {
        if workout != nil {
            Task { await updateWorkout() }
        } else {
            Task { await createWorkout() }
        }
    }
}

extension WorkoutEditViewModel {
    private func updateItem<T: Identifiable>(_ item: T, in source: inout [T]) {
        if let index = source.firstIndex(where: { $0.id == item.id }) {
            source.remove(at: index)
            source.insert(item, at: index)
        } else {
            source.append(item)
        }
    }
}
