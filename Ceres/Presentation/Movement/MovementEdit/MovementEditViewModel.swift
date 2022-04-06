//
//  MovementEditViewModel.swift
//  Ceres
//
//  Created by Edmundas Matusevičius on 2022-03-31.
//

import Foundation
import SwiftUI

@MainActor
class MovementEditViewModel: ObservableObject {
    @Binding var movement: Movement?

    @Published var movementDefinition: MovementDefinition?
    @Published var metrics: [Metric] = []

    @Published var errorMessage = ""
    @Published var hasError = false

    init(movement: Binding<Movement?>) {
        _movement = movement

        if let currentMovement = movement.wrappedValue {
            movementDefinition = currentMovement.movementDefinition
            metrics = currentMovement.metrics
        }
    }

    private func createMovement() async {
        movement = Movement(
            id: UUID(),
            orderNumber: 0,
            movementDefinition: movementDefinition,
            metrics: metrics
        )
    }

    private func updateMovement() async {
        guard let currentMovement = movement else { return }

        movement = Movement(
            id: currentMovement.id,
            orderNumber: currentMovement.orderNumber,
            movementDefinition: movementDefinition,
            metrics: metrics
        )
    }

    func updateMetric(_ metric: Metric) async {
        if let index = metrics.firstIndex(where: { $0.id == metric.id }) {
            metrics.remove(at: index)
            metrics.insert(metric, at: index)
        } else {
            metrics.append(metric)
        }
    }

    func deleteMetric(at index: Int) async {
        metrics.remove(at: index)
    }

    func save() {
        if movement != nil {
            Task { await updateMovement() }
        } else {
            Task { await createMovement() }
        }
    }
}
