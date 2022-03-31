//
//  RoundEditView.swift
//  Ceres
//
//  Created by Edmundas Matusevičius on 2022-03-31.
//

import SwiftUI

struct RoundEditView: View {
    @Environment(\.presentationMode) var presentationMode

    @StateObject var viewModel: RoundEditViewModel

    private func editView() -> some View {
        List {
            Text("Round")
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

extension RoundEditView {
    private func cancelAction() {
        presentationMode.wrappedValue.dismiss()
    }

    private func saveAction() {
        viewModel.save()
        presentationMode.wrappedValue.dismiss()
    }
}

/*
struct RoundEditView_Previews: PreviewProvider {
    static var previews: some View {
        RoundEditView()
    }
}
 */
