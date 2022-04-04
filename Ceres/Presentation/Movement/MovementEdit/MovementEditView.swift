//
//  MovementEditView.swift
//  Ceres
//
//  Created by Edmundas Matusevičius on 2022-03-31.
//

import SwiftUI

struct MovementEditView: View {
    @Environment(\.presentationMode) var presentationMode

    @StateObject var viewModel: MovementEditViewModel

    class MetricSheetMananger: ObservableObject {
        @Published var showSheet = false
        @Published var metric: Metric?
    }
    @StateObject private var metricSheetManager = MetricSheetMananger()

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

    private func metricListRow(_ metric: Metric) -> some View {
        Button(action: {
            metricSheetManager.metric = metric
            metricSheetManager.showSheet.toggle()
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
                metricSheetManager.showSheet.toggle()
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
        .sheet(isPresented: $metricSheetManager.showSheet, onDismiss: {
            updateMovementMetrics()
        }, content: {
            NavigationView {
                MetricEditView(viewModel: MetricEditViewModel(metric: $metricSheetManager.metric))
            }
        })
    }

    var body: some View {
        editView()
    }
}

extension MovementEditView {
    private func updateMovementMetrics() {
        guard let newMetric = metricSheetManager.metric else { return }
        Task {
            await viewModel.updateMetric(newMetric)
            metricSheetManager.metric = nil
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
        presentationMode.wrappedValue.dismiss()
    }

    private func saveAction() {
        viewModel.save()
        presentationMode.wrappedValue.dismiss()
    }
}

/*
struct MovementEditView_Previews: PreviewProvider {
    static var previews: some View {
        MovementEditView()
    }
}
 */
