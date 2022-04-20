//
//  RoundEditView.swift
//  Ceres
//
//  Created by Edmundas Matusevičius on 2022-03-31.
//

import SwiftUI
import UniformTypeIdentifiers

struct RoundEditView: View {
    @Environment(\.dismiss) var dismiss

    @StateObject var viewModel: RoundEditViewModel

    @State private var draggingMovement: Movement?

    @State private var metric: Metric?
    @State private var showMetricSheet = false
    @State private var movement: Movement?
    @State private var showMovementSheet = false

    private func metricListRow(_ selectedMetric: Metric) -> some View {
        Button(action: {
            metric = selectedMetric
            showMetricSheet.toggle()
        }, label: {
            Text("""
            \(selectedMetric.type.description) - \
            \(selectedMetric.value.formattedMetricValue)
            """)
        })
        .buttonStyle(DefaultButtonStyle())
        .foregroundColor(.primary)
    }

    private func movementListRow(_ selectedMovement: Movement) -> some View {
        Button(action: {
            movement = selectedMovement
            showMovementSheet.toggle()
        }, label: {
            VStack(alignment: .leading) {
                Text(selectedMovement.movementDefinition?.title ?? "Movement")
                if selectedMovement.metrics.count > 0 {
                    Spacer()
                }
                ForEach(selectedMovement.metrics) { metric in
                    Text("""
                    \(metric.type.description) - \
                    \(metric.value.formattedMetricValue)
                    """)
                    .foregroundColor(.secondary)
                }
                .padding(.leading, 16.0)
            }
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

    private func movementList() -> some View {
        Group {
            if let movements = viewModel.movements {
                ForEach(movements) { movement in
                    movementListRow(movement)
                        .onDrag {
                            draggingMovement = movement
                            return NSItemProvider(object: NSString())
                        }
                        .onDrop(of: [UTType.item], delegate: ListItemDragDelegate(current: $draggingMovement))
                }
                .onMove(perform: moveMovement)
                .onDelete(perform: deleteMovement)
            }
            Button(action: {
                showMovementSheet.toggle()
            }, label: {
                Label("Add round movement", systemImage: "plus.app")
            })
            .buttonStyle(PlainButtonStyle())
        }
    }

    private func editView() -> some View {
        List {
            Section {
                metricList()
            }
            Section {
                movementList()
            }
        }
        .listStyle(InsetGroupedListStyle())
        .navigationTitle("Round")
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel", action: cancelAction)
            }
            ToolbarItem(placement: .confirmationAction) {
                Button("Save", action: saveAction)
            }
        }
        .sheet(isPresented: $showMetricSheet, onDismiss: {
            updateRoundMetrics()
        }, content: {
            NavigationView {
                MetricEditView(viewModel: MetricEditViewModel(metric: $metric))
            }
        })
        .sheet(isPresented: $showMovementSheet, onDismiss: {
            updateRoundMovements()
        }, content: {
            NavigationView {
                MovementEditView(viewModel: MovementEditViewModel(movement: $movement))
            }
        })
    }

    var body: some View {
        _ = self.metric
        _ = self.movement

        return editView()
    }
}

extension RoundEditView {
    private func updateRoundMetrics() {
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

    private func updateRoundMovements() {
        guard let newMovement = movement else { return }
        Task {
            await viewModel.updateMovement(newMovement)
            movement = nil
        }
    }

    private func moveMovement(from source: IndexSet, to destination: Int) {
        viewModel.movements.move(fromOffsets: source, toOffset: destination)
    }

    private func deleteMovement(indexSet: IndexSet) {
        indexSet.forEach { index in
            Task {
                await viewModel.deleteMovement(at: index)
            }
        }
    }
}

extension RoundEditView {
    private func cancelAction() {
        dismiss()
    }

    private func saveAction() {
        viewModel.save()
        dismiss()
    }
}

/*
struct RoundEditView_Previews: PreviewProvider {
    static var previews: some View {
        RoundEditView()
    }
}
 */
