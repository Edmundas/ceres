//
//  RoundEditView.swift
//  Ceres
//
//  Created by Edmundas Matusevičius on 2022-03-31.
//

import SwiftUI
import UniformTypeIdentifiers

struct RoundEditView: View {
    @Environment(\.presentationMode) var presentationMode

    @StateObject var viewModel: RoundEditViewModel

    @State private var draggingMovement: Movement?

    class MetricSheetMananger: ObservableObject {
        @Published var showSheet = false
        @Published var metric: Metric?
    }
    @StateObject private var metricSheetManager = MetricSheetMananger()

    class MovementSheetMananger: ObservableObject {
        @Published var showSheet = false
        @Published var movement: Movement?
    }
    @StateObject private var movementSheetManager = MovementSheetMananger()

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

    private func movementListRow(_ movement: Movement) -> some View {
        Button(action: {
            movementSheetManager.movement = movement
            movementSheetManager.showSheet.toggle()
        }, label: {
            Text("Movement")
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
                movementSheetManager.showSheet.toggle()
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
        .sheet(isPresented: $metricSheetManager.showSheet, onDismiss: {
            updateRoundMetrics()
        }, content: {
            NavigationView {
                MetricEditView(viewModel: MetricEditViewModel(metric: $metricSheetManager.metric))
            }
        })
        .sheet(isPresented: $movementSheetManager.showSheet, onDismiss: {
            updateRoundMovements()
        }, content: {
            NavigationView {
                MovementEditView(viewModel: MovementEditViewModel(movement: $movementSheetManager.movement))
            }
        })
    }

    var body: some View {
        editView()
    }
}

extension RoundEditView {
    private func updateRoundMetrics() {
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

    private func updateRoundMovements() {
        guard let newMovement = movementSheetManager.movement else { return }
        Task {
            await viewModel.updateMovement(newMovement)
            movementSheetManager.movement = nil
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
        presentationMode.wrappedValue.dismiss()
    }

    private func saveAction() {
        viewModel.save()
        presentationMode.wrappedValue.dismiss()
    }
}

/*
struct RoundEditView_Previews: PreviewProvider {
    static var previews: some View {
        RoundEditView()
    }
}
 */
