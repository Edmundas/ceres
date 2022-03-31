//
//  MovementEditView.swift
//  Ceres
//
//  Created by Edmundas Matusevičius on 2022-03-31.
//

import SwiftUI

struct MovementEditView: View {
    @Environment(\.presentationMode) var presentationMode

    @StateObject var viewModel: MovementEditViewModel

    private func editView() -> some View {
        List {
            Text("Movement")
        }
        .listStyle(InsetGroupedListStyle())
        .navigationTitle("Round")
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

extension MovementEditView {
    private func cancelAction() {
        presentationMode.wrappedValue.dismiss()
    }

    private func saveAction() {
        viewModel.save()
        presentationMode.wrappedValue.dismiss()
    }
}

/*
struct MovementEditView_Previews: PreviewProvider {
    static var previews: some View {
        MovementEditView()
    }
}
 */
