//
//  WorkoutEditView.swift
//  Ceres
//
//  Created by Edmundas Matusevičius on 2022-03-28.
//

import SwiftUI
import UniformTypeIdentifiers

struct WorkoutEditView: View {
    @Environment(\.dismiss) var dismiss

    @StateObject var viewModel: WorkoutEditViewModel

    @State private var draggingRound: Round?

    @State private var metric: Metric?
    @State private var showMetricSheet = false
    @State private var round: Round?
    @State private var showRoundSheet = false

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

    private func metricsListRow(_ metrics: [Metric]) -> some View {
        Group {
            if metrics.count > 0 {
                Spacer()
            }
            ForEach(metrics) { metric in
                Text("""
                \(metric.type.description) - \
                \(metric.displayableValue)
                """)
                .foregroundColor(Color(.gray))
            }
            .padding(.leading, 16.0)
        }
    }

    private func roundListRow(_ selectedRound: Round) -> some View {
        Button(action: {
            round = selectedRound
            showRoundSheet.toggle()
        }, label: {
            VStack(alignment: .leading) {
                ForEach(selectedRound.metrics) { metric in
                    metricListRow(metric)
                }
                ForEach(selectedRound.movements) { movement in
                    VStack(alignment: .leading) {
                        Spacer()
                        Text(movement.movementDefinition?.title ?? "Movement")
                            .foregroundColor(Color(.darkGray))
                        metricsListRow(movement.metrics)
                    }
                }
                .padding(.leading, 16.0)
            }
            .padding(.vertical, 6.0)
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
                showRoundSheet.toggle()
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
        .sheet(isPresented: $showMetricSheet, onDismiss: {
            updateWorkoutMetrics()
        }, content: {
            NavigationView {
                MetricEditView(viewModel: MetricEditViewModel(metric: $metric))
            }
        })
        .sheet(isPresented: $showRoundSheet, onDismiss: {
            updateWorkoutRounds()
        }, content: {
            NavigationView {
                RoundEditView(viewModel: RoundEditViewModel(round: $round))
            }
        })
    }

    var body: some View {
        _ = self.metric
        _ = self.round

        return editView()
    }
}

extension WorkoutEditView {
    private func updateWorkoutMetrics() {
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

    private func updateWorkoutRounds() {
        guard let newRound = round else { return }
        Task {
            await viewModel.updateRound(newRound)
            round = nil
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
        dismiss()
    }

    private func saveAction() {
        viewModel.save()
        dismiss()
    }
}

/*
struct WorkoutEditView_Previews: PreviewProvider {
    static var previews: some View {
        WorkoutEditView()
    }
}
 */
