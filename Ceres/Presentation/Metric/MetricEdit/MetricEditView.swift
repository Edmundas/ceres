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

    private func picker<T: MetricEnums>(title: String, selection: Binding<T>) -> some View {
        var allCases: [T]
        switch selection.wrappedValue {
        case is MetricType:
            allCases = (MetricType.allCases as? [T]) ?? []
        case is MetricSubtype:
            allCases = (MetricSubtype.allCases as? [T]) ?? []
        case is MetricUnit:
            allCases = (MetricUnit.allCases as? [T]) ?? []
        default:
            allCases = []
        }

        return Picker(title, selection: selection) {
            ForEach(allCases, id: \.self) {
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
                picker(title: "Type", selection: $viewModel.type)
                picker(title: "Subtype", selection: $viewModel.subtype)
                picker(title: "Unit", selection: $viewModel.unit)
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
