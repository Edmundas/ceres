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

    fileprivate func valueRow() -> some View {
        TextField("Value", text: $viewModel.value)
            .modifier(ClearButton(text: $viewModel.value))
    }

    fileprivate func typePicker() -> some View {
        Picker("Type", selection: $viewModel.type) {
            ForEach(MetricType.allCases, id: \.self) { type in
                Text(type == .none ? String(describing: type) : String(describing: type))
            }
        }
    }

    fileprivate func subtypePicker() -> some View {
        Picker("Subtype", selection: $viewModel.subtype) {
            ForEach(MetricSubtype.allCases, id: \.self) { subtype in
                Text(subtype == .none ? String(describing: subtype) : String(describing: subtype))
            }
        }
    }

    fileprivate func unitPicker() -> some View {
        Picker("Unit", selection: $viewModel.unit) {
            ForEach(MetricUnit.allCases, id: \.self) { unit in
                Text(unit == .none ? String(describing: unit) : String(describing: unit))
            }
        }
    }

    fileprivate func editView() -> some View {
        List {
            Section {
                valueRow()
            }
            Section {
                typePicker()
                subtypePicker()
                unitPicker()
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
