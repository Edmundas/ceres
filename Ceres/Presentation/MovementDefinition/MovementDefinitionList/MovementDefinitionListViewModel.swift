//
//  MovementDefinitionListViewModel.swift
//  Ceres
//
//  Created by Edmundas Matusevičius on 2022-04-01.
//

import Foundation

@MainActor
class MovementDefinitionListViewModel: ObservableObject {
    var getMovementDefinitionsUseCase = GetMovementDefinitionsUseCase(
        repo: MovementDefinitionRepositoryImpl(
            dataSource: MovementDefinitionCoreDataSourceImpl()
        )
    )

    @Published var movementDefinitions: [MovementDefinition] = []
    @Published var errorMessage = ""
    @Published var hasError = false

    func getMovementDefinitions() async {
        errorMessage = ""
        let result = await getMovementDefinitionsUseCase.execute()
        switch result {
        case .success(let movementDefinitions):
            self.movementDefinitions = movementDefinitions.sorted {
                $0.title < $1.title
            }
        case .failure(let error):
            self.movementDefinitions = []
            errorMessage = error.localizedDescription
            hasError = true
        }
    }
}
