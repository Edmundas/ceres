//
//  WorkoutListView.swift
//  Ceres
//
//  Created by Edmundas Matusevičius on 2022-03-25.
//

import SwiftUI

struct WorkoutListView: View {
    @StateObject var vm: WorkoutListViewModel
    
    class SheetMananger: ObservableObject {
        @Published var showSheet = false
        @Published var workout: Workout? = nil
    }
    @StateObject var sheetManager = SheetMananger()
    
    fileprivate func EmptyListRow() -> some View {
        Label("The list is empty", systemImage: "exclamationmark.circle")
    }
    
    fileprivate func ListRow(_ workout: Workout) -> some View {
        Button(action: {
            sheetManager.workout = workout
            sheetManager.showSheet.toggle()
        }) {
            Text("\(workout.title) - \(String(describing: workout.type)) - \(String(describing: workout.category))")
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
                Button(action: { sheetManager.showSheet.toggle() },
                       label: { Image(systemName: "plus") })
            }
        }
        .sheet(isPresented: $sheetManager.showSheet, onDismiss: {
            updateWorkouts()
        }) {
            NavigationView {
                WorkoutEditView(vm: WorkoutEditViewModel(workout: $sheetManager.workout))
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
    private func updateWorkouts() {
        Task {
            await vm.getWorkouts()
            sheetManager.workout = nil
        }
    }
    
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
