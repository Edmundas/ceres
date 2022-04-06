//
//  WorkoutListView.swift
//  Ceres
//
//  Created by Edmundas Matusevičius on 2022-03-25.
//

import SwiftUI

struct WorkoutListView: View {
    @StateObject var viewModel: WorkoutListViewModel

    class WorkoutSheetMananger: ObservableObject {
        @Published var showSheet = false
        @Published var workout: Workout?
    }
    @StateObject private var workoutSheetManager = WorkoutSheetMananger()

    private func emptyListRow() -> some View {
        Label("The list is empty", systemImage: "exclamationmark.circle")
    }

    private func listRow(_ workout: Workout) -> some View {
        Button(action: {
            workoutSheetManager.workout = workout
            workoutSheetManager.showSheet.toggle()
        }, label: {
            Text("\(workout.title) - \(workout.type.description)")
        })
        .buttonStyle(DefaultButtonStyle())
        .foregroundColor(.primary)
    }

    private func workoutList() -> some View {
        List {
            if viewModel.workouts.isEmpty {
                emptyListRow()
            }
            ForEach(viewModel.workouts) { item in
                listRow(item)
            }
            .onDelete(perform: deleteWorkout)
        }
        .listStyle(InsetGroupedListStyle())
        .navigationTitle("Workouts")
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button(action: { workoutSheetManager.showSheet.toggle() },
                       label: { Image(systemName: "plus") })
            }
        }
        .sheet(isPresented: $workoutSheetManager.showSheet, onDismiss: {
            updateWorkouts()
        }, content: {
            NavigationView {
                WorkoutEditView(viewModel: WorkoutEditViewModel(workout: $workoutSheetManager.workout))
            }
        })
        .task {
           await viewModel.getWorkouts()
        }
        .alert("Error", isPresented: $viewModel.hasError, actions: { }, message: {
            Text(viewModel.errorMessage)
        })
    }

    var body: some View {
       workoutList()
    }
}

extension WorkoutListView {
    private func updateWorkouts() {
        Task {
            await viewModel.getWorkouts()
            workoutSheetManager.workout = nil
        }
    }

    private func deleteWorkout(indexSet: IndexSet) {
        indexSet.forEach { index in
            Task {
                await viewModel.deleteWorkout(at: index)
            }
        }
    }
}

/*
struct WorkoutListView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            WorkoutListView()
        }.navigationViewStyle(StackNavigationViewStyle())
    }
}
 */
