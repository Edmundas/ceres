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

    private func titleRow() -> some View {
        TextField("Title", text: $viewModel.title)
            .modifier(ClearButton(text: $viewModel.title))
    }

    private func pickerRow<T: WorkoutEnums>(title: String, selection: Binding<T>) -> some View {
        var allCases: [T]
        switch selection.wrappedValue {
        case is WorkoutType:
            allCases = (WorkoutType.allCases as? [T]) ?? []
        case is WorkoutCategory:
            allCases = (WorkoutCategory.allCases as? [T]) ?? []
        default:
            allCases = []
        }

        return Picker(title, selection: selection) {
            ForEach(allCases, id: \.self) {
                Text(String(describing: $0))
            }
        }
    }

    private func metricListRow(_ metric: Metric) -> some View {
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

    private func metricList() -> some View {
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

    private func editView() -> some View {
        List {
            Section {
                titleRow()
            }
            Section {
                pickerRow(title: "Type", selection: $viewModel.type)
                pickerRow(title: "Category", selection: $viewModel.category)
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
