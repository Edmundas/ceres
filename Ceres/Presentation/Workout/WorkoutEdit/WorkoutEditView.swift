//
//  WorkoutEditView.swift
//  Ceres
//
//  Created by Edmundas Matusevičius on 2022-03-28.
//

import SwiftUI

struct WorkoutEditView: View {
    @Environment(\.presentationMode) var presentationMode

    @StateObject var viewModel: WorkoutEditViewModel

    class SheetMananger: ObservableObject {
        @Published var showSheet = false
        @Published var metric: Metric?
    }
    @StateObject var sheetManager = SheetMananger()

    fileprivate func titleRow() -> some View {
        TextField("Title", text: $viewModel.title)
            .modifier(ClearButton(text: $viewModel.title))
    }

    fileprivate func typePickerRow() -> some View {
        Picker("Type", selection: $viewModel.type) {
            ForEach(WorkoutType.allCases, id: \.self) { type in
                Text(type == .none ? String(describing: type) : String(describing: type).uppercased())
            }
        }
    }

    fileprivate func categoryPickerRow() -> some View {
        Picker("Category", selection: $viewModel.category) {
            ForEach(WorkoutCategory.allCases, id: \.self) { category in
                Text(category == .none ? String(describing: category) : String(describing: category).capitalized)
            }
        }
    }

    fileprivate func metricListRow(_ metric: Metric) -> some View {
        Button(action: {
            sheetManager.metric = metric
            sheetManager.showSheet.toggle()
        }, label: {
            Text("""
            \(metric.value) - \
            \(String(describing: metric.type)) - \
            \(String(describing: metric.subtype)) - \
            \(String(describing: metric.unit))
            """)
        })
        .buttonStyle(DefaultButtonStyle())
        .foregroundColor(.primary)
    }

    fileprivate func metricList() -> some View {
        Group {
            if let metrics = viewModel.metrics {
                ForEach(metrics) { metric in
                    metricListRow(metric)
                }
                .onDelete(perform: deleteMetric)
            }
            Button(action: {
                sheetManager.showSheet.toggle()
            }, label: {
                Label("Add workout metric", systemImage: "plus.app")
            })
            .buttonStyle(PlainButtonStyle())
        }
    }

    fileprivate func editView() -> some View {
        List {
            Section {
                titleRow()
            }
            Section {
                typePickerRow()
                categoryPickerRow()
            }
            Section {
                metricList()
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
        .sheet(isPresented: $sheetManager.showSheet, onDismiss: {
            updateWorkoutMetrics()
        }, content: {
            NavigationView {
                MetricEditView(viewModel: MetricEditViewModel(metric: $sheetManager.metric))
            }
        })
    }

    var body: some View {
        editView()
    }
}

extension WorkoutEditView {
    private func updateWorkoutMetrics() {
        guard let newMetric = sheetManager.metric else { return }
        Task {
            await viewModel.updateMetric(newMetric)
            sheetManager.metric = nil
        }
    }

    private func deleteMetric(indexSet: IndexSet) {
        indexSet.forEach { index in
            Task {
                await viewModel.deleteMetric(at: index)
            }
        }
    }
}

extension WorkoutEditView {
    private func cancelAction() {
        presentationMode.wrappedValue.dismiss()
    }

    private func saveAction() {
        viewModel.save()
        presentationMode.wrappedValue.dismiss()
    }
}

/*
struct WorkoutEditView_Previews: PreviewProvider {
    static var previews: some View {
        WorkoutEditView()
    }
}
 */
