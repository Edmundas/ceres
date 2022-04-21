//
//  MetricEditView.swift
//  Ceres
//
//  Created by Edmundas Matusevičius on 2022-03-28.
//

import SwiftUI

struct MetricEditView: View {
    @Environment(\.dismiss) var dismiss

    @StateObject var viewModel: MetricEditViewModel

    private func valueFieldRow(_ value: Binding<String>) -> some View {
        TextField("Value", text: value)
            .modifier(ClearButton(text: value))
    }

    private func valueUnitRow(_ unit: String) -> some View {
        Text(unit)
    }

    private func typePickerRow() -> some View {
        Picker("Type", selection: $viewModel.type) {
            ForEach(MetricType.allCases, id: \.self) {
                Text($0.description)
            }
        }
    }

    private func editView() -> some View {
        List {
            Section(content: {
                valueFieldRow($viewModel.value1)
                    .keyboardType(viewModel.type == .duration ? .numberPad : .decimalPad)
            }, footer: {
                if let unit = viewModel.unit1 {
                    valueUnitRow(unit)
                }
            })
            if viewModel.type == .duration {
                Section(content: {
                    valueFieldRow($viewModel.value2)
                        .keyboardType(.numberPad)
                }, footer: {
                    if let unit = viewModel.unit2 {
                        valueUnitRow(unit)
                    }
                })
            }
            Section {
                typePickerRow()
            }
        }
        .listStyle(InsetGroupedListStyle())
        .navigationTitle("Metric")
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel", action: cancelAction)
            }
            ToolbarItem(placement: .confirmationAction) {
                Button("Save", action: saveAction)
            }
        }
    }

    var body: some View {
        editView()
    }
}

extension MetricEditView {
    private func cancelAction() {
        dismiss()
    }

    private func saveAction() {
        viewModel.save()
        dismiss()
    }
}

/*
struct MetricEditView_Previews: PreviewProvider {
    static var previews: some View {
        MetricEditView()
    }
}
 */
