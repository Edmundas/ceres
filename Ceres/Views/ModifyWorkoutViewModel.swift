//
//  ModifyWorkoutViewModel.swift
//  Ceres
//
//  Created by Edmundas Matusevicius on 2021-11-24.
//

import Foundation
import SwiftUI

final class ModifyWorkoutViewModel: ObservableObject {
    @Binding var workout: DMWorkout?
    
    @Published var title = ""
    @Published var type = DMWorkoutType.none
    @Published var category = DMWorkoutCategory.none
    
    @Published var metrics: [DMMetric] = []
    
    private let dataManager: DataManagerProtocol
    
    init(dataManager: DataManagerProtocol = DataManager.shared, workout: Binding<DMWorkout?>) {
        self.dataManager = dataManager
        _workout = workout
        
        if let currentWorkout = workout.wrappedValue {
            title = currentWorkout.title ?? ""
            type = DMWorkoutType(rawValue: currentWorkout.type) ?? .none
            category = DMWorkoutCategory(rawValue: currentWorkout.category) ?? .none
            
            if let currentMetrics = currentWorkout.metrics {
                metrics = Array(currentMetrics)
            }
        }
    }
    
    func save() {
        if let currentWorkout = workout {
            currentWorkout.title = title
            currentWorkout.type = type.rawValue
            currentWorkout.category = category.rawValue
            currentWorkout.metrics = metrics.count > 0 ? Set(metrics) : nil
            
            dataManager.updateWorkout(currentWorkout)
        } else {
            dataManager.createWorkout(title: title.isEmpty ? nil : title, type: type, category: category, metrics: metrics)
        }
    }
    
    func delete(metric: DMMetric) {
        let index = metrics.firstIndex(of: metric)!
        metrics.remove(at: index)
    }
}
