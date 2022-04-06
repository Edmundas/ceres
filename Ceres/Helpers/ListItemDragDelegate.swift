//
//  ListItemDragDelegate.swift
//  Ceres
//
//  Created by Edmundas Matusevičius on 2022-03-31.
//

import SwiftUI

struct ListItemDragDelegate<Item: Equatable>: DropDelegate {
    @Binding var current: Item?

    func dropUpdated(info: DropInfo) -> DropProposal? {
        DropProposal(operation: .move)
    }

    func performDrop(info: DropInfo) -> Bool {
        current = nil
        return true
    }
}
