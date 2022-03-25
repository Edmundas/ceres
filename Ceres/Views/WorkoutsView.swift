//
//  WorkoutsView.swift
//  Ceres
//
//  Created by Edmundas Matusevicius on 2021-11-24.
//

import SwiftUI
import CoreData

struct WorkoutsView: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    
    @FetchRequest(fetchRequest: DMWorkout.fetchRequest())
    private var workouts: FetchedResults<DMWorkout>
    
    @StateObject private var viewModel = WorkoutsViewModel()
    
    @State private var showingAddWorkoutSheet = false
    
    var body: some View {
        List {
            if workouts.isEmpty {
                Label("The list is empty", systemImage: "exclamationmark.circle")
            }
            ForEach(workouts) { workout in
                Text("\(workout.title ?? "") - \(workout.metrics?.first?.value ?? 0.0)")
            }
            .onDelete(perform: deleteWorkout)
        }
        .listStyle(InsetGroupedListStyle())
        .navigationTitle("Workouts")
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button(action: { showingAddWorkoutSheet.toggle() },
                       label: { Image(systemName: "plus") })
            }
        }
        .sheet(isPresented: $showingAddWorkoutSheet) {
            NavigationView {
                ModifyWorkoutView(viewModel: ModifyWorkoutViewModel())
            }
        }
    }
}

extension WorkoutsView {
    private func deleteWorkout(indexSet: IndexSet) {
        indexSet.forEach {
            viewModel.delete(workout: workouts[$0])
        }
    }
}

//struct WorkoutsView_Previews: PreviewProvider {
//    static var previews: some View {
//        WorkoutsView()
//            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
//    }
//}
