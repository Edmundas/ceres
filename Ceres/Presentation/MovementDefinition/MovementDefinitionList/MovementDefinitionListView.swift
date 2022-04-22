//
//  MovementDefinitionListView.swift
//  Ceres
//
//  Created by Edmundas Matusevičius on 2022-04-01.
//

import SwiftUI

struct MovementDefinitionListView: View {
    @Environment(\.dismiss) var dismiss

    @StateObject var viewModel: MovementDefinitionListViewModel

    @State var isSelectionOnly = false
    @Binding var selectedMovementDefinition: MovementDefinition?

    @State private var movementDefinition: MovementDefinition?
    @State private var showMovementDefinitionSheet = false

    private func emptyListRow() -> some View {
        Label("The list is empty", systemImage: "exclamationmark.circle")
    }

    private func listRow(_ movementDefinition: MovementDefinition) -> some View {
        Button(action: {
            if isSelectionOnly {
                selectionAction(movementDefinition: movementDefinition)
            } else {
                // TODO: show movement definition details
                assertionFailure("TODO: show movement definition details")
            }
        }, label: {
            Text("\(movementDefinition.title)")
        })
        .buttonStyle(DefaultButtonStyle())
        .foregroundColor(.primary)
    }

    private func movementDefinitionList() -> some View {
        List {
            if viewModel.movementDefinitions.isEmpty {
                emptyListRow()
            }
            ForEach(viewModel.movementDefinitions) { item in
                listRow(item)
            }
        }
        .listStyle(InsetGroupedListStyle())
        .navigationTitle("Movement Definitions")
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button(action: { showMovementDefinitionSheet.toggle() },
                       label: { Image(systemName: "plus") })
            }
        }
        .sheet(isPresented: $showMovementDefinitionSheet, onDismiss: {
            updateMovementDefinitions()
        }, content: {
            NavigationView {
                MovementDefinitionEditView(
                    viewModel: MovementDefinitionEditViewModel(
                        movementDefinition: $movementDefinition))
            }
            // workaround for layout constraints errors
            .navigationViewStyle(.stack)
        })
        .task {
           await viewModel.getMovementDefinitions()
        }
        .alert("Error", isPresented: $viewModel.hasError, actions: { }, message: {
            Text(viewModel.errorMessage)
        })
    }

    var body: some View {
        _ = self.movementDefinition

        return movementDefinitionList()
    }
}

extension MovementDefinitionListView {
    private func updateMovementDefinitions() {
        Task {
            await viewModel.getMovementDefinitions()
            movementDefinition = nil
        }
    }
}

extension MovementDefinitionListView {
    private func selectionAction(movementDefinition: MovementDefinition) {
        selectedMovementDefinition = movementDefinition
        dismiss()
    }
}

/*
struct MovementDefinitionListView_Previews: PreviewProvider {
    static var previews: some View {
        MovementDefinitionListView()
    }
}
 */
