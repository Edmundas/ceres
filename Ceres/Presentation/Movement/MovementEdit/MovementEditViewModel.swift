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

    @Published var errorMessage = ""
    @Published var hasError = false

    init(movement: Binding<Movement?>) {
        _movement = movement
    }

    private func createMovement() async {
        movement = Movement(
            id: UUID(),
            orderNumber: 0
        )
    }

    private func updateMovement() async {
        guard let currentMovement = movement else { return }

        movement = Movement(
            id: currentMovement.id,
            orderNumber: currentMovement.orderNumber
        )
    }

    func save() {
        if movement != nil {
            Task { await updateMovement() }
        } else {
            Task { await createMovement() }
        }
    }
}
