//
//  CeresApp.swift
//  Ceres
//
//  Created by Edmundas Matusevicius on 2021-11-24.
//

import SwiftUI

@main
struct CeresApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
