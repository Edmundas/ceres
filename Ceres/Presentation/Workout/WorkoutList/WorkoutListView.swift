//
//  WorkoutListView.swift
//  Ceres
//
//  Created by Edmundas Matusevičius on 2022-03-25.
//

import SwiftUI

struct WorkoutListView: View {
    
    @StateObject var vm = WorkoutListViewModel()
    
    fileprivate func listRow(_ workout: Workout) -> some View {
        Text(workout.title ?? "")
    }
    
    fileprivate func WorkoutList() -> some View {
        List {
            ForEach(vm.workouts) { item in
                listRow(item)
            }
        }
        .navigationTitle("Workout List")
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
