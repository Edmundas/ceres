//
//  ModifyMetricView.swift
//  Ceres
//
//  Created by Edmundas Matusevičius on 2022-02-04.
//

import SwiftUI

struct ModifyMetricView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @StateObject private var viewModel = ModifyMetricViewModel()
    
    @Binding var metric: DMMetric?
    
    var body: some View {
        List {
            Section {
                TextField("Value", text: $viewModel.value)
                    .modifier(ClearButton(text: $viewModel.value))
            }
            Section {
                Picker("Type", selection: $viewModel.type) {
                    ForEach(DMMetricType.allCases, id: \.self) { type in
                        Text(type == .none ? String(describing: type) : String(describing: type))
                    }
                }
                Picker("Subtype", selection: $viewModel.subtype) {
                    ForEach(DMMetricSubtype.allCases, id: \.self) { subtype in
                        Text(subtype == .none ? String(describing: subtype) : String(describing: subtype))
                    }
                }
                Picker("Unit", selection: $viewModel.unit) {
                    ForEach(DMMetricUnit.allCases, id: \.self) { unit in
                        Text(unit == .none ? String(describing: unit) : String(describing: unit))
                    }
                }
            }
        }
        .listStyle(InsetGroupedListStyle())
        .onAppear {
//            viewModel.metric = metric
            print("_APPEAR_")
        }
        .onChange(of: metric) { _ in
            print("_CHANGE_")
        }
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
}

extension ModifyMetricView {
    private func cancelAction() {
        presentationMode.wrappedValue.dismiss()
    }
    
    private func saveAction() {
//        metric = viewModel.metric
        presentationMode.wrappedValue.dismiss()
    }
}

//struct ModifyMetricView_Previews: PreviewProvider {
//    static var previews: some View {
//        ModifyMetricView(metric: .constant(nil))
//    }
//}
