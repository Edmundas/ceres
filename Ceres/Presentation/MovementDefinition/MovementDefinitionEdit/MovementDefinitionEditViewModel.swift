//
//  MovementDefinitionEditViewModel.swift
//  Ceres
//
//  Created by Edmundas Matusevičius on 2022-04-01.
//

import Foundation
import SwiftUI

@MainActor
class MovementDefinitionEditViewModel: ObservableObject {
    private var createMovementDefinitionUseCase = CreateMovementDefinitionUseCase(
        repo: MovementDefinitionRepositoryImpl(
            dataSource: MovementDefinitionCoreDataSourceImpl()))
    private var updateMovementDefinitionUseCase = UpdateMovementDefinitionUseCase(
        repo: MovementDefinitionRepositoryImpl(
            dataSource: MovementDefinitionCoreDataSourceImpl()))

    @Binding var movementDefinition: MovementDefinition?

    @Published var title = ""

    @Published var errorMessage = ""
    @Published var hasError = false

    init(movementDefinition: Binding<MovementDefinition?>) {
        _movementDefinition = movementDefinition

        if let currentMovementDefinition = movementDefinition.wrappedValue {
            title = currentMovementDefinition.title
        }
    }

    private func createMovementDefinition() async {
        errorMessage = ""
        let movementDefinition = MovementDefinition(
            id: UUID(),
            title: title
        )
        let result = await createMovementDefinitionUseCase.execute(movementDefinition: movementDefinition)
        switch result {
        case .success:
            break
        case .failure(let error):
            errorMessage = error.localizedDescription
            hasError = true
        }
    }

    private func updateMovementDefinition() async {
        guard let currentMovementDefinition = movementDefinition else { return }

        errorMessage = ""
        let movementDefinition = MovementDefinition(
            id: currentMovementDefinition.id,
            title: currentMovementDefinition.title
        )
        let result = await updateMovementDefinitionUseCase.execute(movementDefinition: movementDefinition)
        switch result {
        case .success:
            break
        case .failure(let error):
            errorMessage = error.localizedDescription
            hasError = true
        }
    }

    func save() {
        if movementDefinition != nil {
            Task { await updateMovementDefinition() }
        } else {
            Task { await createMovementDefinition() }
        }
    }
}
