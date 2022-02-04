//
//  ModifyWorkoutView.swift
//  Ceres
//
//  Created by Edmundas Matusevicius on 2021-11-24.
//

import SwiftUI

struct ModifyWorkoutView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @StateObject private var viewModel = ModifyWorkoutViewModel()
    
    @State private var showingModifyMetricSheet = false
    
    var workout: DMWorkout?
    
    var body: some View {
        List {
            Section {
                TextField("Title", text: $viewModel.title)
                    .modifier(ClearButton(text: $viewModel.title))
            }
            Section {
                Picker("Type", selection: $viewModel.type) {
                    ForEach(DMWorkoutType.allCases, id: \.self) { type in
                        Text(type == .none ? String(describing: type) : String(describing: type).uppercased())
                    }
                }
                Picker("Category", selection: $viewModel.category) {
                    ForEach(DMWorkoutCategory.allCases, id: \.self) { category in
                        Text(category == .none ? String(describing: category) : String(describing: category).capitalized)
                    }
                }
            }
            Section {
                // TODO: metrics
                if let metrics = viewModel.metrics {
                    ForEach(metrics) { metric in
                        Text("_METRIC_")
                    }
                }
                Button(action: { showingModifyMetricSheet = true},
                       label: { Label("Add workout metric", systemImage: "plus.app") })
                    .buttonStyle(PlainButtonStyle())
            }
            Section {
                // TODO: rounds
            }
        }
        .listStyle(InsetGroupedListStyle())
        .navigationTitle("Workout")
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel") {
                    presentationMode.wrappedValue.dismiss()
                }
            }
            ToolbarItem(placement: .confirmationAction) {
                Button("Save") {
                    viewModel.save()
                    presentationMode.wrappedValue.dismiss()
                }
            }
        }
        .onAppear(perform: prepareViewModel)
        .sheet(isPresented: $showingModifyMetricSheet) {
            NavigationView {
                ModifyMetricView {
                    if viewModel.metrics == nil { viewModel.metrics = [] }
                    viewModel.metrics!.append($0)
                }
            }
        }
    }
}

extension ModifyWorkoutView {
    private func prepareViewModel() {
        if let currentWorkout = workout {
            viewModel.workout = currentWorkout
            viewModel.title = currentWorkout.title ?? ""
            viewModel.type = DMWorkoutType(rawValue: currentWorkout.type) ?? .none
            viewModel.category = DMWorkoutCategory(rawValue: currentWorkout.category) ?? .none
        }
    }
}

struct ModifyWorkoutView_Previews: PreviewProvider {
    static var previews: some View {
        ModifyWorkoutView()
            .preferredColorScheme(.dark)
    }
}
