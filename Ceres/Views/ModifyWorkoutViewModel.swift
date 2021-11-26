//
//  ModifyWorkoutViewModel.swift
//  Ceres
//
//  Created by Edmundas Matusevicius on 2021-11-24.
//

import Foundation

final class ModifyWorkoutViewModel: ObservableObject {
    @Published var workout: DMWorkout?
    @Published var title = ""
    @Published var type = DMWorkoutType.none
    @Published var category = DMWorkoutCategory.none
    
    private let dataManager: DataManagerProtocol
    
    init(dataManager: DataManagerProtocol = DataManager.shared) {
        self.dataManager = dataManager
    }
    
    func save() {
        // TODO: save workout
        if let _ = workout {
            // TODO: update workout
        } else {
            let _ = dataManager.createWorkout(title: title.isEmpty ? nil : title, type: type, category: category)
        }
    }
}
