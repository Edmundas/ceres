//
//  WorkoutEditView.swift
//  Ceres
//
//  Created by Edmundas Matusevičius on 2022-03-28.
//

import SwiftUI
import UniformTypeIdentifiers

struct WorkoutEditView: View {
    @Environment(\.presentationMode) var presentationMode

    @StateObject var viewModel: WorkoutEditViewModel

    @State private var draggingRound: Round?

    class MetricSheetMananger: ObservableObject {
        @Published var showSheet = false
        @Published var metric: Metric?
    }
    @StateObject private var metricSheetManager = MetricSheetMananger()

    class RoundSheetManager: ObservableObject {
        @Published var showSheet = false
        @Published var round: Round?
    }
    @StateObject private var roundSheetManager = RoundSheetManager()

    private func titleRow() -> some View {
        TextField("Title", text: $viewModel.title)
            .modifier(ClearButton(text: $viewModel.title))
    }

    private func typePickerRow() -> some View {
        Picker("Type", selection: $viewModel.type) {
            ForEach(WorkoutType.allCases, id: \.self) {
                Text($0.description)
            }
        }
    }

    private func metricListRow(_ metric: Metric) -> some View {
        Button(action: {
            metricSheetManager.metric = metric
            metricSheetManager.showSheet.toggle()
        }, label: {
            Text("""
            \(metric.type.description) - \
            \(metric.value.formattedMetricValue)
            """)
        })
        .buttonStyle(DefaultButtonStyle())
        .foregroundColor(.primary)
    }

    private func metricsListRow(_ metrics: [Metric]) -> some View {
        Group {
            if metrics.count > 0 {
                Spacer()
            }
            ForEach(metrics) { metric in
                Text("""
                \(metric.type.description) - \
                \(metric.value.formattedMetricValue)
                """)
                .foregroundColor(.secondary)
            }
        }
    }

    private func roundListRow(_ round: Round) -> some View {
        Button(action: {
            roundSheetManager.round = round
            roundSheetManager.showSheet.toggle()
        }, label: {
            VStack(alignment: .leading) {
                Text("Round")
                metricsListRow(round.metrics)
                ForEach(round.movements) { movement in
                    VStack(alignment: .leading) {
                        Spacer()
                        Text(movement.movementDefinition?.title ?? "Movement")
                            .foregroundColor(.secondary)
                        metricsListRow(movement.metrics)
                    }
                    .padding(.leading, 20.0)
                }
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
                metricSheetManager.showSheet.toggle()
            }, label: {
                Label("Add workout metric", systemImage: "plus.app")
            })
            .buttonStyle(PlainButtonStyle())
        }
    }

    private func roundList() -> some View {
        Group {
            if let rounds = viewModel.rounds {
                ForEach(rounds) { round in
                    roundListRow(round)
                        .onDrag {
                            draggingRound = round
                            return NSItemProvider(object: NSString())
                        }
                        .onDrop(of: [UTType.item], delegate: ListItemDragDelegate(current: $draggingRound))
                }
                .onMove(perform: moveRound)
                .onDelete(perform: deleteRound)
            }
            Button(action: {
                roundSheetManager.showSheet.toggle()
            }, label: {
                Label("Add workout round", systemImage: "plus.app")
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
                typePickerRow()
            }
            Section {
                metricList()
            }
            Section {
                roundList()
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
        .sheet(isPresented: $metricSheetManager.showSheet, onDismiss: {
            updateWorkoutMetrics()
        }, content: {
            NavigationView {
                MetricEditView(viewModel: MetricEditViewModel(metric: $metricSheetManager.metric))
            }
        })
        .sheet(isPresented: $roundSheetManager.showSheet, onDismiss: {
            updateWorkoutRounds()
        }, content: {
            NavigationView {
                RoundEditView(viewModel: RoundEditViewModel(round: $roundSheetManager.round))
            }
        })
    }

    var body: some View {
        editView()
    }
}

extension WorkoutEditView {
    private func updateWorkoutMetrics() {
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

    private func updateWorkoutRounds() {
        guard let newRound = roundSheetManager.round else { return }
        Task {
            await viewModel.updateRound(newRound)
            roundSheetManager.round = nil
        }
    }

    private func moveRound(from source: IndexSet, to destination: Int) {
        viewModel.rounds.move(fromOffsets: source, toOffset: destination)
    }

    private func deleteRound(indexSet: IndexSet) {
        indexSet.forEach { index in
            Task {
                await viewModel.deleteRound(at: index)
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
