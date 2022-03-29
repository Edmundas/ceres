//
//  WorkoutEditView.swift
//  Ceres
//
//  Created by Edmundas Matusevičius on 2022-03-28.
//

import SwiftUI

struct WorkoutEditView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @StateObject var vm: WorkoutEditViewModel
    
    class SheetMananger: ObservableObject {
        @Published var showSheet = false
        @Published var metric: Metric? = nil
    }
    @StateObject var sheetManager = SheetMananger()
    
    fileprivate func TitleRow() -> some View {
        TextField("Title", text: $vm.title)
            .modifier(ClearButton(text: $vm.title))
    }
    
    fileprivate func TypePickerRow() -> some View {
        Picker("Type", selection: $vm.type) {
            ForEach(WorkoutType.allCases, id: \.self) { type in
                Text(type == .none ? String(describing: type) : String(describing: type).uppercased())
            }
        }
    }
    
    fileprivate func CategoryPickerRow() -> some View {
        Picker("Category", selection: $vm.category) {
            ForEach(WorkoutCategory.allCases, id: \.self) { category in
                Text(category == .none ? String(describing: category) : String(describing: category).capitalized)
            }
        }
    }
    
    fileprivate func MetricListRow(_ metric: Metric) -> some View {
        Button(action: {
            sheetManager.metric = metric
            sheetManager.showSheet.toggle()
        }) {
            Text("\(metric.value) - \(String(describing: metric.type)) - \(String(describing: metric.subtype)) - \(String(describing: metric.unit))")
        }
        .buttonStyle(DefaultButtonStyle())
        .foregroundColor(.primary)
    }
    
    fileprivate func MetricList() -> some View {
        Group {
            if let metrics = vm.metrics {
                ForEach(metrics) { metric in
                    MetricListRow(metric)
                }
                .onDelete(perform: deleteMetric)
            }
            Button(action: {
                sheetManager.showSheet.toggle()
            }) {
                Label("Add workout metric", systemImage: "plus.app")
            }
            .buttonStyle(PlainButtonStyle())
        }
    }
    
    fileprivate func EditView() -> some View {
        List {
            Section {
                TitleRow()
            }
            Section {
                TypePickerRow()
                CategoryPickerRow()
            }
            Section {
                MetricList()
            }
            Section {
                // TODO: rounds
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
        .sheet(isPresented: $sheetManager.showSheet, onDismiss: {
            updateWorkoutMetrics()
        }) {
            NavigationView {
                MetricEditView(vm: MetricEditViewModel(metric: $sheetManager.metric))
            }
        }
    }
    
    var body: some View {
        EditView()
    }
}

extension WorkoutEditView {
    private func updateWorkoutMetrics() {
        guard let newMetric = sheetManager.metric else { return }
        Task {
            await vm.updateMetric(newMetric)
            sheetManager.metric = nil
        }
    }

    private func deleteMetric(indexSet: IndexSet) {
        indexSet.forEach { index in
            Task {
                await vm.deleteMetric(at: index)
            }
        }
    }
}

extension WorkoutEditView {
    private func cancelAction() {
        presentationMode.wrappedValue.dismiss()
    }
    
    private func saveAction() {
        vm.save()
        presentationMode.wrappedValue.dismiss()
    }
}

//struct WorkoutEditView_Previews: PreviewProvider {
//    static var previews: some View {
//        WorkoutEditView()
//    }
//}
