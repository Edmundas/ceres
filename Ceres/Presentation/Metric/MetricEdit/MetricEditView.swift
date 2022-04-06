//
//  MetricEditView.swift
//  Ceres
//
//  Created by Edmundas Matusevičius on 2022-03-28.
//

import SwiftUI

struct MetricEditView: View {
    @Environment(\.presentationMode) var presentationMode

    @StateObject var viewModel: MetricEditViewModel

    private func valueRow() -> some View {
        TextField("Value", text: $viewModel.value)
            .modifier(ClearButton(text: $viewModel.value))
    }

    private func typePickerRow() -> some View {
        Picker("Type", selection: $viewModel.type) {
            ForEach(MetricType.allCases, id: \.self) {
                Text(String(describing: $0))
            }
        }
    }

    private func editView() -> some View {
        List {
            Section {
                valueRow()
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
        presentationMode.wrappedValue.dismiss()
    }

    private func saveAction() {
        viewModel.save()
        presentationMode.wrappedValue.dismiss()
    }
}

/*
struct MetricEditView_Previews: PreviewProvider {
    static var previews: some View {
        MetricEditView()
    }
}
 */
