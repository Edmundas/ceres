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
    
    var workout: DMWorkout?
    
    var body: some View {
        List {
            TextField("Title", text: $viewModel.title)
                .modifier(ClearButton(text: $viewModel.title))
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
    }
}

extension ModifyWorkoutView {
    private func prepareViewModel() {
        if let currentWorkout = workout {
            viewModel.workout = currentWorkout
            viewModel.title = currentWorkout.title ?? ""
        }
    }
}

struct ModifyWorkoutView_Previews: PreviewProvider {
    static var previews: some View {
        ModifyWorkoutView()
    }
}
