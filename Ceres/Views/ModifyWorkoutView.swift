//
//  ModifyWorkoutView.swift
//  Ceres
//
//  Created by Edmundas Matusevicius on 2021-11-24.
//

import SwiftUI

struct ModifyWorkoutView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @StateObject var viewModel: ModifyWorkoutViewModel
    
    @State private var showingModifyMetricSheet = false
    @State private var metric: DMMetric?
    
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
                        Button(action: {
                            self.metric = metric
                            showingModifyMetricSheet.toggle()
                        },
                               label: {
                            Text("\(metric.value) - \(metric.type) - \(metric.subtype) - \(metric.unit)")
                        })
                        .buttonStyle(DefaultButtonStyle())
                        .foregroundColor(.primary)
                    }
                }
                Button(
                    action: { showingModifyMetricSheet.toggle() },
                    label: { Label("Add workout metric", systemImage: "plus.app") }
                )
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
                Button("Cancel", action: cancelAction)
            }
            ToolbarItem(placement: .confirmationAction) {
                Button("Save", action: saveAction)
            }
        }
        .sheet(isPresented: $showingModifyMetricSheet,
               onDismiss: { updateWorkoutMetrics() },
               content: {
            NavigationView {
                ModifyMetricView(viewModel: ModifyMetricViewModel(metric: $metric))
            }
        })
    }
}

extension ModifyWorkoutView {
    private func updateWorkoutMetrics() {
        guard let newMetric = metric else { return }
        if viewModel.metrics.contains(newMetric) {
            let index = viewModel.metrics.firstIndex(of: newMetric)!
            viewModel.metrics.remove(at: index)
            viewModel.metrics.insert(newMetric, at: index)
        } else {
            viewModel.metrics.append(newMetric)
        }
        metric = nil
    }
}

extension ModifyWorkoutView {
    private func cancelAction() {
        presentationMode.wrappedValue.dismiss()
    }
    
    private func saveAction() {
        viewModel.save()
        presentationMode.wrappedValue.dismiss()
    }
}

//struct ModifyWorkoutView_Previews: PreviewProvider {
//    static var previews: some View {
//        ModifyWorkoutView()
//    }
//}
