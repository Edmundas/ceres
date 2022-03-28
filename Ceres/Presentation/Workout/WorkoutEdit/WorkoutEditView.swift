//
//  WorkoutEditView.swift
//  Ceres
//
//  Created by Edmundas Matusevičius on 2022-03-28.
//

import SwiftUI

struct WorkoutEditView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @StateObject var vm: WorkoutEditViewModel
    
    @State private var showingEditMetricSheet = false
    @State private var metric: Metric?
    
    fileprivate func EditView() -> some View {
        List {
            Section {
                TextField("Title", text: $vm.title)
                    .modifier(ClearButton(text: $vm.title))
            }
            Section {
                Picker("Type", selection: $vm.type) {
                    ForEach(WorkoutType.allCases, id: \.self) { type in
                        Text(type == .none ? String(describing: type) : String(describing: type).uppercased())
                    }
                }
                Picker("Category", selection: $vm.category) {
                    ForEach(WorkoutCategory.allCases, id: \.self) { category in
                        Text(category == .none ? String(describing: category) : String(describing: category).capitalized)
                    }
                }
            }
            Section {
                // TODO: metrics
                if let metrics = vm.metrics {
                    ForEach(metrics) { metric in
                        Button(action: {
                            self.metric = metric
                            showingEditMetricSheet.toggle()
                        }) {
                            Text("\(metric.value) - \(String(describing: metric.type)) - \(String(describing: metric.subtype)) - \(String(describing: metric.unit))")
                        }
                        .buttonStyle(DefaultButtonStyle())
                        .foregroundColor(.primary)
                    }
                    .onDelete(perform: deleteMetric)
                }
                Button(action: {
                    showingEditMetricSheet.toggle()
                }) {
                    Label("Add workout metric", systemImage: "plus.app")
                    
                }
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
        .sheet(isPresented: $showingEditMetricSheet, onDismiss: {
            updateWorkoutMetrics()
        }) {
            NavigationView {
                MetricEditView(vm: MetricEditViewModel(metric: $metric))
            }
        }
    }
    
    var body: some View {
        EditView()
    }
}

extension WorkoutEditView {
    private func updateWorkoutMetrics() {
        guard let newMetric = metric else { return }
        if vm.metrics.contains(newMetric) {
            let index = vm.metrics.firstIndex(of: newMetric)!
            vm.metrics.remove(at: index)
            vm.metrics.insert(newMetric, at: index)
        } else {
            vm.metrics.append(newMetric)
        }
        metric = nil
    }

    private func deleteMetric(indexSet: IndexSet) {
        indexSet.forEach { index in
            Task {
                await vm.deleteMetric(at: index)
            }
        }
    }
}

extension WorkoutEditView {
    private func cancelAction() {
        presentationMode.wrappedValue.dismiss()
    }
    
    private func saveAction() {
        if vm.workout != nil {
            Task { await vm.updateWorkout() }
        } else {
            Task { await vm.createWorkout() }
        }
        presentationMode.wrappedValue.dismiss()
    }
}

//struct WorkoutEditView_Previews: PreviewProvider {
//    static var previews: some View {
//        WorkoutEditView()
//    }
//}
