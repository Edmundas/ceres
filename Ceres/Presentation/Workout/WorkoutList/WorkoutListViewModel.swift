//
//  WorkoutListViewModel.swift
//  Ceres
//
//  Created by Edmundas Matusevičius on 2022-03-25.
//

import Foundation

class WorkoutListViewModel: ObservableObject {
    
    var getWorkoutsUseCase = GetWorkoutsUseCase(repo: WorkoutRepositoryImpl(dataSource: WorkoutCoreDataSourceImpl()))
    var deleteWorkoutUseCase = DeleteWorkoutUseCase(repo: WorkoutRepositoryImpl(dataSource: WorkoutCoreDataSourceImpl()))
    
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
    
    func deleteWorkout(at index: Int) async {
        errorMessage = ""
        let workout = workouts[index]
        let result = await deleteWorkoutUseCase.execute(id: workout.id)
        switch result {
        case .success:
            await getWorkouts()
        case .failure(let error):
            errorMessage = error.localizedDescription
            hasError = true
        }
    }
    
}
