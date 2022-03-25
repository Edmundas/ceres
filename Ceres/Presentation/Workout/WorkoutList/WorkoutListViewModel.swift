//
//  WorkoutListViewModel.swift
//  Ceres
//
//  Created by Edmundas Matusevičius on 2022-03-25.
//

import Foundation

class WorkoutListViewModel: ObservableObject {
    
    var getWorkoutsUseCase = GetWorkoutsUseCase(repo: WorkoutRepositoryImpl(dataSource: WorkoutCoreDataSourceImpl()))
    @Published var workouts: [Workout] = []
    @Published var errorMessage = ""
    @Published var hasError = false
    
    func getWorkouts() async {
        errorMessage = ""
        let result = await getWorkoutsUseCase.execute()
        switch result {
        case .success(let workouts):
            self.workouts = workouts
        case .failure(let error):
            self.workouts = []
            errorMessage = error.localizedDescription
            hasError = true
        }
    }
    
}
