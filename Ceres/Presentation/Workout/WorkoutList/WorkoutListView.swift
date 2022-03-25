//
//  WorkoutListView.swift
//  Ceres
//
//  Created by Edmundas Matusevičius on 2022-03-25.
//

import SwiftUI

struct WorkoutListView: View {
    
    @StateObject var vm = WorkoutListViewModel()
    
    fileprivate func emptyListRow() -> some View {
        Label("The list is empty", systemImage: "exclamationmark.circle")
    }
    
    fileprivate func listRow(_ workout: Workout) -> some View {
        Text(workout.title ?? "")
    }
    
    fileprivate func WorkoutList() -> some View {
        List {
            if vm.workouts.isEmpty {
                emptyListRow()
            }
            ForEach(vm.workouts) { item in
                listRow(item)
            }
            .onDelete { indexSet in
                indexSet.forEach { index in
                    Task {
                        await vm.deleteWorkout(at: index)
                    }
                }
            }
        }
        .navigationTitle("Workouts")
        .task {
           await vm.getWorkouts()
        }
        .alert("Error", isPresented: $vm.hasError) {
        } message: {
            Text(vm.errorMessage)
        }
    }
    
    var body: some View {
       WorkoutList()
    }
}

//struct WorkoutListView_Previews: PreviewProvider {
//    static var previews: some View {
//        NavigationView {
//            WorkoutListView()
//        }.navigationViewStyle(StackNavigationViewStyle())
//    }
//}
