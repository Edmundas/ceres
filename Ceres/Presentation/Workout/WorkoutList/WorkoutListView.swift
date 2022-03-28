//
//  WorkoutListView.swift
//  Ceres
//
//  Created by Edmundas Matusevičius on 2022-03-25.
//

import SwiftUI

struct WorkoutListView: View {
    @StateObject var vm: WorkoutListViewModel
    
    @State private var showingEditWorkoutSheet = false
    @State private var workout: Workout?
    
    fileprivate func EmptyListRow() -> some View {
        Label("The list is empty", systemImage: "exclamationmark.circle")
    }
    
    fileprivate func ListRow(_ workout: Workout) -> some View {
        Button(action: {
            self.workout = workout
            showingEditWorkoutSheet.toggle()
        }) {
            Text("\(workout.title ?? "") - \(String(describing: workout.type)) - \(String(describing: workout.category))")
        }
        .buttonStyle(DefaultButtonStyle())
        .foregroundColor(.primary)
    }
    
    fileprivate func WorkoutList() -> some View {
        List {
            if vm.workouts.isEmpty {
                EmptyListRow()
            }
            ForEach(vm.workouts) { item in
                ListRow(item)
            }
            .onDelete(perform: deleteWorkout)
        }
        .listStyle(InsetGroupedListStyle())
        .navigationTitle("Workouts")
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button(action: { showingEditWorkoutSheet.toggle() },
                       label: { Image(systemName: "plus") })
            }
        }
        .sheet(isPresented: $showingEditWorkoutSheet, onDismiss: {
            self.workout = nil
            Task {
                await vm.getWorkouts()
            }
        }) {
            NavigationView {
                WorkoutEditView(vm: WorkoutEditViewModel(workout: $workout))
            }
        }
        .task {
           await vm.getWorkouts()
        }
        .alert("Error", isPresented: $vm.hasError, actions: { }) {
            Text(vm.errorMessage)
        }
    }
    
    var body: some View {
       WorkoutList()
    }
}

extension WorkoutListView {
    private func deleteWorkout(indexSet: IndexSet) {
        indexSet.forEach { index in
            Task {
                await vm.deleteWorkout(at: index)
            }
        }
    }
}

//struct WorkoutListView_Previews: PreviewProvider {
//    static var previews: some View {
//        NavigationView {
//            WorkoutListView()
//        }.navigationViewStyle(StackNavigationViewStyle())
//    }
//}
