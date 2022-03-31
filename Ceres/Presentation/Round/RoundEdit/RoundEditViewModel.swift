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

    @Published var movements: [Movement] = []

    @Published var errorMessage = ""
    @Published var hasError = false

    init(round: Binding<Round?>) {
        _round = round

        if let currentRound = round.wrappedValue {
            movements = currentRound.movements
        }
    }

    private func createRound() async {
        round = Round(
            id: UUID(),
            orderNumber: 0,
            movements: movements
        )
    }

    private func updateRound() async {
        guard let currentRound = round else { return }

        round = Round(
            id: currentRound.id,
            orderNumber: currentRound.orderNumber,
            movements: movements
        )
    }

    func updateMovement(_ movement: Movement) async {
        if let index = movements.firstIndex(where: { $0.id == movement.id }) {
            movements.remove(at: index)
            movements.insert(movement, at: index)
        } else {
            movements.append(movement)
        }
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
