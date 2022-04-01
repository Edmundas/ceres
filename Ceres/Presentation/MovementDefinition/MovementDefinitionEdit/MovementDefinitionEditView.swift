//
//  MovementDefinitionEditView.swift
//  Ceres
//
//  Created by Edmundas Matusevičius on 2022-04-01.
//

import SwiftUI

struct MovementDefinitionEditView: View {
    @Environment(\.presentationMode) var presentationMode

    @StateObject var viewModel: MovementDefinitionEditViewModel

    private func titleRow() -> some View {
        TextField("Title", text: $viewModel.title)
            .modifier(ClearButton(text: $viewModel.title))
    }

    private func editView() -> some View {
        List {
            titleRow()
        }
        .listStyle(InsetGroupedListStyle())
        .navigationTitle("Movement Definition")
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

extension MovementDefinitionEditView {
    private func cancelAction() {
        presentationMode.wrappedValue.dismiss()
    }

    private func saveAction() {
        viewModel.save()
        presentationMode.wrappedValue.dismiss()
    }
}

/*
struct MovementDefinitionEditView_Previews: PreviewProvider {
    static var previews: some View {
        MovementDefinitionEditView()
    }
}
 */
