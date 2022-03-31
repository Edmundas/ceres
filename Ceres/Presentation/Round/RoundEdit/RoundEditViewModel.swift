//
//  RoundEditViewModel.swift
//  Ceres
//
//  Created by Edmundas Matusevičius on 2022-03-31.
//

import Foundation
import SwiftUI

@MainActor
class RoundEditViewModel: ObservableObject {
    @Binding var round: Round?

    @Published var metrics: [Metric] = []
    @Published var movements: [Movement] = []

    @Published var errorMessage = ""
    @Published var hasError = false

    init(round: Binding<Round?>) {
        _round = round

        if let currentRound = round.wrappedValue {
            metrics = currentRound.metrics
            movements = currentRound.movements
        }
    }

    private func createRound() async {
        round = Round(
            id: UUID(),
            orderNumber: 0,
            metrics: metrics,
            movements: movements
        )
    }

    private func updateRound() async {
        guard let currentRound = round else { return }

        round = Round(
            id: currentRound.id,
            orderNumber: currentRound.orderNumber,
            metrics: metrics,
            movements: movements
        )
    }

    func updateMetric(_ metric: Metric) async {
        updateItem(metric, in: &metrics)
    }

    func deleteMetric(at index: Int) async {
        metrics.remove(at: index)
    }

    func updateMovement(_ movement: Movement) async {
        updateItem(movement, in: &movements)
    }

    func deleteMovement(at index: Int) async {
        movements.remove(at: index)
    }

    func save() {
        if round != nil {
            Task { await updateRound() }
        } else {
            Task { await createRound() }
        }
    }
}

extension RoundEditViewModel {
    private func updateItem<T: Identifiable>(_ item: T, in source: inout [T]) {
        if let index = source.firstIndex(where: { $0.id == item.id }) {
            source.remove(at: index)
            source.insert(item, at: index)
        } else {
            source.append(item)
        }
    }
}
