//
//  ModifyWorkoutViewModel.swift
//  Ceres
//
//  Created by Edmundas Matusevicius on 2021-11-24.
//

import Foundation

final class ModifyWorkoutViewModel: ObservableObject {
    @Published var title = ""
    @Published var type = DMWorkoutType.none
    @Published var category = DMWorkoutCategory.none
    
    @Published var metrics: [DMMetric] = []
    
    private let dataManager: DataManagerProtocol
    
    init(dataManager: DataManagerProtocol = DataManager.shared) {
        self.dataManager = dataManager
    }
    
    func save() {
        // TODO: save workout
        let _ = dataManager.saveWorkout(title: title.isEmpty ? nil : title, type: type, category: category, metrics: metrics)
    }
    
    func delete(metric: DMMetric) {
        let index = metrics.firstIndex(of: metric)!
        metrics.remove(at: index)
    }
}
