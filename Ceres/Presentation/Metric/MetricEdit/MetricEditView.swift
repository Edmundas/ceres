//
//  MetricEditView.swift
//  Ceres
//
//  Created by Edmundas Matusevičius on 2022-03-28.
//

import SwiftUI

struct MetricEditView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @StateObject var vm: MetricEditViewModel
    
    fileprivate func EditView() -> some View {
        List {
            Section {
                TextField("Value", text: $vm.value)
                    .modifier(ClearButton(text: $vm.value))
            }
            Section {
                Picker("Type", selection: $vm.type) {
                    ForEach(MetricType.allCases, id: \.self) { type in
                        Text(type == .none ? String(describing: type) : String(describing: type))
                    }
                }
                Picker("Subtype", selection: $vm.subtype) {
                    ForEach(MetricSubtype.allCases, id: \.self) { subtype in
                        Text(subtype == .none ? String(describing: subtype) : String(describing: subtype))
                    }
                }
                Picker("Unit", selection: $vm.unit) {
                    ForEach(MetricUnit.allCases, id: \.self) { unit in
                        Text(unit == .none ? String(describing: unit) : String(describing: unit))
                    }
                }
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
        EditView()
    }
}

extension MetricEditView {
    private func cancelAction() {
        vm.cancel()
        presentationMode.wrappedValue.dismiss()
    }
    
    private func saveAction() {
        vm.save()
        presentationMode.wrappedValue.dismiss()
    }
}

//struct MetricEditView_Previews: PreviewProvider {
//    static var previews: some View {
//        MetricEditView()
//    }
//}
