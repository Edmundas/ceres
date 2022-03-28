//
//  WorkoutEditViewModel.swift
//  Ceres
//
//  Created by Edmundas Matusevičius on 2022-03-28.
//

import Foundation
import SwiftUI

class WorkoutEditViewModel: ObservableObject {
    var createWorkoutUseCase = CreateWorkoutUseCase(repo: WorkoutRepositoryImpl(dataSource: WorkoutCoreDataSourceImpl()))
    var updateWorkoutUseCase = UpdateWorkoutUseCase(repo: WorkoutRepositoryImpl(dataSource: WorkoutCoreDataSourceImpl()))
    
    @Binding var workout: Workout?
    
    @Published var title = ""
    @Published var type = WorkoutType.none
    @Published var category = WorkoutCategory.none
    
//    @Published var metrics: [Metric] = []
    
    @Published var errorMessage = ""
    @Published var hasError = false
    
    init(workout: Binding<Workout?>) {
        _workout = workout
        
        if let currentWorkout = workout.wrappedValue {
            title = currentWorkout.title ?? ""
            type = currentWorkout.type
            category = currentWorkout.category
            
//            if let currentMetrics = currentWorkout.metrics {
//                metrics = Array(currentMetrics)
//            }
        }
    }
    
    func createWorkout() async {
        errorMessage = ""
        let workout = Workout(
            id: UUID(),
            type: type,
            category: category,
            title: title
        )
        let result = await createWorkoutUseCase.execute(workout: workout)
        switch result {
        case .success:
            break
        case .failure(let error):
            errorMessage = error.localizedDescription
            hasError = true
        }
    }
    
    func updateWorkout() async {
        guard let currentWorkout = workout else { return }

        errorMessage = ""
        let workout = Workout(
            id: currentWorkout.id,
            type: type,
            category: category,
            title: title
        )
        let result = await updateWorkoutUseCase.execute(workout: workout)
        switch result {
        case .success:
            break
        case .failure(let error):
            errorMessage = error.localizedDescription
            hasError = true
        }
    }
}
