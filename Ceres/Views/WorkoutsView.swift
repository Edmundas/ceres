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
    
    var body: some View {
        List {
            if workouts.isEmpty {
                Label("The list is empty", systemImage: "exclamationmark.circle")
            }
        }
        .listStyle(InsetGroupedListStyle())
        .navigationTitle("Workouts")
    }
}
struct WorkoutsView_Previews: PreviewProvider {
    static var previews: some View {
        WorkoutsView()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
