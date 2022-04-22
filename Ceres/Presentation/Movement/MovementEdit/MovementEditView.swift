//
//  MovementEditView.swift
//  Ceres
//
//  Created by Edmundas Matusevičius on 2022-03-31.
//

import SwiftUI

struct MovementEditView: View {
    @Environment(\.dismiss) var dismiss

    @StateObject var viewModel: MovementEditViewModel

    @State private var metric: Metric?
    @State private var showMetricSheet = false

    private func movementDefinitionRow(_ movementDefinition: MovementDefinition?) -> some View {
        NavigationLink(
            destination: MovementDefinitionListView(
                viewModel: MovementDefinitionListViewModel(),
                isSelectionOnly: true,
                selectedMovementDefinition: $viewModel.movementDefinition),
            label: {
                HStack {
                    Text("Movement definition")
                    Spacer()
                    Text("\(movementDefinition != nil ? movementDefinition!.title : "none")")
                        .foregroundColor(.secondary)
                }
            })
    }

    private func metricListRow(_ selectedMetric: Metric) -> some View {
        Button(action: {
            metric = selectedMetric
            showMetricSheet.toggle()
        }, label: {
            Text("""
            \(selectedMetric.type.description) - \
            \(selectedMetric.displayableValue)
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
                showMetricSheet.toggle()
            }, label: {
                Label("Add workout metric", systemImage: "plus.app")
            })
            .buttonStyle(PlainButtonStyle())
        }
    }

    private func editView() -> some View {
        List {
            Section {
                movementDefinitionRow(viewModel.movementDefinition)
            }
            Section {
                metricList()
            }
        }
        .listStyle(InsetGroupedListStyle())
        .navigationTitle("Movement")
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel", action: cancelAction)
            }
            ToolbarItem(placement: .confirmationAction) {
                Button("Save", action: saveAction)
            }
        }
        .sheet(isPresented: $showMetricSheet, onDismiss: {
            updateMovementMetrics()
        }, content: {
            NavigationView {
                MetricEditView(viewModel: MetricEditViewModel(metric: $metric))
            }
        })
    }

    var body: some View {
        _ = self.metric

        return editView()
    }
}

extension MovementEditView {
    private func updateMovementMetrics() {
        guard let newMetric = metric else { return }
        Task {
            await viewModel.updateMetric(newMetric)
            metric = nil
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

extension MovementEditView {
    private func cancelAction() {
        dismiss()
    }

    private func saveAction() {
        viewModel.save()
        dismiss()
    }
}

/*
struct MovementEditView_Previews: PreviewProvider {
    static var previews: some View {
        MovementEditView()
    }
}
 */
