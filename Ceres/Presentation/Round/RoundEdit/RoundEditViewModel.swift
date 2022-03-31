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

    @Published var errorMessage = ""
    @Published var hasError = false

    init(round: Binding<Round?>) {
        _round = round
    }

    private func createRound() async {
        round = Round(
            id: UUID(),
            createDate: Date(),
            orderNumber: 0
        )
    }

    private func updateRound() async {
        guard let currentRound = round else { return }

        round = Round(
            id: currentRound.id,
            createDate: currentRound.createDate,
            orderNumber: currentRound.orderNumber
        )
    }

    func save() {
        if round != nil {
            Task { await updateRound() }
        } else {
            Task { await createRound() }
        }
    }
}
