//
//  WorkoutsViewModel.swift
//  Ceres
//
//  Created by Edmundas Matusevicius on 2021-11-24.
//

import Foundation

final class WorkoutsViewModel: ObservableObject {
    private let dataManager: DataManagerProtocol
    
    init(dataManager: DataManagerProtocol = DataManager.shared) {
        self.dataManager = dataManager
    }
}
