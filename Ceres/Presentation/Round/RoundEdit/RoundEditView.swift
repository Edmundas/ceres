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

    class SheetMananger: ObservableObject {
        @Published var showSheet = false
        @Published var movement: Movement?
    }
    @StateObject private var sheetManager = SheetMananger()

    private func movementListRow(_ movement: Movement) -> some View {
        Button(action: {
            sheetManager.movement = movement
            sheetManager.showSheet.toggle()
        }, label: {
            Text("Movement")
        })
        .buttonStyle(DefaultButtonStyle())
        .foregroundColor(.primary)
    }

    private func movementsList() -> some View {
        Group {
            if let movements = viewModel.movements {
                ForEach(movements) { movement in
                    movementListRow(movement)
                }
                .onDelete(perform: deleteMovement)
            }
            Button(action: {
                sheetManager.showSheet.toggle()
            }, label: {
                Label("Add round movement", systemImage: "plus.app")
            })
            .buttonStyle(PlainButtonStyle())
        }
    }

    private func editView() -> some View {
        List {
            Section {
                movementsList()
            }
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
        .sheet(isPresented: $sheetManager.showSheet, onDismiss: {
            updateRoundMovements()
        }, content: {
            NavigationView {
                MovementEditView(viewModel: MovementEditViewModel(movement: $sheetManager.movement))
            }
        })
    }

    var body: some View {
        editView()
    }
}

extension RoundEditView {
    private func updateRoundMovements() {
        guard let newMovement = sheetManager.movement else { return }
        Task {
            await viewModel.updateMovement(newMovement)
            sheetManager.movement = nil
        }
    }

    private func deleteMovement(indexSet: IndexSet) {
        indexSet.forEach { index in
            Task {
                await viewModel.deleteMovement(at: index)
            }
        }
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
